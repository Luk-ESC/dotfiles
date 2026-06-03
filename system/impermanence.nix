{
  pkgs,
  utils,
  lib,
  ...
}:
{
  boot.initrd.systemd.extraBin.sed = lib.getExe pkgs.gnused;
  boot.initrd.systemd.services.impermanence-setup =
    let
      # TODO: this depends on diskos undocumented naming scheme :(
      disk = "/dev/disk/by-partlabel/disk-main-root";
    in
    {
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = true;
      # The script needs to run to completion before this service is done
      serviceConfig.Type = "oneshot";
      # This service is required for boot to succeed
      requiredBy = [ "initrd.target" ];
      # Should complete before any file systems are mounted
      before = [ "sysroot.mount" ];

      path = with pkgs; [
        busybox
        coreutils
        btrfs-progs
      ];

      # TODO: are these the right services?
      after = [
        "initrd-root-device.target"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      description = "Set up new root";

      script = ''
        mkdir /btrfs_tmp
        export PATH="/bin:$PATH"

        mount -t btrfs -o subvol=/persistent/old_roots ${disk} /btrfs_tmp

        for i in $(find /btrfs_tmp/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
        done

        # TODO: fix timezone
        timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
        new_root="/btrfs_tmp/$timestamp"

        btrfs subvolume create "$new_root"
        # TODO: can i just use the subvolume path here, instead of goofy sed
        id="$(btrfs subvolume show "$new_root" | sed -n 's/.*Subvolume ID:[[:space:]]*//p')"

        ln -sfn "$timestamp" /btrfs_tmp/current

        umount /btrfs_tmp

        mount ${disk} /btrfs_tmp
        btrfs subvolume set-default "$id" /btrfs_tmp
        umount /btrfs_tmp
      '';
    };
}
