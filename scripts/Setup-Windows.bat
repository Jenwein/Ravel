@echo off
REM One-time setup on Windows: fetch submodules and generate Visual Studio 2022 solution.

pushd %~dp0\..\

set PREMAKE=vendor\premake\bin\windows\premake5.exe
if not exist "%PREMAKE%" (
    echo error: %PREMAKE% not found.
    echo   Download the Windows premake5 binary from https://premake.github.io/download
    echo   and place it at %PREMAKE%.
    popd
    exit /b 1
)

echo Updating git submodules...
git submodule update --init --recursive

echo Generating Visual Studio 2022 solution...
"%PREMAKE%" vs2022

echo.
echo Setup complete. Open build\Ravel.sln in Visual Studio,
echo or build from the command line with: msbuild build\Ravel.sln /p:Configuration=Debug
popd
PAUSE
