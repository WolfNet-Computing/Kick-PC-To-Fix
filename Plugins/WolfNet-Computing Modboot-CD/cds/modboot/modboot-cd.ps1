. $PSScriptRoot\functions.modboot-cd.ps1

If (-not (Test-Path -Path MODBOOT-CD.VERSION -PathType Leaf)) {
	Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
}
Else {
	$mb_version = Get-Content -Path MODBOOT-CD.VERSION
}

Write-Host "`n"
Write-Host "Modular Boot CD Builder."
Write-Host "Version: $mb_version"
Write-Host "Copyright (c) 2022-2023 WolfNet Computing. All rights reserved."
Write-Host "`n"

If (-not (Test-Path -Path "$PSScriptRoot\modboot-cd.cfg" -PathType Leaf)) {
	If (Test-Path -Path "$PSScriptRoot\modboot-cd.sam" -PathType Leaf) {
		Write-Host "MB-CD: Renaming 'modboot-cd.sam' into 'modboot-cd.cfg'"
		Rename-Item -Path "$PSScriptRoot\modboot-cd.sam" -newName "$PSScriptRoot\modboot-cd.cfg"
    }
    Else {
        Write-Host "MB-CD: Could not find 'modboot-cd.cfg' OR 'modboot-cd.sam'"
    }
}

Write-Host "MB-CD: Checking for required files..."
ForEach ($file in "bin\Wselect.exe","bin\cabarc.exe") {
    If (-not (Test-Path -Path $file -PathType Leaf)) {
	    Write-Host "MB-CD: File '$file' not found"
	    Abort
    }
}

For ($i = 0; $i -lt $args.Length; $i++) {
	If ($($args[$i]) -eq "-d") {
		$mb_deb = 1
	}
    Else {
		Write-Host "MB-CD: Invalid parameter '$($args[($i)])'."
        Abort
    }
}

Set-Variable -Name mb_count -Value 1
Out-Null > "$env:temp\menu.tmp"
$_menu_item = @("")
Write-Host "`n================== Modboot CD Builder =================="
ForEach ($line in (Get-Content -Path "$PSScriptRoot\modboot-cd.cfg")) {
	$line = $line.Split('#')
    $_str = $($line[0] -Replace "\s+"," ")
    $_command, $_name = $_str.split(" ")
    #$_command = $(Filter-Vars $_command)
    If ($mb_deb -ne $null) { Write-Host "DEBUG: line = [$_name] [$_command]" }
	If ($_command -eq "n") {
		Write-Host "$mb_count`) $_name"
		$_menu_item += $_name
		$mb_count += 1
	}
}
Write-Host "`n"
Write-Host "Q`) Quit"
Write-Host "========================================================"
Set-Variable -Name _entry_quit -Value $mb_count
$choice = Read-Host "`nSelect Configuration"
For ($i = 0; $i -le $mb_count; $i++) {
	If ($choice -eq "Q") {
		End1
	}
	ElseIf ($choice -eq $i) {
		$mb_name = $_menu_item[$i]
	}
}
Write-Host "MB-CD: Building '$mb_name' from '$PSScriptRoot\modboot-cd.cfg'"
Write-Host "MB-CD: Parsing config file '$PSScriptRoot\modboot-cd.cfg'"
ForEach ($line in $(Get-Content -Path "$PSScriptRoot\modboot-cd.cfg")) {
    If ((-not ($line.StartsWith("#"))) -and ($line -ne '')) {
        $line = $line.split('#')
        $line[0]=$line[0] -replace "\s+",' '
        $_a, $_b, $_c, $_d = $line[0] -Split ' '
        If ($mb_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
        _bline $_a $_b $_c $_d
    }
}
If ($mb_err -eq 1) { Abort }
If ($bcd_img -ne $null) { Write-Host "MB-CD: Image '$bcd_img' created." }
Write-Host "MB-CD: Done!"
End1
