#!/usr/bin/env bash

# Code stolen from https://github.com/victor-falcon/zellij-sessionizer

SEARCH_PATHS=("$HOME/ZedProjects" "$HOME/Documents/School/4EHIF")
SPECIFIC_PATHS=("$HOME/nixcfg")

script_path="$(realpath "$0")"
script_dir="$(dirname "$script_path")"
LAYOUT_FILE="$script_dir/layout.kdl"

# Collect all directories
all_dirs=()

# Add first-level directories from SEARCH_PATHS
for search_path in "${SEARCH_PATHS[@]}"; do
  if [[ -d "$search_path" ]]; then
    for dir in "$search_path"/*; do
      if [[ -d "$dir" ]]; then
        all_dirs+=("$dir")
      fi
    done
  fi
done

# Add SPECIFIC_PATHS
for specific_path in "${SPECIFIC_PATHS[@]}"; do
  if [[ -d "$specific_path" ]]; then
    all_dirs+=("$specific_path")
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
  zellij attach "$session_name" || zellij -n $LAYOUT_FILE -s "$session_name"
fi
