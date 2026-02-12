echo Truly a great install!!

cd
cp -r /iso/source disko_install
nixos-generate-config --no-filesystems --dir gen
sudo cp gen/hardware-configuration.nix disko_install
echo Generated hardware config:
echo ===========================
cat gen/hardware-configuration.nix
echo ===========================
lsblk
echo Select what disk you want to install to:
echo WARNING: THIS WILL ERASE EVERYTHING!!
read mydisk
sudo disko-install --write-efi-boot-entries --flake disko_install/#minimal --disk main $mydisk

echo Copying config to system...
sudo mount /dev/disk/by-partlabel/disk-main-root lol -m
sudo rmdir lol/persistent/data/home/eschb/nixcfg
sudo cp -r disko_install lol/persistent/data/home/eschb/nixcfg
sudo umount lol
