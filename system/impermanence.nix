{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot.initrd.systemd.services.impermanence-setup = {
    # The script needs to run to completion before this service is done
    serviceConfig.Type = "oneshot";
    # This service is required for boot to succeed
    requiredBy = [ "initrd.target" ];
    # Should complete before any file systems are mounted
    before = [ "sysroot.mount" ];

    # TODO: are these the right services?
    after = [
      "initrd-root-device.target"
      # Allow hibernation to resume before trying to alter any data
      "local-fs-pre.target"
    ];

    description = "Set up new root";

    script =
      let
        # TODO: this depends on diskos undocumented naming scheme :(
        disk = "/dev/disk/by-partlabel/disk-main-root";
        # TODO: this is really ugly
        tz = lib.removeSuffix "\n" (
          builtins.readFile (
            pkgs.runCommandLocal "posix-tz" { } ''
              tail -n 1 ${pkgs.tzdata}/share/zoneinfo/${config.time.timeZone} > $out
            ''
          )
        );
      in
      # bash
      ''
        mkdir /btrfs_tmp
        export PATH="/bin:$PATH"

        mount -t btrfs -o subvol=/persistent/old_roots ${disk} /btrfs_tmp

        for i in $(find /btrfs_tmp/ -maxdepth 1 -mtime +30); do
            btrfs subvolume delete --recursive "$i"
        done

        timestamp=$(TZ="${tz}" date "+%Y-%m-%d_%H:%M:%S")
        new_root="/btrfs_tmp/$timestamp"

        btrfs subvolume create "$new_root"
        btrfs subvolume set-default "$new_root"

        ln -sfn "$timestamp" /btrfs_tmp/current

        umount /btrfs_tmp
      '';
  };
}
