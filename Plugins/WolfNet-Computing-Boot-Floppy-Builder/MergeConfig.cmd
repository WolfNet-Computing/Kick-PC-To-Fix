@echo off
if not exist plugin.cfg (
	echo ERROR: No plugin configuration file to merge with main configuration!
	goto :eof
)

for /F "tokens=*" %%i in (plugin.cfg) do (
	@echo %%i>>bfd.cfg
)