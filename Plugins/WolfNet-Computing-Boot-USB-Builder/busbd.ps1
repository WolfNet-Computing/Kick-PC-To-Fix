Set-Location -Path $PSScriptRoot

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

. .\functions.busbd.ps1

If (-not (Test-Path -Path BUSBD.VERSION -PathType Leaf)) {
	Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
}
Else {
	Set-Variable -Name busbd_version -Value (Get-Content -Path BUSBD.VERSION)
}

Write-Host "`n"
Write-Host "Bootable USB Builder."
Write-Host "Version: $busbd_version"
Write-Host "Copyright (c) 2023 WolfNet Computing. All rights reserved."
Write-Host "`n"

If (($($args[0]) -eq $null)) {
    Write-Host "Usage:"
	Write-Host "busbd [-d] [-l label] name"
	Write-Host "busbd -bab"
	Write-Host "`n"
	Write-Host "name : name of the USB to build"
	Write-Host "-d      : print debug messages"
	Write-Host "-bab  : build all bootdrives For all USB's"
	Write-Host "            (using USB's bootdisk.cfg)"
	Write-Host "`n"
	Write-Host "Returns environment variable 'rv', 0 If succesfull, 1 If error"
	Write-Host "`n"
	Write-Host "This program uses the following files (located in the 'bin' directory):"
    End2
}

Write-Host "BUSBD: Checking For required files:"
ForEach ($item in "bin\syslinux.exe","bin\Wbusy.exe","bin\Wprompt.exe") {
    If (-not (Test-Path -Path $item -PathType Leaf)) {
	    Write-Error ("BUSBD: File $item not found.")
	    Abort
    }
}

For ($i = 0; $i -lt $args.Length; $i++) {
	If ($($args[$i]) -eq "-d") {
		Set-Variable -Name busbd_deb -Value 1
	}
	ElseIf ($($args[$i]) -eq "-l") {
		Set-Variable -Name busbd_label -Value $($args[($script:i + 1)])
		Set-Variable -Name i -Value ($i++)
	}
	ElseIf ($($args[0]) -eq "-bab") {
		Write-Host "BUSBD: Build all bootdrives!"
		Set-Variable -Name busbd_cnt -Value 0
		ForEach ($item in (Get-ChildItem -Path ".\usbs\" -Directory)) {
			BUSBD-Build $item
		}
		Write-Host ("BUSBD: $busbd_cnt boot disk(s) were built...")
		End1
	}
	ElseIf (Test-Path -Path "usbs\$($args[$i])") {
		Set-Variable -Name "busbd_name" -Value $($args[$i])
	}
}

If (-not (Test-Path -Path usbs\$busbd_name\)) {
    Write-Error "BUSBD: File 'usbs\$busbd_name' not found..."
    Abort
}

If (-not (Test-Path -Path busbd.cfg)) {
    If (-not (Test-Path -Path busbd.sam)) {
	    Write-Error "BUSBD: Could not find 'busbd.cfg' or 'busbd.sam'..."
        Write-Error "BUSBD: Assuming the installation is broken..."
	    Abort
    }
	Write-Information "BUSBD: Renaming 'busbd.sam' into 'busbd.cfg'..."
	Rename-Item -Path "busbd.sam" -newName "busbd.cfg"
}

Write-Host "BUSBD: Processing (Main) config file 'busbd.cfg...'"
Parse-Configuration "busbd.cfg"
If (-not ($busbd_err -eq $null)) { Abort }

If (Test-Path -Path usbs\$busbd_name\busbd.cfg -PathType Leaf) {
    Write-Host "BUSBD: Processing (USB) config file 'usbs\$busbd_name\busbd.cfg'..."
    Parse-Configuration "usbs\$busbd_name\busbd.cfg"
    If (-not ($busbd_err -eq $null)) { Abort }
}

If (Test-Path -Path usbs\$busbd_name\bootdisk.cfg -PathType Leaf) {
    Write-Host "BUSBD: Processing (Boot Disk) config file 'usbs\$busbd_name\bootdisk.cfg'..."
    Parse-Configuration "usbs\$busbd_name\bootdisk.cfg"
    If (-not ($busbd_err -eq $null)) { Abort }
}

If ((-not ($busbd_call -eq $null)) -and (Test-Path -Path "usbs\$busbd_name\$busbd_call" -PathType Leaf)) {
    Write-Host "BUSBD: Calling custom batchfile 'usbs\$busbd_name\$busbd_call'..."
	If ($busbd_call.EndsWith(".ps1")) {
		. "usbs\$busbd_name\$busbd_call"
	}
	Else {
		Invoke-Command "usbs\$busbd_name\$busbd_call"
	}
    If ($rv -eq 1) { Abort }
}

If ($_drive_name -eq $null) {
	$SaveChooser = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
    $SaveChooser.RootFolder = [System.Environment+SpecialFolder]'MyComputer'
    if ($SaveChooser.ShowDialog() -ne "OK") {
        Write-Error "BUSBD: You cancelled the dialog!"
        Write-Error "BUSBD: How would we know what drive to use!?"
        Abort
    }
    Set-Variable -Name _drive_name -Value ($SaveChooser.SelectedPath)
}
If (-not ([System.IO.Path]::IsPathRooted($_drive_name))) {
	Write-Error "BUSBD: You MUST choose the ROOT of a drive. NOT a subdirectory."
	Abort
}
If ($_drive_name -eq "C:\") {
    Write-Error "BUSBD: You chose the system drive. BIG MISTAKE!"
	Abort
}
bin\Wprompt.exe "Are you sure you want to continue?" "This program will now wipe the selected disk, install SYSLINUX and copy your selected files.^Do you want to continue?" YesNo 1 Exclamation
If ($LASTEXITCODE -eq 2) { End1 }
bin\Wbusy.exe "Building Drive" "Building drive '$_drive_name' from your files at '.\usbs\$busbd_name\files'..." /marquee /noclose
Set-Variable -Name _wbusy_active -Value 1
Write-Host "`n" | Format $($_drive_name.TrimEnd('\')) /FS:NTFS /V:$busbd_label /Q
bin\syslinux.exe -m -a $busbd_syslinux -i $($_drive_name.TrimEnd('\'))
xcopy .\usbs\$busbd_name\files\ $_drive_name /H /S /E /I /F
If ($busbd_path -ne $null) {
	xcopy $busbd_path $_drive_name /H /S /E /I /F /Y
}
bin\Wbusy.exe "Building Drive" "Drive created successfully!" /stop /sound
Clear-Variable -Name _wbusy_active
End1
