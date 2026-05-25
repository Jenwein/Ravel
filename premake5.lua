-- Ravel root workspace
-- Scope: scaffold only (define-ravel-core-runtime tasks.md section 1).
-- Generators: Linux gmake2, macOS gmake2/xcode4, Windows vs2022.

include "Dependencies.lua"

workspace "Ravel"
    configurations { "Debug", "Release" }
    architecture   "x86_64"
    startproject   "Ravel-Tests"
    location       "build"

    flags { "MultiProcessorCompile" }

    outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

    filter "system:linux"
        toolset "gcc"
    filter "system:macosx"
        toolset "clang"
        buildoptions { "-stdlib=libc++" }
        linkoptions  { "-stdlib=libc++" }
    filter "system:windows"
        systemversion "latest"
        defines { "_CRT_SECURE_NO_WARNINGS", "NOMINMAX" }
        buildoptions { "/utf-8" }
    filter {}

include "Ravel"
include "Ravel-Runner"
include "Ravel-Tests"
