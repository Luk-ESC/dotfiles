{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "ni" ''
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
      nix run "nixpkgs#$package" -- "$@"
    '')
  ];
}
