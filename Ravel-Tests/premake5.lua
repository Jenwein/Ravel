project "Ravel-Tests"
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
        -- GoogleTest + GoogleMock built directly from source into this target
        "vendor/googletest/googletest/src/gtest-all.cc",
        "vendor/googletest/googlemock/src/gmock-all.cc",
    }

    includedirs {
        "src",
        "%{IncludeDir.ravel}",
        "%{IncludeDir.googletest}",
        "%{IncludeDir.googlemock}",
        "vendor/googletest/googletest",
        "vendor/googletest/googlemock",
        "%{IncludeDir.json}",
        "%{IncludeDir.spdlog}",
    }

    links { "Ravel" }

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
