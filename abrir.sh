#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Not enough arguments!"
    exit 1
fi

app_root="$1"
new_name="$2"
info="$app_root/Contents/Info.plist"
macos="$app_root/Contents/MacOS"
binary="$(ls $macos)"

plutil -replace CFBundleExecutable -string "$new_name" "$info"
mv "$macos/$binary" "$macos/$new_name"
mv "$app_root" "$(dirname "$app_root")/$new_name.app"
