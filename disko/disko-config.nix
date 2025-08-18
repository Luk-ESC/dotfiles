{ lib, ... }:
let
  reasonable_subvolume = name: extraOptions: {
    ${name} = {
      mountpoint = name;
      mountOptions = [ "noatime" ] ++ extraOptions;
    };
  };

  reasonable_subvolumes =
    opts:
    lib.mergeAttrsList (map (x: reasonable_subvolume ("/" + x.name) x.value) (lib.attrsToList opts));
in
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/vda"; # TODO: make dynamic
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "128M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            # Subvolumes must set a mountpoint in order to be mounted,
            # unless their parent is mounted
            subvolumes =
              {
                # Subvolume name is different from mountpoint
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "noatime" ];
                };
              }
              // reasonable_subvolumes {
                "persistent" = [ ];
                "persistent/data" = [ "compress=zstd" ];
                "persistent/old_roots" = [ "compress=zstd:15" ];
                "persistent/logs" = [ "compress=zstd:15" ];
                "persistent/caches" = [ ];
                "persistent/session" = [ ];
                "nix" = [ "compress=zstd" ];
              };
          };
        };
      };
    };
  };
}
