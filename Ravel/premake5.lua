project "Ravel"
    kind        "StaticLib"
    language    "C++"
    cppdialect  "C++23"
    staticruntime "On"
    warnings    "Extra"

    targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
    objdir    ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "src/**.h",
        "src/**.cpp",
    }

    includedirs {
        "src",                   -- consumers #include "ravel/<module>/<file>.h"
        "%{IncludeDir.json}",
        "%{IncludeDir.spdlog}",
        "%{IncludeDir.stduuid}",
    }

    -- spdlog defaults to header-only when its compiled lib is absent;
    -- no need to define SPDLOG_HEADER_ONLY explicitly.

    filter "configurations:Debug"
        symbols  "On"
        defines  { "RAVEL_DEBUG" }
    filter "configurations:Release"
        optimize "On"
        defines  { "RAVEL_RELEASE" }
    filter "system:linux"
        links { "pthread" }
    filter "system:macosx"
        links { "pthread" }
    filter {}
