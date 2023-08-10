@echo off
Write-Host "CUSTOM: Checking required files..."
for ($file in "isolinux\bootmsg.txt","isolinux\isolinux.bin","isolinux\isolinux.cfg","isolinux\memdisk") {
	if (-not (Test-Path -Path "cds\$($bcd_name)\files\$($file)")) {
		Write-Host CUSTOM: File "cds\$($bcd_name)\files\$($file)" not found.
		$rv=1
	}
}
