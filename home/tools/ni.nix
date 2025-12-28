{ pkgs, ... }:
let
  runScript = impure: ''
    # Check if at least one argument is provided
    if [ $# -lt 1 ]; then
      echo "Usage: $0 <package> [args...]"
      exit 1
    fi

    # First argument is the package
    package="$1"

    # Shift arguments so $@ contains only the remaining args
    shift

    # Run nix with the package and remaining arguments
    NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$package" ${impure} -- "$@"
  '';

  shellScript = impure: ''
    # Check if at least one argument is provided
    if [ $# -lt 1 ]; then
      echo "Usage: $0 <package>"
      exit 1
    fi

    # First argument is the package
    package="$1"

    # Run nix with the package and remaining arguments
    NIXPKGS_ALLOW_UNFREE=1 nix shell "nixpkgs#$package" ${impure}
  '';
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "n" (runScript ""))
    (pkgs.writeShellScriptBin "ni" (runScript "--impure"))
    (pkgs.writeShellScriptBin "ns" (runScript ""))
    (pkgs.writeShellScriptBin "nsi" (shellScript "--impure"))
  ];
}
