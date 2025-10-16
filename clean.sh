#!/bin/bash

sudo rm -rf {work,build}

sudo rm -rf {airootfs/etc/skel/.config/nvim,airootfs/etc/skel/.local/share/nvim,airootfs/etc/skel/.local/state/nvim}

sudo rm -rf {airootfs/root/.config/nvim,airootfs/root/.local/share/nvim,airootfs/root/.local/state/nvim}
