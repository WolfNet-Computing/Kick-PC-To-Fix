[CmdletBinding(PositionalBinding=$false)]
param ( 
	[Parameter(Mandatory=$false)]
	[Alias("d")]
	[switch]$bfd_deb,
	
	[Parameter(Mandatory=$false)]
	[Alias("n")]
	[switch]$bfd_nop,
	
	[Parameter(Mandatory=$true)]
	[Alias("i")]
	[ValidateNotNullOrEmpty()]
	[string]$bfd_img = $(throw "an image location is required."),
	
	[Parameter(Mandatory=$false)]
	[Alias("o")]
	[ValidateNotNullOrEmpty()]
	[string]$bfd_os,
	
	[Parameter(Mandatory=$false)]
	[Alias("t")]
	[ValidateSet('144','288')]
	[PSDefaultValue(Help='1.44MB Floppy')]
	[int]$bfd_type = 144,
	
	[Parameter(Mandatory=$false)]
	[Alias("help")]
	[switch]$bfd_help,
	
	[Parameter(Mandatory=$true)]
	[Alias("p")]
	[ValidateNotNullOrEmpty()]
	[string]$bfd_name = $(throw "a project name is required.")
)

Set-Location -Path $PSScriptRoot

. .\functions.bfd.ps1

If (-not (Test-Path -Path BFD.VERSION -PathType Leaf)) {
	Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
}
Else {
	$bfd_version = (Get-Content -Path BFD.VERSION)
}

Write-Host "`n"
Write-Host "Bootable Floppy Builder."
Write-Host "Version: $bfd_version"
Write-Host "Copyright (c) 2022-2023 WolfNet Computing. All rights reserved."
Write-Host "`n"

If ($bfd_help) { Show-Help }

If (Test-Path -Path $($env:temp + '\_bfd_')) {
	Write-Host "BFD: Removing '$env:temp\_bfd_'"
	Remove-Item -Path $($env:temp + '\_bfd_') -Recurse
}

If (-not (Test-Path -Path "bfd.cfg" -PathType Leaf)) {
	If (Test-Path -Path "bfd.sam" -PathType Leaf) {
		Write-Host "BFD: Renaming 'bfd.sam' into 'bfd.cfg'"
		Rename-Item -Path "bfd.sam" -newName "bfd.cfg"
    }
    Else {
        Write-Host "BFD: Could not find 'bfd.cfg'"
    }
}

Write-Host "BFD: Checking for required files..."
ForEach ($file in "bin\bfi.exe","bin\cabarc.exe","bin\mkbt.exe","bin\Wbox.exe") {
    If (-not (Test-Path -Path $file -PathType Leaf)) {
	    Write-Host "BFD: File '$file' not found"
	    Abort
    }
}

If (-not (Test-Path -Path bfd.ok -PathType Leaf)) {
    bin\Wbox.exe "* IMPORTANT NOTICE *"  "This program uses some files from Microsoft Windows 98 which are protected by ^copyright. You must have a valid Windows 98 license before using these files. ^When you do not have a valid license for Windows 98 but you do have one for ^Windows 95 or msdos 6 you should create an OS plugin with those licensed files or ^If you have no microsoft licenses then use FreeDOS. ^Do you have a valid license for MS-DOS 7.01 OR Windows 98? ^(If you click 'no' then ALL ms-dos files will be removed from the installation.)" "Yes;No;Quit" /OT /DB=2 /TL=7 /FS=12 /BG=#444444
    If ($LASTEXITCODE -eq 0) { Abort }
    If ($LASTEXITCODE -eq 2) { Remove-MSDOS }
    If ($LASTEXITCODE -eq 3) { Abort }
    Write-Host "OK" > bfd.ok | Out-Null
}

Write-Host "BFD: Building '$bfd_name'"
If ($bfd_img -eq $null) {
	$bfd_target = "a:"
    Write-Host "BFD: Target drive '$bfd_target'"
}
Else {
    Write-Host "BFD: Target image file '$bfd_img'"
    $bfd_target = "$env:temp\_bfd_"
    New-Item -Path "$env:temp\_bfd_" -ItemType Directory
}

Write-Host "BFD: Calling 'Parse-Configuration bfd.cfg'"
Parse-Configuration ".\bfd.cfg"
If (Test-Path -Path ".\plugin" -PathType Container) {
    ForEach ($file in (Get-ChildItem -Path ".\plugin" -File -Include "*.cfg" )) {
	    Write-Host "BFD: Calling 'Parse-Configuration $file'"
	    Parse-Configuration "$file"
	    If ($bfd_err -eq 1) { Abort }
    }
}
If (Test-Path -Path ".\cds" -PathType Container) {
	Write-Host $(Get-ChildItem -Path ".\cds" -Directory -Name)
    ForEach ($directory in (Get-ChildItem -Path ".\cds" -Directory -Name)) {
		Write-Host $(Get-ChildItem -Path $directory -File -Include "bfd.cfg")
		ForEach ($file in (Get-ChildItem -Path $directory -File -Include "bfd.cfg")) {
			Write-Host "BFD: Calling 'Parse-Configuration $file'"
			Parse-Configuration "$file"
			If ($bfd_err -eq 1) { Abort }
		}
    }
}

If ($bfd_img -eq $null) { Done }

Write-Host "BFD: Creating image '$bfd_img'"
If ($bfd_la -ne $null) {
    Add-VarToOptions "-l=$($bfd_la)"
}
If ($bfd_bi -ne $null) {
    Add-VarToOptions "-b=$($bfd_bi)"
}
If ($bfd_or -ne $null) {
    Add-VarToOptions "-o=$($bfd_or)"
}
If ($bfd_type -ne $null) {
    Add-VarToOptions "-t=$($bfd_type)"
}
Write-Host "BFD: Running bfi -f=$($bfd_img) $bfd_options $bfd_target"
bin\bfi.exe -v -f="$($bfd_img)" $bfd_options "$($bfd_target)\"
If ($LASTEXITCODE -eq 1) { Abort }
If (-not (Test-Path -Path $bfd_target)) { Done }
Write-Host "BFD: Remove directory '$bfd_target'"
Remove-Item -Path $bfd_target -Recurse
If (-not (Test-Path -Path $bfd_target)) { Done }
End1
