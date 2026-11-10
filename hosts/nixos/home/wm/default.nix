{ lib, minimal, ... }:
{
  # The window manager and relevant settings
  imports = [
    ./niri.nix
    ./keep.nix
  ]
  ++ (lib.optionals (!minimal) [
    ./cursor.nix
    ./stylix.nix
  ]);
}
