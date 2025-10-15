#!/bin/bash

airootfs=(airootfs/etc)

# Grub
mkdir -p "$airootfs/default"
cp -r "/etc/default/grub" "$airootfs/default"

# Wheel Group
mkdir -p "$airootfs/sudoers.d"
g_wheel=($airootfs/sudoers.d/g_wheel)
echo "%wheel ALL=(ALL:ALL) ALL" > $g_wheel

# Symbolic Links
## NetworkManager
mkdir -p "$airootfs/systemd/system/multi-user.target.wants"
ln -sv "/usr/lib/systemd/system/NetworkManager.service" "$airootfs/systemd/system/multi-user.target.wants"

mkdir -p "$airootfs/systemd/system/network-online.target.wants"
ln -sv "/usr/lib/systemd/system/NetworkManager-wait-online.service" "$airootfs/systemd/system/network-online.target.wants"

ln -sv "/usr/lib/systemd/system/NetworkManager-dispatcher.service" "$airootfs/systemd/system/dbus.org.freedesktop.dispatcher.service"

## Bluetooth
ln -sv "/usr/lib/systemd/system/bluetooth.service" "$airootfs/systemd/system/network-online.target.wants"

## Graphical Target
ln -sv "/usr/lib/systemd/system/graphical.target" "$airootfs/systemd/system/default.target"

## SDDM
ln -sv "/usr/lib/systemd/system/sddm.service" "$airootfs/systemd/system/display-manager.service"

# SDDM Conf
mkdir -p "$airootfs/sddm.conf.d"
sed -n '1,35p' /usr/lib/sddm/sddm.conf.d/default.conf > $airootfs/sddm.conf 
sed -n '38,137p' /usr/lib/sddm/sddm.conf.d/default.conf > $airootfs/sddm.conf.d/kde_settings.conf

# Desktop Environment
sed -i 's/Session=/Session=plasma.desktop/' $airootfs/sddm.conf

# Display Server
sed -i 's/DisplayServer=x11/DisplayServer=wayland/' $airootfs/sddm.conf

# Numlock
sed -i 's/Numlock=none/Numlock=on/' $airootfs/sddm.conf

# User
user=jsmith
sed -i 's/User=/User='$user'/' $airootfs/sddm.conf

## Hostname
echo julianlinux > $airootfs/hostname

# Adding the new user
if grep -q "$user" $airootfs/passwd 2> /dev/null; then
    echo -e "\nUser Found..."
else
    sed -i '1 a\'"$user:x:1000:1000::/home/$user:/usr/bin/bash" $airootfs/passwd
    echo -e "\nUser not Found..."
fi

# Password
hash_pd=$(openssl passwd -6 password)

if grep -o "$user" $airootfs/shadow > /dev/null; then
    echo -e "\nPassword exists, not modifying."
else
    sed -i '1 a\'"$user:$hash_pd:14871::::::" $airootfs/shadow
    echo -e "\nModifying the password"
fi

# Group
touch $airootfs/group
echo -e "root:x:0:root\nadm:x:4:$user\nwheel:x:10:$user\nuucp:x:14:$user\n$user:x:1000:$user" > $airootfs/group

# GShadow
touch $airootfs/gshadow
echo -e "root:!*::root\n$user:!*::" > $airootfs/gshadow

# Grub Cfg
grubcfg=(grub/grub.cfg)
sed -i 's/default=archlinux/default=julianlinux/' $grubcfg
sed -i 's/menuentry "Arch/menuentry "JulianLinux/' $grubcfg

if ! grep -q 'archisosearchuuid=%ARCHISO_UUID% cow_spacesize=10G copytoram=n' $grubcfg 2> /dev/null; then
    sed -i 's/archisosearchuuid=%ARCHISO_UUID%/archisosearchuuid=%ARCHISO_UUID% cow_spacesize=10G copytoram=n/' $grubcfg
fi

if ! grep -q '#play' $grubcfg 2> /dev/null; then
    sed -i 's/play/#play/' $grubcfg
fi

# Entries
efiloader=(efiboot/loader)
sed -i 's/Arch/JulianLinux/' $efiloader/entries/01-archiso-linux.conf
sed -i 's/Arch/JulianLInux/' $efiloader/entries/02-archiso-speech-linux.conf

# Loader
sed -i 's/beed on/beep off/' $efiloader/loader.conf
