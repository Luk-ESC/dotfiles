{ lib, ... }:
{
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-partlabel/disk-main-root /btrfs_tmp # TODO: this depends on diskos undocumented naming scheme :(

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/persistent/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    # TODO: fix timezone
    timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
    new_root="/btrfs_tmp/persistent/old_roots/$timestamp"

    btrfs subvolume create "$new_root"
    id="$(btrfs subvolume show "$new_root" | sed -n 's/.*Subvolume ID:[[:space:]]*//p')"
    # TODO: can i just use the subvolume path here, instead of goofy sed
    btrfs subvolume set-default "$id" /btrfs_tmp

    ln -sfn "$timestamp" /btrfs_tmp/persistent/old_roots/current

    umount /btrfs_tmp
  '';
}
