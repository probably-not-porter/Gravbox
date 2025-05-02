#!/bin/sh
echo -ne '\033c\033]0;Gravbox\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/gravbox.x86_64" "$@"
