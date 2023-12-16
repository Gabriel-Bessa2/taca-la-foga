#!/bin/sh
echo -ne '\033c\033]0;Taca-la-foga\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Taca-la-foga.x86_64" "$@"
