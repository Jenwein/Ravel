#!/usr/bin/env bash
# Regenerate Xcode project files on macOS without touching submodules.
set -euo pipefail

cd "$(dirname "$0")/.."
exec vendor/premake/bin/macosx/premake5 xcode4
