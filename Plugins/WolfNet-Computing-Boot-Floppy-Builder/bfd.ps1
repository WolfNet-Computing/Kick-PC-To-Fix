Set-Location -Path $PSScriptRoot

. .\functions.bfd.ps1

If (-not (Test-Path -Path BFD.VERSION -PathType Leaf)) {
	Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
}
Else {
	Set-Variable -Name bfd_version -Value (Get-Content -Path BFD.VERSION)
}

Write-Host "`n"
Write-Host "Bootable Floppy Builder."
Write-Host "Version: $bfd_version"
Write-Host "Copyright (c) 2022-2023 WolfNet Computing. All rights reserved."
Write-Host "`n"

If ($args[0] -eq $null) { Show-Help }

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
    Write-Host "OK" > bfd.ok
}

For ($i = 0; $i -lt $args.Length; $i++) {
	If ($($args[$i]) -eq "-d") {
		Set-Variable -Name bfd_deb -Value 1 -Scope Script
	}
	ElseIf ($($args[$i]) -eq "-n") {
		Set-Variable -Name bfd_nop -Value 1 -Scope Script
	}
	ElseIf ($($args[$i]) -eq "-i") {
        Set-Variable -Name bfd_img -Value $($args[($local:i + 1)]) -Scope Script
		Set-Variable -Name i -Value ($local:i + 1)
	}
	ElseIf ($($args[$i]) -eq "-o") {
        Set-Variable -Name bfd_os -Value $($args[($local:i + 1)]) -Scope Script
		Set-Variable -Name i -Value ($local:i + 1)
	}
    ElseIf ($($args[$i]) -eq "-t") {
        Set-Variable -Name bfd_type -Value $($args[($local:i + 1)]) -Scope Script
		Set-Variable -Name i -Value ($local:i + 1)
    }
    ElseIf ($($args[$i]) -eq "-target") {
        Set-Variable -Name bfd_target -Value $($args[($local:i + 1)]) -Scope Script
		Set-Variable -Name i -Value ($local:i + 1)
    }
	ElseIf ((Test-Name $($args[$local:i])) -eq $true) {
		Set-Variable -Name bfd_name -Value $($args[($local:i)]) -Scope Script
    }
    Else {
        Write-Host "BFD: Unknown parameter '$($args[$i])' at position '$i'"
        Abort
    }
}

If ($bfd_name -eq $null)  { Show-Help }
If ($bfd_type -eq $null)  { Set-Variable -Name bfd_type -Value 144 }
If (($bfd_img -eq $null) -and ($bfd_target -eq $null))  { Set-Variable -Name bfd_target -Value "a:" }
Write-Host "BFD: Building '$bfd_name'"
If ($bfd_img -eq $null) {
    Write-Host "BFD: Target drive '$bfd_target'"
}
Else {
    Write-Host "BFD: Target image file '$bfd_img'"
    Set-Variable -Name bfd_target -Value "$env:temp\_bfd_"
    New-Item -Path $(Split-Path -Path $bfd_target -Parent) -name $(Split-Path -Path $bfd_target -Leaf) -ItemType "directory"
}

Write-Host "BFD: Calling 'Parse-Configuration bfd.cfg'"
Parse-Configuration "bfd.cfg"
If ($bfd_err -ne $null) { Abort }
If (Test-Path -Path "plugin") {
    ForEach ($file in (Get-ChildItem -Path "plugin" -File -Include "*.cfg" )) {
	    Write-Host "BFD: Calling 'Parse-Configuration $file'"
	    Parse-Configuration "$file"
	    If ($bfd_err -ne $null) { Abort }
    }
}
<# If (Test-Path -Path "cds") {
    ForEach ($directory in (Get-ChildItem -Path "cds" -Directory -Name)) {
	    Write-Host "BFD: Calling 'Parse-Configuration cds\$directory\bfd.cfg'"
	    Parse-Configuration "cds\$directory\bfd.cfg"
	    If ($bfd_err -ne $null) { Abort }
    }
} #>

If ($bfd_img -eq $null) { Done }

Write-Host "BFD: Creating image '$bfd_img'"
If ($bfd_la -ne $null) {
    Add-VarToOptions "-l"
    Add-VarToOptions "$bfd_la"
}
If ($bfd_bi -ne $null) {
    Add-VarToOptions "-b"
    Add-VarToOptions "$bfd_bi"
}
If ($bfd_or -ne $null) {
    Add-VarToOptions "-o"
    Add-VarToOptions "$bfd_or"
}
If ($bfd_type -ne $null) {
    Add-VarToOptions "-t"
    Add-VarToOptions "$bfd_type"
}
Write-Host "BFD: Running bfi -f=$bfd_img $bfd_options $bfd_target"
bin\bfi.exe -f=$bfd_img $bfd_options $bfd_target
If ($LASTEXITCODE -eq 1) { Abort }
If (-not (Test-Path -Path $bfd_target)) { Done }
Write-Host "BFD: Remove directory '$bfd_target'"
Remove-Item -Path $bfd_target -Recurse
If (-not (Test-Path -Path $bfd_target)) { Done }
End1
