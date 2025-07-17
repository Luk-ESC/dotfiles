{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  loc = config.persist;
  base = (pkgs.callPackage (./base.nix) { });
in
{
  options.persist = base.persistentOption;

  config.home.persistence = builtins.listToAttrs (
    map (
      name: with loc.${name}; {
        name = prefix + name;
        value = base.dirsAndFiles false contents;
      }
    ) (builtins.attrNames loc)
  );
}
