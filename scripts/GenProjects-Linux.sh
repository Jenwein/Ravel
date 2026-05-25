#!/usr/bin/env bash
# Regenerate gmake project files on Linux without touching submodules.
set -euo pipefail

cd "$(dirname "$0")/.."
exec vendor/premake/bin/linux/premake5 gmake2
