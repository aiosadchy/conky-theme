#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

cd "${SCRIPT_DIR}"

readonly FONTS_DIR="${HOME}/.local/share/fonts"

mkdir -p "${FONTS_DIR}"
cp "./fonts/ArizoneUnicaseRegular.ttf" "${FONTS_DIR}"
