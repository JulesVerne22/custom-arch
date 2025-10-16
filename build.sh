#!/bin/bash

# Setup Neovim offline configs
tar -xzvf local/artifacts/nvim-config.tar.gz -C airootfs/root/.config
tar -xzvf local/artifacts/nvim-share.tar.gz -C airootfs/root/.local/share
tar -xzvf local/artifacts/nvim-state.tar.gz -C airootfs/root/.local/state
tar -xzvf local/artifacts/nvim-config.tar.gz -C airootfs/etc/skel/.config
tar -xzvf local/artifacts/nvim-share.tar.gz -C airootfs/etc/skel/.local/share
tar -xzvf local/artifacts/nvim-state.tar.gz -C airootfs/etc/skel/.local/state

# Build iso
mkdir -p {work,build}

sudo mkarchiso -v -w work -o build .
