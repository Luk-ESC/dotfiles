{ minimal, lib, ... }:
{
  # Programming toolchains
  imports = lib.optionals (!minimal) [
    ./c.nix
    ./rust.nix
    ./go.nix
    ./java.nix
    ./js.nix
    ./lua.nix
    ./qml.nix
    ./r.nix
    ./python.nix
  ];
}
