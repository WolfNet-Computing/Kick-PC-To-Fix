@echo off
for /D %%G in (T:\*) do (
	echo  Archiving plugin: "%%~nG"
	cabarc -p -P %%~dpnG -r N .\%%~nG.cab %%~dpnG\*
)
pause