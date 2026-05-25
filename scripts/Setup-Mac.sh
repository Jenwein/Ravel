#!/usr/bin/env bash
# One-time setup on macOS: fetch submodules and generate Xcode project files.
set -euo pipefail

cd "$(dirname "$0")/.."

PREMAKE="vendor/premake/bin/macosx/premake5"
if [[ ! -x "$PREMAKE" ]]; then
    echo "error: $PREMAKE not found or not executable" >&2
    echo "  Download the macOS premake5 binary from https://premake.github.io/download" >&2
    echo "  and place it at $PREMAKE." >&2
    exit 1
fi

echo "Updating git submodules..."
git submodule update --init --recursive

echo "Generating Xcode project files..."
"$PREMAKE" xcode4

echo
echo "Setup complete. Open the generated workspace under build/ in Xcode,"
echo "or run: make -C build config=debug -j\$(sysctl -n hw.ncpu)"
