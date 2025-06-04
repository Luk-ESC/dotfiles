set -e
sudo nix build .#nixosConfigurations.base.config.system.build.isoImage
echo "qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso" | sudo nix shell nixpkgs#qemu
