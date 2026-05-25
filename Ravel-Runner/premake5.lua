project "Ravel-Runner"
    kind        "ConsoleApp"
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
        "src",
        "%{IncludeDir.ravel}",
        "%{IncludeDir.cli11}",
        "%{IncludeDir.spdlog}",
    }

    links { "Ravel" }

    filter "configurations:Debug"
        symbols  "On"
        defines  { "RAVEL_DEBUG" }
    filter "configurations:Release"
        optimize "On"
        defines  { "RAVEL_RELEASE" }
    filter {}
