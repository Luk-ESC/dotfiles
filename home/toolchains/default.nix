{ minimal, lib, ... }:
{
  # Programming toolchains
  imports = lib.optionals (!minimal) [
    ./c.nix
    ./fenix.nix
    ./go.nix
    ./java.nix
    ./js.nix
    ./lua.nix
    ./qml.nix
    ./r.nix
    ./uv.nix
  ];
}
