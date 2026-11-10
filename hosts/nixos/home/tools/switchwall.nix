{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "switchwall" ''
      # Check if at least one argument is provided
      wallpaper="$1"
      activated=0

      # Iterate over home-manager generations
      tac ~/.cache/hm_generations | while IFS= read -r line; do
        # Extract the first /nix/store/... path from the line
        path="$(grep -oE '/nix/store/[^ ]+' <<<"$line" | head -n1 || true)"

        # Skip if no path found on this line
        [[ -n "${"path:-"}" ]] || continue

        if [[ -d "$path/specialisation" ]]; then
          path="$path/specialisation"
          if [[ -z "$wallpaper" ]]; then
            echo "All specialisations:"
            ls $path
            exit 1;
          fi
          
          activate="$path/$wallpaper/activate"
          if [[ -x "$activate" ]]; then
            echo "activating now"
            "$activate" --driver-version 1
            activated=1
            exit 0
          fi

          exit 0
        fi
      done
      exit 1
    '')
  ];
}
