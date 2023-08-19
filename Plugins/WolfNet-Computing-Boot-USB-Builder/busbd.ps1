[CmdletBinding(PositionalBinding=$false)]
param (
	[Parameter(Mandatory=$false, ParameterSetName="Build")]
	[Alias("d")]
	[switch]$busbd_deb,
	
	[Parameter(Mandatory=$false, ParameterSetName="Build")]
	[Alias("img")]
	[switch]$busbd_virtual,
	
	[Parameter(Mandatory, ParameterSetName="BuildAllBoot")]
	[Alias("bab")]
	[switch]$busbd_bab,
	
	[Parameter(Mandatory, ParameterSetName="BuildAll")]
	[Alias("all")]
	[switch]$busbd_all,
	
	[Parameter(Mandatory, ParameterSetName="Help")]
	[Alias("help")]
	[switch]$busbd_help,
	
	[Parameter(Mandatory, ParameterSetName="Build")]
	[Alias("p")]
	[ValidateNotNullOrEmpty()]
	[string]$busbd_name
)

# Consider adding some comment based help for the script here.


#----------------[ Declarations ]----------------

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Set-Location -Path $PSScriptRoot

#----------------[ Functions ]------------------

function Show-Help {
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

function End2 {
	If (Test-Path -path "$env:TEMP\temp.ps1" -PathType Leaf) { Remove-Item -Path "$env:TEMP\temp.ps1" }
	If (Test-Path -path "$env:TEMP\_diskpart_.txt" -PathType Leaf) { Remove-Item -Path "$env:TEMP\_diskpart_.txt" }
	Write-Host "BUSBD: Returning with return value $rv"
    Exit $rv
}

function End1 {
	Set-Variable -Name rv -Value 0 -Scope Script
    End2
}

function Abort {
    If ($_wbusy_active -eq $null) {
		bin\Wbusy.exe "Building Drive" "Drive creation failed!" /stop /sound
	}
	Write-Error "BUSBD: Aborted..."
    End2
}

function Build-FloppyImage {
	If ($busbd_err -eq 1) { Return }
	Write-Host "BUSBD: Creating bootdrive '$($args[2])'"
	.\bfd -i "$($args[0])\files\$($args[2])" -p "$($args[1])"
	If ($rv -eq 1) {
		Set-Variable -Name busbd_err -Value 1 -Scope Script
		Return
	}
}

function Parse-Configuration {
    ForEach ($line in (Get-Content -Path $args[0])) {
        If (-not ($line.StartsWith("#"))) {
			If ($line -ne "") {
				$line = $line.split("#")
				$_str = $line[0] -replace "\s+",' '
				$a, $b, $c = $_str.split(" ")
				If ([System.IO.Path]::GetFileName($args[0]) -eq "busbd.cfg") {
					Parse-ConfigFile $a $b $c
				}
				Else {
					Parse-BootConfigFile $a $b $c
				}
			}
		}
    }
}

function Parse-ConfigFile {
	If ($busbd_deb -ne $null) { Write-Host ("debug: cmd=[$($args[0])] arg=[$($args[1])] err=[$busbd_err]") }
	If ($busbd_err -eq 1) { Return }
	If ($($args[0]) -eq "label") {
		Set-Variable -Name busbd_label -Value $($args[1]) -Scope Script
		Write-Host ("BUSBD: Drive name arguments '" + $($args[1]) + "' appended.")
		Return
	}
	If ($($args[0]) -eq "syslinuxargs") {
		Set-Variable -Name busbd_syslinux -Value $($args[1]) -Scope Script
		Write-Host  ("BUSBD: Syslinuxargs set to '" + $($args[1]) + "'.")
		Return
	}
	If ($($args[0]) -eq "call") {
		Set-Variable -Name busbd_call -Value $($args[1]) -Scope Script
		Write-Host  ("BUSBD: Custom Script set to '" + $($args[1]) + "'.")
		Return
	}
	If ($($args[0]) -eq "addpath") {
		Set-Variable -Name busbd_path -Value $($args[1]) -Scope Script
		Write-Host  ("BUSBD: Custom path(s) '" + $($args[1]) + "' added to list of files/folders to add.")
		Return
	}
	Write-Host ("BUSBD: unknown keyword '$($args[0])'...")
	Set-Variable -Name busbd_err -Value 1
}

function Parse-BootConfigFile {
	If ($busbd_err -eq 1) { Return }
    If (Test-Path -path ".\usbs\$busbd_name\files\$($args[1])" -PathType Leaf) {
		Write-Information "BUSBD: Bootdrive '$($args[1])' already exists, skip creation"
		Return
	}
	Write-Host "BUSBD: Bootdrive '$($args[1])' does not exist, let's create it now!"
	.\bfd -i ".\usbs\$busbd_name\files\$($args[1])" -p "$($args[0])"
	If ($rv -eq 1) { Set-Variable -Name busbd_err -Value 1 }
}
<#
:_ball
	If ($busbd_err -eq 1) { Return }
	Write-Host "BUSBD: Processing USB setup '$args[0]'."
	If not exist $args[0]\bootdisk.cfg Return
	Write-Host "BUSBD: Processing bootdisk config file '$args[0]\bootdisk.cfg'."
	set rv=
	For /f "eol=# tokens=1,2" %%j in (%1\bootdisk.cfg) do call :_bflopo $args[0] %%j %%k
	If not "%busbd_err%" -eq "" End1
	Return
#>

#----------------[ Main Execution ]---------------

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

If ($busbd_help) { Show-Help }

Write-Host "BUSBD: Checking For required files:"
ForEach ($item in "bin\syslinux.exe","bin\Wbusy.exe") {
    If (-not (Test-Path -Path $item -PathType Leaf)) {
	    Write-Error ("BUSBD: File $item not found.")
	    Abort
    }
}

If (-not (Test-Path -Path .\usbs\$busbd_name\)) {
    Write-Error "BUSBD: Folder '.\usbs\$busbd_name' not found..."
    Abort
}

If (-not (Test-Path -Path .\busbd.cfg)) {
    If (-not (Test-Path -Path .\busbd.sam)) {
	    Write-Error "BUSBD: Could not find 'busbd.cfg' or 'busbd.sam'..."
        Write-Error "BUSBD: Assuming the installation is broken..."
	    Abort
    }
	Write-Information "BUSBD: Renaming 'busbd.sam' into 'busbd.cfg'..."
	Rename-Item -Path ".\busbd.sam" -newName ".\busbd.cfg"
}

Write-Host "BUSBD: Processing (Main) config file '.\busbd.cfg...'"
Parse-Configuration ".\busbd.cfg"
If (-not ($busbd_err -eq $null)) { Abort }

If (Test-Path -Path .\usbs\$busbd_name\busbd.cfg -PathType Leaf) {
    Write-Host "BUSBD: Processing (USB) config file '.\usbs\$busbd_name\busbd.cfg'..."
    Parse-Configuration ".\usbs\$busbd_name\busbd.cfg"
    If (-not ($busbd_err -eq $null)) { Abort }
}

If (Test-Path -Path usbs\$busbd_name\bootdisk.cfg -PathType Leaf) {
    Write-Host "BUSBD: Processing (Boot Disk) config file '.\usbs\$busbd_name\bootdisk.cfg'..."
    Parse-Configuration ".\usbs\$busbd_name\bootdisk.cfg"
    If (-not ($busbd_err -eq $null)) { Abort }
}

If ($busbd_label) {
	$busbd_label = "WCBT-USB"
}

If (($busbd_call) -and (Test-Path -Path ".\usbs\$busbd_name\$busbd_call" -PathType Leaf)) {
    Write-Host "BUSBD: Calling custom script '.\usbs\$busbd_name\$busbd_call'..."
	& ".\usbs\$busbd_name\$busbd_call"
}

If ($busbd_virtual) {
	$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
		InitialDirectory = [Environment]::GetFolderPath('MyComputer')
		Filter = 'Virtual Hard Drive v2 (*.vhdx)|*.vhdx'
	}
	If ($FileBrowser.ShowDialog() -ne "OK") {
		Write-Error "BUSBD: You cancelled the dialog!"
		Write-Error "BUSBD: How would we know where to save the image!?"
		Abort
	}
	$busbd_image = $($FileBrowser.FileName)
	
	$form = New-Object System.Windows.Forms.Form
	$form.Text = 'Image Size'
	$form.Size = New-Object System.Drawing.Size(300,200)
	$form.StartPosition = 'CenterScreen'
	
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = New-Object System.Drawing.Point(75,120)
	$okButton.Size = New-Object System.Drawing.Size(75,23)
	$okButton.Text = 'OK'
	$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $okButton
	$form.Controls.Add($okButton)
	
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Location = New-Object System.Drawing.Point(150,120)
	$cancelButton.Size = New-Object System.Drawing.Size(75,23)
	$cancelButton.Text = 'Cancel'
	$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $cancelButton
	$form.Controls.Add($cancelButton)
	
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,20)
	$label.Size = New-Object System.Drawing.Size(280,20)
	$label.Text = 'How big should the image be? (Include a suffix, MB or GB (Must be at least 128MB in capacity))'
	$form.Controls.Add($label)
	
	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10,40)
	$textBox.Size = New-Object System.Drawing.Size(260,20)
	$form.Controls.Add($textBox)
	
	$form.Topmost = $true
	$form.Add_Shown({$textBox.Select()})
	
	$result = $form.ShowDialog()
	If ($result -eq [System.Windows.Forms.DialogResult]::OK) {
		If ($textBox.Text.EndsWith("MB")) {
			$_temp_var = [int32]$textBox.Text.TrimEnd("MB")
			$busbd_image_size = $_temp_var
		}
		ElseIf ($textBox.Text.EndsWith("GB")) {
			$_temp_var = [int32]$textBox.Text.TrimEnd("GB")
			$busbd_image_size = ($_temp_var * 1024)
		}
		Else {
			Write-Error "BUSBD: Bad suffix for the image size"
			Write-Error "BUSBD: Must be 'MB' or 'GB'"
			Abort
		}
	}
	Else {
        Write-Error "BUSBD: You cancelled the dialog!"
		Write-Error "BUSBD: How would we know what size to make the drive!?"
        Abort
	}
	bin\Wbusy.exe "Building Drive" "Building drive '$($busbd_image)' from your files at '.\usbs\$($busbd_name)\files'..." /marquee /noclose
	$_wbusy_active = 1
	$_our_letter = "T"
	$busbd_format = "ntfs"
	If ($busbd_image_size -lt 128) {
		Write-Error "BUSBD: Bad image size"
		Write-Error "BUSBD: Must be greater than 128MB"
		Abort
	}
	New-Variable -Name _str -Value @(
		"CREATE vdisk file=`"$($busbd_image)`" maximum=$($busbd_image_size) noerr",
		"SELECT vdisk file=`"$($busbd_image)`" noerr",
		"ATTACH vdisk noerr",
		"CREATE partition primary noerr",
		"FORMAT fs=$($busbd_format) label=`"$($busbd_name)`" quick noerr",
		"ASSIGN letter=$($_our_letter) noerr"
	)
	Out-File -FilePath "$($env:temp)\_diskpart_.txt" -InputObject $_str -Force -Encoding ascii
	diskpart /S "$($env:temp)\_diskpart_.txt"
	$_drive_name = $_our_letter + ':\'
	Start-Sleep 5
}
Else {
	$SaveChooser = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
    $SaveChooser.RootFolder = [System.Environment+SpecialFolder]'MyComputer'
    If ($SaveChooser.ShowDialog() -ne "OK") {
        Write-Error "BUSBD: You cancelled the dialog!"
        Write-Error "BUSBD: How would we know what drive to use!?"
        Abort
    }
    Set-Variable -Name _drive_name -Value $($SaveChooser.SelectedPath)
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
}
bin\syslinux.exe -f -m -a $busbd_syslinux -i $($_drive_name.TrimEnd('\'))
xcopy .\usbs\$busbd_name\files\ $_drive_name /H /S /E /I /F
If ($busbd_path -ne $null) {
	xcopy $busbd_path $_drive_name /H /S /E /I /F /Y
}
If ($busbd_virtual) {
	Set-Variable -Name _str -Value @(
		"SELECT vdisk file=`"$($busbd_image)`"",
		"DETACH vdisk",
		"EXIT"
	)
	Out-File -FilePath "$env:temp\_diskpart_.tmp" -InputObject $_str -Force -Encoding ascii
	diskpart /S "$env:temp\_diskpart_.tmp"
}
bin\Wbusy.exe "Building Drive" "Drive created successfully!" /stop /sound
Clear-Variable -Name _wbusy_active