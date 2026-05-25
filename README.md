**English** · [简体中文](README.zh-CN.md)

# Ravel

A library-first, native C++ agent foundation. See `docs/project-charter.md`
for direction and `openspec/changes/define-ravel-core-runtime/` for the
active spec.

> Status: spec-first, scaffold-only — modules are placeholders pending the
> runtime contract.

## Getting started

```bash
git clone --recursive git@github.com:Jenwein/Ravel.git
cd Ravel
scripts/Setup-Linux.sh        # macOS: Setup-Mac.sh   ·   Windows: Setup-Windows.bat
make -C build config=debug -j$(nproc)
./build/bin/Debug-linux-x86_64/Ravel-Tests/Ravel-Tests
```

The Premake 5 binary is bundled under `vendor/premake/bin/<platform>/`, so no
system-wide install is required. Place the macOS/Windows binaries under
`vendor/premake/bin/macosx/` or `vendor/premake/bin/windows/` once before the
first build on that platform.

Requires a compiler with C++23 support (GCC 13+, Clang 16+, MSVC 19.37+).

## Dependencies

Build tool:
- [Premake 5](https://premake.github.io/) — workspace generator (v5.0.0-beta7 binary bundled)

`Ravel/vendor/` (library, header-only git submodules):
- [nlohmann/json](https://github.com/nlohmann/json) v3.12.0 — JSON values and event serialization
- [spdlog](https://github.com/gabime/spdlog) v1.17.0 — logging (header-only mode)
- [stduuid](https://github.com/mariusbancila/stduuid) v1.2.3 — UUID / session identifiers

`Ravel-Runner/vendor/`:
- [CLI11](https://github.com/CLIUtils/CLI11) v2.6.2 — CLI argument parsing

`Ravel-Tests/vendor/`:
- [GoogleTest + GoogleMock](https://github.com/google/googletest) v1.17.0

HTTP/TLS client (libcurl, OpenSSL, or a lighter alternative) is deferred to
the model adapter implementation.
