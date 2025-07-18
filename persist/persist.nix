{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.persist;
  loc = cfg.location;
  base = (pkgs.callPackage (./base.nix) { });
in
{
  options.persist = with types; {
    users = mkOption {
      description = "users to persist";
      default = [ ];
      type = listOf types.str;
    };
    location = base.persistentOption;
  };

  inherit
    (
      let
        fileSystems = builtins.listToAttrs (
          map (
            name: with loc.${name}; {
              name = prefix + name;
              value.neededForBoot = true;
            }
          ) (builtins.attrNames loc)
        );
      in
      {
        config.fileSystems = fileSystems;
        config.virtualisation.vmVariantWithDisko.virtualisation.fileSystems = fileSystems;

        config.environment.persistence = builtins.listToAttrs (
          map (
            name: with loc.${name}; {
              name = prefix + name;
              value = base.dirsAndFiles true contents // {
                hideMounts = true;

                users = builtins.listToAttrs (
                  map (name: {
                    name = name;
                    value = base.dirsAndFiles false contents;
                  }) cfg.users
                );
              };
            }
          ) (builtins.attrNames loc)
        );
      }
    )
    config
    ;
}
