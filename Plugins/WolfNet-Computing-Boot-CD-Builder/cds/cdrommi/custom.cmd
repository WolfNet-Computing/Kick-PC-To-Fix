@echo off
echo CUSTOM: Checking required files...
set rv=0
for %%i in (cds\%bcd_name%\files\isolinux\bootmsg.txt cds\%bcd_name%\files\isolinux\isolinux.bin cds\%bcd_name%\files\isolinux\isolinux.cfg cds\%bcd_name%\files\isolinux\memdisk) do if not exist %%i (
	echo CUSTOM: File "%%i" not found.
	set rv=1)
:_bcd1_
:_end
