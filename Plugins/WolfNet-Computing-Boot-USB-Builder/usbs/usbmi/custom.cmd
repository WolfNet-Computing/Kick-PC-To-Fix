@echo off
echo CUSTOM: Checking required files...
set rv=0
for %%i in (usbs\%busbd_name%\files\syslinux\bootmsg.txt usbs\%busbd_name%\files\syslinux\syslinux.cfg usbs\%busbd_name%\files\syslinux\memdisk) do (
	if not exist %%i (
		echo CUSTOM: File "%%i" not found.
		set rv=1
	)
)
:_busbd1_
:_end
