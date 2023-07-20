@echo off
if not exist ./bfd.cfg (
	if exist ./bfd.sam (
		xcopy bfd.sam bfd.cfg /Q /V /-I 
	) else (
		echo ERROR: No default configuration file to merge into!
		pause
		exit 1
	)
)

if not exist ./plugin.cfg (
	echo ERROR: No plugin configuration file to merge with main configuration!
	pause
	exit 1
)

for /F "tokens=*" %%I in (./plugin.cfg) do (
	echo %%I >> bfd.cfg
)