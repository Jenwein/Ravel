@echo off
REM Regenerate Visual Studio 2022 solution without touching submodules.
pushd %~dp0\..\
call vendor\premake\bin\windows\premake5.exe vs2022
popd
PAUSE
