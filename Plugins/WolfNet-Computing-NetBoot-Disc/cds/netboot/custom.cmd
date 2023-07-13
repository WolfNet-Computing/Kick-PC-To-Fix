@echo off
echo CUSTOM: Checking required files...
set rv=0
for %%i in (cds\%bcd_name%\files\isolinux.msg cds\%bcd_name%\files\isolinux.bin cds\%bcd_name%\files\isolinux.cfg cds\%bcd_name%\files\memdisk cds\%bcd_name%\files\ldlinux.c32 cds\%bcd_name%\files\ldlinux.sys cds\%bcd_name%\files\ipxe.lkrn cds\%bcd_name%\files\wimboot cds\%bcd_name%\files\background.png) do if not exist %%i (
	echo CUSTOM: File "%%i" not found.
	set rv=1)
:_bcd1_
:_end
