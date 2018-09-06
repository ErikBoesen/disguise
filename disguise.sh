#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"

function task { printf "* $1.\n"; }
function fail {
    printf "${RED}$1${RESET}\n" >&2
    exit 1
}
function succ { printf "${GREEN}$1${RESET}\n"; }

if [[ $# -lt 1 ]]; then
    fail "Not enough arguments!"
fi

app_root="$1"
new_name="${2%.app}"
if [[ -z ${new_name}.app ]]; then
    new_name=$(openssl rand -hex 8)
fi

info="$app_root/Contents/Info.plist"
macos="$app_root/Contents/MacOS"
# TODO: plutil has replaced PlistBuddy, but cannot seem to read properties as we here desire.
binary="$(/usr/libexec/PlistBuddy "$info" -c "Print :CFBundleExecutable")"

task "Overwriting CFBundleName property"
plutil -replace CFBundleName -string "$new_name" "$info"
task "Renaming executable"
mv "$macos/$binary" "$macos/$new_name"
task "Renaming bundle"
mv "$app_root" "$(dirname "$app_root")/$new_name.app"
task "Creating symlink"
cd "$new_name.app/Contents/MacOS"
ln -s "$new_name" "$binary"

succ "Successfully disguised $app_root as $new_name.app."
