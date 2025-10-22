#!/usr/bin/env bash

# Code stolen from https://github.com/victor-falcon/zellij-sessionizer

SEARCH_PATHS=("$HOME/ZedProjects" "$HOME/Documents/School/4EHIF" "$HOME/nixcfg")

script_path="$(realpath "$0")"
script_dir="$(dirname "$script_path")"
LAYOUT_FILE="$script_dir/layout.kdl"

# Collect all directories
all_dirs=()

# Recursive function to process a directory
process_dir() {
  local dir="$1"

  if [[ -f "$dir/.parent" ]]; then
    # If .parent exists, recurse into subdirectories
    for subdir in "$dir"/*/; do
      [[ -d "$subdir" ]] && process_dir "$subdir"
    done
  else
    # If no .parent file, add this directory
    all_dirs+=("$dir")
  fi
}

# Process each search path
for search_path in "${SEARCH_PATHS[@]}"; do
  if [[ -d "$search_path" ]]; then
    process_dir "$search_path"
  fi
done

# Use fzf to select a directory
selected_dir=$(printf '%s\n' "${all_dirs[@]}" | fzf --prompt="Select project: ")

# Exit if nothing was selected
if [[ -z "$selected_dir" ]]; then
  exit 0
fi

# Create session name from directory basename
session_name=$(basename "$selected_dir")

# Change to session
if [[ -v "$ZELLIJ" ]]; then
  # if we are in a zellij sesssion
  zellij pipe --plugin https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm -- "--session $session_name --cwd $selected_dir"
else
  # if we are not in a zellij session
  cd "$selected_dir"
  if nix develop -c true; then
    nix develop -c sh -c "zellij attach '$session_name' || zellij -n $LAYOUT_FILE -s '$session_name'"
  else
    zellij attach "$session_name" || zellij -n $LAYOUT_FILE -s "$session_name"
  fi
fi
