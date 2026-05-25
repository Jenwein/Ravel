#!/usr/bin/env bash
# One-time setup on Linux: fetch submodules and generate gmake project files.
set -euo pipefail

cd "$(dirname "$0")/.."

PREMAKE="vendor/premake/bin/linux/premake5"
if [[ ! -x "$PREMAKE" ]]; then
    echo "error: $PREMAKE not found or not executable" >&2
    exit 1
fi

echo "Updating git submodules..."
git submodule update --init --recursive

echo "Generating gmake project files..."
"$PREMAKE" gmake2

echo
echo "Setup complete. Build with:"
echo "  make -C build config=debug -j\$(nproc)"
