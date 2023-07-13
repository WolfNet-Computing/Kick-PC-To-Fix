@echo off
echo CUSTOM: Checking required files...
set rv=0
for %%i in (isolinux\bootmsg.txt isolinux\isolinux.bin isolinux\isolinux.cfg isolinux\memdisk) do if not exist cds\%bcd_name%\files\%%i (
	echo CUSTOM: File "cds\%bcd_name%\files\%%i" not found.
	set rv=1)
:_bcd1_
:_end
