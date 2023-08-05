function Show-Help {
    Write-Host "`n"
    Write-Host "Usage:  bfd [-d] [-i file] [-t type] name [target]"
    Write-Host "`n"
    Write-Host " name:  name of the disk or image to build (see bfd.cfg)"
    Write-Host " target:  target drive or file (default is 'a:')"
    Write-Host " -d:  print debug messages"
    Write-Host " -i file:  create an image file (optional winimage!)"
    Write-Host " -t type:  image type (144 or 288)"
    Write-Host " -n:  don't wait for the user to insert a diskette"
    Write-Host "`n"
    Write-Host "Returns environment variable 'rv', 0 If succesfull, 1 If error"
    Write-Host "`n"
    Write-Host "This program uses the following files (located in the 'bin' directory):"
    Write-Host " - Cabinet Tool (cabarc.exe) by Microsoft Corp."
    End1
}

function Remove-MSDOS {
	Write-Host "BFD: Removing MS-DOS and related files..."
	Remove-Item -Path "cabs\os\md*\*" -Recurse
	Remove-Item -Path  "s\md*\*" -Recurse
	Remove-Item -Path "cabs\ms*.cab"
}

function Add-VarToOptions {
    If ($global:bfd_options -eq $null) {
        $global:bfd_options = @($($args[0]))
    }
    Else {
        $global:bfd_options += $($args[0])
    }
}

function Test-Name {
    ForEach ($line in $(Get-Content -Path "bfd.cfg")) {
        If ((-not ($line.StartsWith("#"))) -and ($line -ne '')) {
            $line = $line.split('#')
            $line[0]=$line[0] -replace "\s+",' '
            $_a, $_b, $_c = $line[0] -Split ' '
            If ($bfd_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
            If (($_a -eq "n") -and ($_b -eq $($args[0]))) {
                Return $true
            }
        }
    }
    If (Test-Path -Path "plugin") {
        ForEach ($file in $(Get-ChildItem -Path "plugin" -Include "*.cfg")) {
            If ($bfd_deb -ne $null) { Write-Host "DEBUG: Testing names in 'plugin\$file'" }
            ForEach ($line in $(Get-Content -Path $file)) {
                If ((-not ($line.StartsWith("#"))) -and ($line -ne '')) {
                    $line = $line.split('#')
                    $line[0]=$line[0] -replace "\s+",' '
                    $_a, $_b, $_c, $_d = $line[0].split(' ')
                    If ($bfd_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
                    If (($_a -eq "n") -and ($_b -eq $args[0])) {
                        Return $true
                    }
                }
            }
        }
    }
    Return $false
}

function Parse-Configuration {
    ForEach ($line in $(Get-Content -Path $($args[0]))) {
        If ((-not ($line.StartsWith("#"))) -and ($line -ne '')) {
            $line = $line.Split('#')
            $_str = $($line[0] -Replace "\s+"," ")
            $_a, $_b, $_c, $_d = $_str.split(" ")
            $_b = $(Filter-Vars $_b)
            If ($bfd_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
            If(-not (Parse-Command $_a $_b $_c $_d)) { Write-Host "BFD: Hit an error while parsing command..."; Abort }
        }
    }
}

function Filter-Vars {
    If ($bfd_os -ne $null) {
        Return $($args[0] -Replace '<os>',$bfd_os)
    }
    Else {
        Return $($args[0])
    }
}

function Invalid-Name {
    Write-Host "BFD: '$bfd_name' is an invalid name!"
    Write-Host "BFD: You must specify one of the following names:"
    ForEach ($line in $(Get-Content -Path "bfd.cfg")) {
        If ((-not ($line.StartsWith("#"))) -and (-not ($line -eq ''))) {
            $line = $line.split('#')
            $line[0] = $line[0] -replace "\s+",' '
            $_a, $_b, $_c, $_d = $line[0].split(' ')
            Parse-Names $_a $_b $_c $_d
        }
    }
    ForEach ($file in $(Get-ChildItem -Path "plugin" -Include "*.cfg")) {
        Write-Host "BFD: Additional names from '$($args[0])'"
		ForEach ($line in $(Get-Content -Path $file)) {
			If ((-not ($line.StartsWith("#"))) -and (-not ($line -eq ''))) {
				$line = $line.split('#')
				$line[0] = $($line[0] -replace "\s+",' ')
				$_a, $_b, $_c, $_d = $line[0].split(' ')
				If ($bfd_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
				Parse-Names $_a $_b $_c $_d
			}
		}
    }
    Abort
}

function Parse-Names {
    If ($global:bfd_deb -ne $null) { Write-Host "DEBUG: line = [$($args[0])] [$($args[1])] [$($args[2])]" }
    If ($($args[0]) -eq "n") { Write-Host $($args[1]) }
}

function Parse-Command {
    If ($global:bfd_deb -ne $null) { Write-Host DEBUG: line = [$($args[0])] [$($args[1])] [$($args[2])] [$($args[3])] }
    If ($($args[0]) -eq "n") {
        _cmd_n $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($bfd_cname -ne $bfd_name) { Return $true }
    If ($($args[0]) -eq "c") {
        _cmd_c $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "t") {
        _cmd_t $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "x") {
        _cmd_x $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "f") {
        _cmd_f $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "m") {
        _cmd_m $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "b") {
        _cmd_b $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "d") {
        _cmd_d $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "o") {
        _cmd_o $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "i") {
        _cmd_i $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    If ($($args[0]) -eq "it") {
        _cmd_it $($args[1]) $($args[2]) $($args[3])
        Return $true
    }
    Write-Host "BFD: Unknown command '$($args[0])'"
    Return $false
}

function _cmd_it {
    $global:bfd_type = $args[0]
    Write-Host "BFD: Image type set to '$bfd_type'"
}

function _cmd_i {
    If (-not (Test-Path -Path $($args[0]))) {
	    Write-Host "BFD: Include file '$($args[0])' not found"
	    Return
    }
    Parse-Configuration $args[0]
}

function _cmd_o {
    Set-Variable -Name bfd_os -Value $args[0] -Scope Script
    Write-Host "BFD: Operating system '$bfd_os'"
    If (-not (Test-Path -Path "$($args[0]).cfg")) {
	    Write-Host "BFD: OS include file '$($args[0]).cfg' not found"
	    Return
    }
    If (-not (Test-Path -Path "os\$($args[0])")) {
	    Write-Host "BFD: OS Folder '$($args[0])' not found"
	    Return
    }
    ForEach ($file in $($args[0]).cfg) { Parse-Command "$file.cfg" }
    If ($global:bfd_bootable -ne $null) {
	    If ($global:bfd_img -ne $null) { _cmd_bi }
	    Write-Host "BFD: Installing bootsector from 'os\$bfd_os\bootsect.bin'"
	    bin\mkbt.exe -x "os\$bfd_os\bootsect.bin" $global:bfd_target
	    If ($LASTEXITCODE -eq 1) {
            Return
        }
	    _cmd_b2
    }
}

function _cmd_b {
    $bfd_bootable = 1
}

function _cmd_bi {
    $bfd_bi = "os\$global:bfd_os\bootsect.bin"
}

function _cmd_b2 {
    If (Test-Path -Path "os\$global:bfd_os\io.sys" -PathType Leaf) { MSDOS }
    If (Test-Path -Path "os\$global:bfd_os\ibmbio.com" -PathType Leaf) { IBM }
    If (Test-Path -Path "os\$global:bfd_os\kernel.sys" -PathType Leaf) { FD }
}

function _cmd_f {
    If ($global:bfd_img -ne $null) { _cmd_fi }
    Write-Host "BFD: Formatting drive '$bfd_target' extra arguments '$($args[0])'"
    If ($global:bfd_nop -eq 1) { _format }
}

function _again {
    Write-Host "`n"
    Write-Host "BFD: Insert floppy to format in drive '$bfd_target'"
    Write-Host "BFD: Warning! All data on floppy will be destroyed!"
    Write-Host "`n"
    bin\bchoice /c:ca /d:c Press C or Enter to continue or A to Abort?
    If ($LASTEXITCODE -eq 1) {
	    Return
    }
    Write-Host "`n"
    _format
}

function _format {
    Write-Host "BFD: Formatting..."
    format $global:bfd_target $($args[0]) /u /backup /v:
    If ($LASTEXITCODE -eq 1) { _again }
}

function _cmd_fi {
    If (-not (Test-Path -Path $global:bfd_target)) { _cmd_fi2 }
    Write-Host "BFD: Remove directory '$global:bfd_target'"
    Remove-Item -Path "$global:bfd_target\*" -Recurse
    If (-not (Test-Path -Path $global:bfd_target)) { _cmd_fi2 }
}

function _cmd_fi2 {
    Write-Host "BFD: Create directory '$global:bfd_target'"
    New-Item -Name $(Split-Path -Path $global:bfd_target -Leaf) -Path $(Split-Path -Path $global:bfd_target -Parent) -ItemType "directory"
    If (-not (Test-Path -Path $global:bfd_target)) { Abort }
}

function _cmd_c {
    Write-Host "BFD: Copying '$($args[0])' to '$($bfd_target)\$($args[1])\'"
    Copy-Item -Path "$($args[0])" -Destination "$bfd_target\$($args[1])\" -Container:$false
}

function _cmd_t {
    If (-not (Test-Path -Path "$($args[0])" -PathType Any)) { Return }
    Write-Host "BFD: Copying $($args[0]) to '$global:bfd_target\$($args[1])'"
    Copy-Item -Path "$($args[0])" -Destination "$global:bfd_target\$($args[1])" -Container:$false
}

function _cmd_d {
    Write-Host "BFD: Copy driver file(s) '$($args[0])' to '$global:bfd_target\$($args[1])'"
    ForEach ($file in $($args[0])) { _cmd_dd $file $($args[1]) $($args[2]) }
}

function _cmd_dd {
    Write-Host "BFD: Copying file '$($args[0])' to '$bfd_target\$($args[1])'"
    Copy-Item -Path $($args[0]) -Destination "$bfd_target\$($args[1])" | Out-Null
    _cmd_da
}

function _cmd_da {
    Write-Host "BFD: Adding driver info to index '$bfd_target\$($args[1])'"
    If (Test-Path -Path "$env:temp\ndis.*" -PathType Leaf) { Remove-Item -Path "$env:temp\ndis.*" }
    bin\cabarc.exe -o "x" "$($args[0]) ndis.*" "$env:temp\"
    If (Test-Path -Path "$bfd_target\$($args[1]).nic" -PathType Leaf) { _cmd_pn }
    Write-Host "; This file is used to manual" > $bfd_target\$($args[1]).nic
    Write-Host "; select a network driver" >> $bfd_target\$($args[1]).nic
    Write-Host ":_ndis 'Select Network driver...' [x]" >> $bfd_target\$($args[1]).nic
}

function _cmd_pn {
    If (exist $bfd_target\$($args[0]).pci) { _cmd_pp }
    Write-Host "; PCI map file (created by bfd.cmd)" > $bfd_target\$($args[0]).pci
    _cmd_pp
    If (exist "$env:temp\ndis.pci") { type $env:temp\ndis.pci >> $bfd_target\$($args[0]).pci }
    If (exist "$env:temp\ndis.txt") { type $env:temp\ndis.txt >> $bfd_target\$($args[0]).nic }
    If (exist "$env:temp\ndis.*") { del $env:temp\ndis.* } 
}

function _cmd_pp {
    If (-not (Test-Path -Path "$env:temp\ndis.txt" -PathType Leaf)) {
	    Write-Host "BFD: Driver '$($args[0])' does not have a ndis.txt file"
    }
}

function _cmd_n {
    Set-Variable bfd_cname $($args[0]) -Scope Global
    If ($global:bfd_deb -ne $null) { Write-Host "DEBUG: cname set to '$bfd_cname'" } 
}

function _cmd_m {
    Write-Host "BFD: Attempt to make directory '$bfd_target\$($args[0])'"
	If (-not (Test-Path -Path "$bfd_target\$($args[0])")) {
		New-Item -Path "$bfd_target\$($args[0])" -ItemType Directory
	}
}

function MSDOS {
    Write-Host "BFD: Copying MS-DOS boot files"
    Parse-Command "c" "os\$bfd_os\io.sys"
    If ($bfd_err -eq 1) { Return }
    $bfd_or = "io.sys"
    Parse-Command "c" "os\$bfd_os\msdos.sys"
    If ($bfd_err -eq 1) { Return }
    Parse-Command "c" "os\$bfd_os\command.com"
    If ($bfd_err -eq 1) { Return }
    Label
}

function IBM {
    Write-Host "BFD: Copying DR-DOS boot files"
    Parse-Command "c" "os\$bfd_os\ibmbio.com"
    If ($bfd_err -eq 1) { Return }
    $bfd_or = "ibmbio.sys"
    Parse-Command "c" "os\$bfd_os\ibmdos.com"
    If ($bfd_err -eq 1) { Return }
    Parse-Command "c" "os\$bfd_os\command.com"
    If ($bfd_err -eq 1) { Return }
    Label
}

function FD {
    Write-Host "BFD: Copying FreeDOS boot files"
    Parse-Command "c" "os\$bfd_os\kernel.sys"
    If ($bfd_err -eq 1) { Return }
    $bfd_or = "kernel.sys"
    Parse-Command "c" "os\$bfd_os\command.com"
    If ($bfd_err -eq 1) { Return }
}

function Label {
    If ($global:bfd_img -ne $null) { Label-Image }
    Write-Host "BFD: Label"
    If ($args[1] -ne $null) { label $global:bfd_target $($args[0]) }
    If ($args[1] -eq $null) { label $global:bfd_target modboot }
    Return
}

function Label-Image {
    If ($args[0] -ne $null) {
        $bfd_la = $($args[0])
    }
    Else {
        $bfd_la = modboot
    }
    bin\mkbt.exe -x "os\$bfd_os\bootsect.bin" $global:bfd_target
}

function _cmd_x {
    Write-Host "BFD: copying folder '$($args[0])' to '$($bfd_target)\'"
	ForEach ($item in "$($args[0])\*") {
		If (($bfd_target -ne $null) -or (-not (Test-Path -Path $bfd_target))) {
			Copy-Item -Path "$($args[0])\*" -Destination "$bfd_target\" -Recurse -Force
		}
		Else {
			Write-Host "BFD: '$($bfd_target)\' already exists!"
		}
	}
}

function Done {
    If ($global:bfd_img -ne $null) { Write-Host BFD: Image "$global:bfd_img" created. }
    Write-Host BFD: Done!
    End1
}

function Abort {
    If ($global:bfd_img -eq $null) { Abort1 }
    If (Test-Path -Path $global:bfd_img -PathType Leaf) {
	    Write-Host "BFD: Removing '$bfd_img'"
	    Remove-Item -Path $global:bfd_img
    }
    Abort1
}

function Abort1 {
	If (Test-Path -Path $($env:temp + '\_bfd_')) {
		Write-Host "BFD: Removing '$env:temp\_bfd_'"
		Remove-Item -Path $($env:temp + '\_bfd_\*') -Recurse
	}
    Write-Host "BFD: Aborted..."
    Write-Host "`n"
    $rv = 1
    Read-Host -Prompt "Press the [Enter] key to continue..."
    End2
}

function End1 {
    $rv = 0
    End2
}

function End2 {
    Write-Host "BFD: Exiting with return value $global:rv"
    Exit
}
