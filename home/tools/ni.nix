{ pkgs, ... }:
let
  prefix = ''
    # Check if at least one argument is provided
    if [ $# -lt 1 ]; then
      echo "Usage: $0 <package> [args...]"
      exit 1
    fi

    # First argument is the package
    package="$1"
  '';

  runScript = impure: ''
    ${prefix}

    # Shift arguments so $@ contains only the remaining args
    shift

    NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$package" ${impure} -- "$@"
  '';

  shellScript = impure: ''
    ${prefix}

    NIXPKGS_ALLOW_UNFREE=1 nix shell "nixpkgs#$package" ${impure}
  '';

  develop = ''
    nix develop ".#$1" -c zsh
  '';
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "n" (runScript ""))
    (pkgs.writeShellScriptBin "ni" (runScript "--impure"))
    (pkgs.writeShellScriptBin "ns" (shellScript ""))
    (pkgs.writeShellScriptBin "nsi" (shellScript "--impure"))
    (pkgs.writeShellScriptBin "nd" develop)
  ];
}
