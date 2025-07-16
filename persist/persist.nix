{ lib, config, ... }:
with lib;
let
  cfg = config.persist;
  loc = config.persist.location;
  isDirectory = lib.hasSuffix "/";
  isSystem = lib.hasPrefix "/";
  not = f: a: !(f a);
  stripTrailing = p: lib.substring 0 (builtins.stringLength p - 1) p;
  filter2 = f: g: c: builtins.filter f (builtins.filter g c);
in {
  options.persist = with types; {
    users = mkOption {
      description = "users to persist";
      default = [];
      type = listOf types.str;
    };
    location = mkOption {
      description = "submodule example";
      type = attrsOf (submodule {
        options = {
          prefix = mkOption {
            default = "/persistent/";
            type = strMatching "^/([[:alnum:]_]+/)?$";
          };
          contents = mkOption {
            default = [ ];
            type = nonEmptyListOf nonEmptyStr;
          };
        };
      });
    };
  };

  # fileSystems."/persistent/data".neededForBoot = true;
  # fileSystems."/persistent/caches".neededForBoot = true;
  # fileSystems."/persistent/logs".neededForBoot = true;
  inherit (let
    fileSystems = builtins.listToAttrs (map (name:
      with loc.${name}; {
        name = prefix + name;
        value = { neededForBoot = true; };
      }) (builtins.attrNames loc));
  in {
    config.fileSystems = fileSystems;
    config.virtualisation.vmVariantWithDisko.virtualisation.fileSystems =
      fileSystems;

    config.environment.persistence = builtins.listToAttrs (map (name:
      with loc.${name}; {
        name = prefix + name;
        value = {
          hideMounts = true;
          directories =
            map stripTrailing (filter2 isSystem isDirectory contents);
          files = filter2 isSystem (not isDirectory) contents;

          users = builtins.listToAttrs (map (name: {
            name = name;
            value = {
              directories =
                map stripTrailing (filter2 (not isSystem) isDirectory contents);
              files = filter2 (not isSystem) (not isDirectory) contents;
            };
          }) cfg.users);
        };
      }) (builtins.attrNames loc));
  })
    config;
}
