-- Ravel shared dependency paths
-- Convention: each subproject keeps its private vendor under <Subproject>/vendor/.
-- This file centralizes include paths so subprojects can reference them by name.

IncludeDir = {}
IncludeDir["json"]        = "%{wks.location}/../Ravel/vendor/json/include"
IncludeDir["spdlog"]      = "%{wks.location}/../Ravel/vendor/spdlog/include"
IncludeDir["stduuid"]     = "%{wks.location}/../Ravel/vendor/stduuid/include"
IncludeDir["cli11"]       = "%{wks.location}/../Ravel-Runner/vendor/cli11/include"
IncludeDir["googletest"]  = "%{wks.location}/../Ravel-Tests/vendor/googletest/googletest/include"
IncludeDir["googlemock"]  = "%{wks.location}/../Ravel-Tests/vendor/googletest/googlemock/include"

-- libravel_core public header root (consumers add this to includedirs and
-- then #include "ravel/runtime/session.h" etc.)
IncludeDir["ravel"]       = "%{wks.location}/../Ravel/src"
