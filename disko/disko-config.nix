{ lib, ... }:
let
  reasonable_subvolume = name: {
    ${name} = {
      mountpoint = name;
      mountOptions = [ "noatime" ];
    };
  };

  reasonable_subvolumes = opts: lib.mergeAttrsList (map (x: reasonable_subvolume ("/" + x)) opts);
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
            subvolumes = {
              # Subvolume name is different from mountpoint
              "/root" = {
                mountpoint = "/";
                mountOptions = [ "noatime" ];
              };
              "/swap" = {
                mountpoint = "/.swapvol";
                swap.swapfile.size = "20G"; # no hibernation >:()
              };
            }
            // reasonable_subvolumes [
              "persistent"
              "persistent/data"
              "persistent/old_roots"
              "persistent/logs"
              "persistent/caches"
              "persistent/session"
              "nix"
            ];
          };
        };
      };
    };
  };
}
