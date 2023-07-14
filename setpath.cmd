@echo off
echo Setting up environment for WolfNet Computing Boot Tools...
echo You're running version:
type %~dp0\VERSION
cmd /Q /T:0A /E:ON /V:ON /S /K "set PATH=%~dp0;%PATH% && cd %~dp0"