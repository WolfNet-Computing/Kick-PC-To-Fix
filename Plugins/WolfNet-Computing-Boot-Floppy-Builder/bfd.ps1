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

If ($args[0] -eq $null) { Show-Help }

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

For ($i = 0; $i -lt $args.Length; $i++) {
	If ($($args[$i]) -eq "-d") {
		$bfd_deb = 1
	}
	ElseIf ($($args[$i]) -eq "-n") {
		$bfd_nop = 1
	}
	ElseIf ($($args[$i]) -eq "-i") {
		$i = ($i + 1)
        $bfd_img = $($args[($i + 1)])
	}
	ElseIf ($($args[$i]) -eq "-o") {
		$i = ($i + 1)
        $bfd_os = $($args[($i + 1)])
	}
    ElseIf ($($args[$i]) -eq "-t") {
		$($args[($i + 1)])
        $bfd_type = $($args[($i + 1)])
    }
    ElseIf ($($args[$i]) -eq "-target") {
		$i = ($i + 1)
        $bfd_target = $($args[($i + 1)])
    }
	ElseIf (Test-Name $($args[$i])) {
		$bfd_name = $($args[($i)])
    }
    Else {
		Write-Host "BFD: Invalid parameter '$($args[($i)])'."
        Abort
    }
}

If ($bfd_name -eq $null)  { Show-Help }
If ($bfd_type -eq $null)  { $bfd_type = 144 }
If (($bfd_img -eq $null) -and ($bfd_target -eq $null))  { $bfd_target = "a:" }
Write-Host "BFD: Building '$bfd_name'"
If ($bfd_img -eq $null) {
    Write-Host "BFD: Target drive '$bfd_target'"
}
Else {
    Write-Host "BFD: Target image file '$bfd_img'"
    $bfd_target = "$env:temp\_bfd_"
    New-Item -Path "$env:temp\_bfd_" -ItemType Directory
}

Write-Host "BFD: Calling 'Parse-Configuration bfd.cfg'"
Parse-Configuration "bfd.cfg"
If (Test-Path -Path "plugin") {
    ForEach ($file in (Get-ChildItem -Path "plugin" -File -Include "*.cfg" )) {
	    Write-Host "BFD: Calling 'Parse-Configuration $file'"
	    Parse-Configuration "$file"
	    If ($bfd_err -eq 1) { Abort }
    }
}
If (Test-Path -Path "cds") {
    ForEach ($directory in (Get-ChildItem -Path "cds" -Directory -Name)) {
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
