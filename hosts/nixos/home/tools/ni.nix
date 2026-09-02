{ pkgs, ... }:
let
  impure = x: if x then "--impure" else "";

  prefix = ''
    # Check if at least one argument is provided
    if [ $# -lt 1 ]; then
      echo "Usage: $0 <package> [args...]"
      exit 1
    fi

    # First argument is the package
    package="$1"
  '';

  runScript = i: ''
    ${prefix}

    # Shift arguments so $@ contains only the remaining args
    shift

    NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$package" ${impure i} -- "$@"
  '';

  shellScript = i: ''
    ${prefix}

    NIXPKGS_ALLOW_UNFREE=1 nix shell "nixpkgs#$package" ${impure i}
  '';

  develop = ''
    nix develop ".#$1" -c zsh
  '';
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "n" (runScript false))
    (pkgs.writeShellScriptBin "ni" (runScript true))
    (pkgs.writeShellScriptBin "ns" (shellScript false))
    (pkgs.writeShellScriptBin "nsi" (shellScript true))
    (pkgs.writeShellScriptBin "nd" develop)
  ];
}
