@echo off

set TMP_DIR=T:

for /D %%G in (%TMP_DIR%\*) do (
	echo  Archiving plugin: "%%~nG"
	cabarc -p -P %%~dpnG -r N .\%%~nG.cab %%~dpnG\*
)
pause