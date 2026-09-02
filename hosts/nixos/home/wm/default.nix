{ lib, minimal, ... }:
{
  # The window manager and relevant settings
  imports = [
    ./niri.nix
    ./noctalia.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./cursor.nix
    ./stylix.nix
  ]);
}
