#!/bin/bash

airootfs=(airootfs/etc)

# Grub
mkdir -p "$airootfs/default"
cp -r "/etc/default/grub" "$airootfs/default"

# Wheel Group
mkdir -p "$airootfs/sudoers.d"
g_wheel=($airootfs/sudoers.d/g_wheel)
echo "%wheel ALL=(ALL:ALL) ALL" > $g_wheel
