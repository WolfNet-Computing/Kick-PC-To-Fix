Set-Location -Path $PSScriptRoot

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

. .\functions.bcd.ps1

If (-not (Test-Path -Path BCD.VERSION -PathType Leaf)) {
	Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
}
Else {
	Set-Variable -Name bcd_version -Value (Get-Content -Path BCD.VERSION)
}

Write-Host "`n"
Write-Host "Bootable CD/DVD Builder."
Write-Host "Version: $bcd_version"
Write-Host "Copyright (c) 2022-2023 WolfNet Computing. All rights reserved."
Write-Host "`n"

If ($($args[0]) -eq $null) {
    Write-Host "  Usage:"
	Write-Host "  bcd [-d] [-b] [-s nn] name"
	Write-Host "  bcd -bab"
	Write-Host "  bcd -all"
	Write-Host "`n"
	Write-Host "  name    : name of the CD to build"
	Write-Host "  -a      : build all ISO9660 image files"
	Write-Host "  -d      : print debug messages"
	Write-Host "  -b      : burning disabled (only create ISO image)"
	Write-Host "  -s nn   : set burning speed"
	Write-Host "  -bab    : build all bootimages for all CD's"
	Write-Host "              (using CD's bootdisk.cfg)"
	Write-Host "`n"
	Write-Host "Returns environment variable 'rv', 0 If succesfull, 1 If error"
	Write-Host "`n"
	Write-Host "This program uses the following files (located in the 'bin' directory):"
	Write-Host "- Xorriso by ?? (GNU-GPL license)."
	Write-Host "- Nero Aspi Library (wnaspi32.dll) by Ahead Software AG (abandonware)."
	End1
}
If ($($args[0]) -eq "-all") {
        ForEach ($item in (Get-ChildItem -Path ".\cds\" -Directory)) {
        & $MyInvocation.MyCommand.Name -b $item
    }
    End1
}
Write-Host "BCD: Checking for required files:"
ForEach ($item in "bin\bchoice.exe","bin\cdrecord.exe","bin\cygwin1.dll","bin\mkisofs.exe","bin\WNASPI32.DLL") {
    If (-not (Test-Path -Path $item -PathType Leaf)) {
	    Write-Host "BCD: File '$item' not found."
	    Abort
    }
}

For ($i = 0; $i -lt $args.Length; $i++) {
	If ($args[$i] -eq "-d") {
		Set-Variable -Name bcd_deb -Value 1 -Scope Script
	}
	ElseIf ($args[$i] -eq "-b") {
		Write-Host "BCD: Build image only!"
		Set-Variable -Name bcd_noburn -Value 1 -Scope Script
	}
	ElseIf ($args[$i] -eq "-s") {
		Set-Variable -Name bcd_spd -Value $($args[($i++)]) -Scope Script
	    Write-Host "BCD: Speed set to '$bcd_spd'"
        If ($bcd_spd -gt 50) {
		    Write-Host "BCD: Ignoring invalid speed argument '$bcd_spd', must be between 1-50."
		    Clear-Variable -Name bcd_spd
        }
	    If ($bcd_spd -lt 1) {
		    Write-Host "BCD: Ignoring invalid speed argument '$bcd_spd', must be between 1-50."
		    Clear-Variable -Name bcd_spd
        }
		Set-Variable -Name i -Value ($i++)
	}
	ElseIf ($args[0] -eq "-bab") {
		Write-Host "BCD: Build all bootdrives!"
		Set-Variable -Name bcd_cnt -Value 0
		ForEach ($item in (Get-ChildItem -Path ".\cds\" -Directory)) {
			ParseAndCount-BootConfigFile $item
		}
		Write-Host ("BCD: $bcd_cnt boot disk(s) were built...")
		End1
	}
	ElseIf (Test-Path -Path ".\cds\$($args[$i])") {
		Write-Host "BCD: Setting `$bcd_name to '$($args[$i])'!"
		Set-Variable -Name bcd_name -Value $($args[$i]) -Scope Script
    }
}

If (-not (Test-Path -Path cds\$bcd_name\)) {
    Write-Error "BCD: CD '$bcd_name%' does not exist..."
	Write-Error "BCD: You must specify one of the following names:"
	ForEach ($folder in (Get-ChildItem -Path "cds" -Directory)) { Write-Error "$folder" }
	End3
}

If (-not (Test-Path -Path bcd.cfg)) {
    If (-not (Test-Path -Path bcd.sam)) {
	    Write-Error "BCD: Could not find 'bcd.cfg' or 'bcd.sam'..."
        Write-Error "BCD: Assuming the installation is broken..."
	    Abort
    }
	Write-Information "BCD: Renaming 'bcd.sam' into 'bcd.cfg'..."
	Rename-Item -Path "bcd.sam" -newName "bcd.cfg"
}

Write-Host "BCD: Processing (main) config file 'bcd.cfg'"
Parse-Configuration "bcd.cfg"
If ($bcd_err -ne $null) { Abort }

If (Test-Path -Path "cds\$bcd_name\bcd.cfg" -PathType Leaf) {
    Write-Host "BCD: Processing (CD) config file 'cds\$bcd_name\bcd.cfg'..."
    Parse-Configuration "cds\$bcd_name\bcd.cfg"
    If ($bcd_err -ne $null) { Abort }
}

If ($bcd_isofs -eq $null) {
	Write-Host "BCD: No mkisofs options, adding '-J -N'"
	Add-VarToIsofs "-J"
	Add-VarToIsofs "-N"
}

If (Test-Path -Path cds\$bcd_name\bootdisk.cfg -PathType Leaf) {
    Write-Host "BCD: Processing (Boot Disk) config file 'cds\$bcd_name\bootdisk.cfg'..."
    Parse-Configuration "cds\$bcd_name\bootdisk.cfg"
    If ($bcd_err -ne $null) { Abort }
}

If ((-not ($bcd_call -eq $null)) -and (Test-Path -Path "cds\$bcd_name\$bcd_call" -PathType Leaf)) {
    Write-Host "BCD: Calling custom script 'cds\$bcd_name\$bcd_call'..."
    . "cds\$bcd_name\$bcd_call"
    If ($rv -eq 1) { Abort }
}

If (-not ($bcd_boot -eq $null)) {
    $bcd_boot = $bcd_boot.Replace("\","/")
    Write-Host "BCD: Bootfile is '$bcd_boot'"
    Set-Variable -Name bcd_tmp -Value ".\cds\$bcd_name\files\$bcd_boot" -Scope Script
    If (-not (Test-Path -Path ".\cds\$bcd_name\files\$bcd_boot" -PathType Leaf)) {
    	Write-Host "BCD: Bootfile '.\cds\$bcd_name\files\$bcd_boot' not found"
    	Abort
    }
    Add-VarToIsofs "-b"
    Add-VarToIsofs "$bcd_boot"
    If ($bcd_tmp.EndsWith(".bin")) {
    	Write-Host "BCD: Bootfile type is '.bin' adding '-no-emul-boot -boot-load-size 4'"
        Add-VarToIsofs "-no-emul-boot"
        Add-VarToIsofs "-boot-load-size"
        Add-VarToIsofs "4"
        If (($bcd_tmp.EndsWith(".bin"))) { IsNotNT }
    }
    If ($bcd_tmp.EndsWith("isolinux.bin")) {
        Write-Host "BCD: Bootfile is ISOLINUX adding '-boot-info-table -allow-leading-dots -allow-multidot -l'"
        Add-VarToIsofs "-boot-info-table"
        Add-VarToIsofs "-allow-leading-dots"
        Add-VarToIsofs "-allow-leading-dots"
        Add-VarToIsofs "-l"
    }
    Set-Variable -Name _string -Value $(Select-String -Pattern "setupldr.bin" -Path $bcd_tmp -SimpleMatch)
    If ($_string -eq $null) { IsNotNT }
    Else {
        Write-Host "BCD: Bootfile is NT adding '-no-iso-translate -relaxed-filenames'"
        Add-VarToIsofs "-no-iso-translate"
        Add-VarToIsofs "-relaxed-filenames"
    }
}
Else {
    Write-Error "BCD: `$bcd_boot is not set!"
    Abort
}

Write-Host "BCD: Creating ISO image file (running mkisofs.exe)"
$SaveChooser = New-Object -TypeName System.Windows.Forms.SaveFileDialog
$SaveChooser.filter = "ISO Image files (*.iso)| *.iso"
if ($SaveChooser.ShowDialog() -ne "OK") {
    Write-Error "BCD: You cancelled the dialog!"
    Write-Error "BCD: How would we know where to save the image!?"
    Abort
}
Set-Variable -Name _save_location -Value ($SaveChooser.filename)
Write-Host "BCD: Arguments; $bcd_isofs -v -c boot.cat -o $_save_location cds\$bcd_name\files $bcd_path"
echo $PSScriptRoot
cd
bin\mkisofs.exe $bcd_isofs -v -c boot.cat -o $_save_location cds\$bcd_name\files $bcd_path
If ($LASTEXITCODE -eq 1) {
	Write-Error "BCD: mkisofs.exe returned an error..."
	Abort
}
Write-Host "BCD: ISO file '$_save_location' created."
If (-not ($bcd_noburn -eq $null)) { End1 }
If (-not (Test-Path -Path "bin\wnaspi32.dll" )) {
    Write-Error "BCD: File 'bin\wnaspi32.dll' is missing, please re-install the package"
    Write-Error "BCD: WolfNet-Computing-Boot-Tools to regain it."
    Write-Error "BCD: This file is required to access your CD-writer."
    Set-Variable -Name bcd_noburn -Value 1
    Abort
}
Detect-CD
Detect-CDOptions