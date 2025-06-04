echo Truly a great install!!
lsblk
echo Select what disk you want to install to:
echo WARNING: THIS WILL ERASE EVERYTHING!!
read mydisk
sudo disko-install --write-efi-boot-entries --flake /iso/source/#nixos --disk main $mydisk
