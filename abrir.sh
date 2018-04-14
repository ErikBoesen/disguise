#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"

function fail {
    printf "${RED}$1${RESET}\n" >&2
    exit 1
}

if [[ $# -lt 2 ]]; then
    fail "Not enough arguments!"
fi

app_root="$1"
new_name="$2"
info="$app_root/Contents/Info.plist"
macos="$app_root/Contents/MacOS"
binary="$(ls $macos)"

plutil -replace CFBundleExecutable -string "$new_name" "$info"
mv "$macos/$binary" "$macos/$new_name"
mv "$app_root" "$(dirname "$app_root")/$new_name.app"
