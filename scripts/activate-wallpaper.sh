#!/usr/bin/env bash

input="$1"

# Get basename
filename="$(basename -- "$input")"

# Remove everything after first dot
name="${filename%%.*}"

# Add prefix
specName="wallpaper-$name"

switchwall "$specName"
