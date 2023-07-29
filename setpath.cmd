@echo off
cls
title WolfNet Computing Boot Tools
setlocal
if not exist VERSION (
	echo VERSION file doesn't exist!
	echo Unknown version error.
	set "version=??"
) else (
	set /p version=<VERSION
)
echo Setting up environment for WolfNet Computing Boot Tools...
echo You're running version: %version%
endlocal
cmd /T:0A /E:ON /V:ON /S /K "set PATH=%~dp0;%PATH% && cd %~dp0"