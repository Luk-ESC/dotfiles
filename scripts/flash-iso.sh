#!/usr/bin/env bash
set -e
echo Building ISO...
sudo nix build .#nixosConfigurations.base.config.system.build.isoImage
du -h result/iso/*
echo Select disk to write ISO to:
lsblk
read mydisk
sudo popsicle result/iso/nixos-*.iso $mydisk
