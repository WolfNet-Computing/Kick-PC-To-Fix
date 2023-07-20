@echo off
if not exist ./bfd.cfg (
	if exist ./bfd.sam (
		xcopy ./bfd.sam ./bfd.cfg /Q
	) else (
		echo ERROR: No default configuration file to merge into!
	)
)

if not exist ./plugin.cfg (
	echo ERROR: No plugin configuration file to merge with main configuration!
	goto :eof
)

for /F "tokens=*" %%i in (./plugin.cfg) do (
	@echo %%i>>./bfd.cfg
)