function Filter-Vars {
	If ($args[0] -like "*<name>*") {
		Return $($args[0].Replace("<name>",$script:mb_name))
	}
	Else {
		Return $args[0]
	}
}

function _bline {
	If ($mb_deb -eq 1) { Write-Host "DEBUG: line = [$($args[1])] [$($args[2])] [$($args[3])]" }
	If ($mb_err -eq 1) { Return }
	If ($args[0] -eq "n") {
		_cmd_n $args[1] $args[2] $args[3]
		Return
	}
	If ($mb_cname -ne $mb_name) { Return }
	Set-Variable -Name mb_ok -Value 1
	If ($args[0] -eq "c") {
		_cmd_c $args[1] $args[2] $args[3]
		Return
	}
	If ($args[0] -eq "t") {
		_cmd_t $args[1] $args[2] $args[3]
		Return
	}
	If ($args[0] -eq "x") {
		_cmd_x $args[1] $args[2] $args[3]
		Return
	}
	If ($args[0] -eq "m") {
		_cmd_m $args[1] $args[2] $args[3]
		Return
	}
	If ($args[0] -eq "d") {
		_cmd_d $args[1] $args[2] $args[3]
		Return
	}
	If ($args[0] -eq "i") {
		_cmd_i $args[1] $args[2] $args[3]
		Return
	}
	Write-Host "MB-CD: Unknown command '$($args[0])'"
	Set-Variable -Name mb_err -Value 1
}

function _cmd_i {
	If (-not (Test-Path -Path $args[0])) {
		Write-Host "MB-CD: Include file '$($args[0])' not found"
		Set-Variable -Name mb_err -Value 1
		Return
	}
	ForEach ($line in $(Get-Content -Path $args[0])) {
		If ((-not ($line.StartsWith("#"))) -and ($line -ne '')) {
			$line = $line.split('#')
			$line[0]=$line[0] -replace "\s+",' '
			$_a, $_b, $_c, $_d = $line[0] -Split ' '
			If ($mb_deb -ne $null) { Write-Host "DEBUG: _a =[$_a] _b=[$_b] _c=[$_c] _d=[$_d]" }
			_bline $_a $_b $_c $_d
		}
	}
}

function _cmd_c {
    Write-Host "MB-CD: Copying '$($args[0])' to '$($mb_target)\$($args[1])\'"
    Copy-Item -Path "$($args[0])" -Destination "$mb_target\$($args[1])\" -Container:$false | Out-Null
}

function _cmd_t {
    If (-not (Test-Path -Path "$($args[0])" -PathType Any)) { Return }
    Write-Host "MB-CD: Copying $($args[0]) to '$global:mb_target\$($args[1])'"
    Copy-Item -Path "$($args[0])" -Destination "$global:mb_target\$($args[1])" -Container:$false
}

function _cmd_d {
    Write-Host "MB-CD: Copy driver file(s) '$($args[0])' to '$mb_target\$($args[1])'"
    ForEach ($file in $($args[0])) { _cmd_dd $file $($args[1]) $($args[2]) $($args[3])}
}

function _cmd_dd {
    Write-Host "MB-CD: Copying file '$($args[0])' to '$mb_target\$($args[1])'"
    Copy-Item -Path $($args[0]) -Destination "$mb_target\$($args[1])" | Out-Null
    _cmd_da $($args[0]) $($args[2])
}

function _cmd_da {
    Write-Host "MB-CD: Adding driver info to index '$mb_target\$($args[1]).nic'"
    If (Test-Path -Path "$env:temp\ndis.*" -PathType Leaf) { Remove-Item -Path "$env:temp\ndis.*" }
    bin\cabarc.exe -o "x" "$($args[0])" "ndis.*" "$env:temp\"
    If (Test-Path -Path "$mb_target\$($args[1]).nic" -PathType Leaf) { _cmd_pn }
	New-Variable -Name _str -Value @(
		"; This file is used to manual",
		"; select a network driver",
		":_ndis 'Select Network driver...' [x]"
	)
	Out-File -FilePath "$mb_target\$($args[1]).nic" -InputObject $_str -Force
}

function _cmd_pn {
    If (Test-Path -Path $mb_target\$($args[0]).pci -PathType Leaf) { _cmd_pp }
	Out-File -FilePath "$mb_target\$($args[0]).pci" -InputObject "; PCI map file (created by mb.cmd)" -Force
    _cmd_pp
    If (Test-Path -Path "$env:temp\ndis.pci" -PathType Leaf) { type $env:temp\ndis.pci >> "$mb_target\$($args[0]).pci "}
    If (Test-Path -Path "$env:temp\ndis.txt" -PathType Leaf) { type $env:temp\ndis.txt >> "$mb_target\$($args[0]).nic "}
    If (Test-Path -Path "$env:temp\ndis.*" -PathType Leaf) { del $env:temp\ndis.* } 
}

function _cmd_pp {
    If (-not (Test-Path -Path "$env:temp\ndis.txt" -PathType Leaf)) {
	    Write-Host "MB-CD: Driver '$($args[0])' does not have a ndis.txt file"
    }
}

function _cmd_n {
    Set-Variable mb_cname -Value $($args[0]) -Scope Global
    If ($global:mb_deb -ne $null) { Write-Host "DEBUG: cname set to '$mb_cname'" } 
}

function _cmd_m {
    Write-Host "MB-CD: Attempt to make directory '$mb_target\$($args[0])'"
	If (-not (Test-Path -Path "$mb_target\$($args[0])")) {
		New-Item -Path "$mb_target\$($args[0])" -ItemType Directory
	}
}

function _cmd_x {
    Write-Host "MB-CD: copying folder '$($args[0])' to '$mb_target\'"
	ForEach ($item in "$($args[0])\*") {
		If (($mb_target -ne $null) -or (-not (Test-Path -Path $mb_target))) {
			Copy-Item -Path "$($args[0])\*" -Destination "$mb_target\" -Recurse -Force
		}
		Else {
			Write-Host "MB-CD: '$mb_target\' already exists!"
		}
	}
}

function _nuke_dir {
	If (Test-Path -Path *.tmp -PathType Leaf) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing any and all '.tmp' files from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\*.tmp"
	}
	If (Test-Path -Path .\cds\$bcd_name\files\level0\*) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing 'level0' directory from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\files\level0\*" -Recurse
	}
	If (Test-Path -Path .\cds\$bcd_name\files\level1\*) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing 'level1' directory from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\files\level1\*" -Recurse
	}
	If (Test-Path -Path .\cds\$bcd_name\files\level2\*) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing 'level2' directory from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\files\level2\*" -Recurse
	}
	If (Test-Path -Path .\cds\$bcd_name\files\level3\*) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing 'level3' directory from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\files\level3\*" -Recurse
	}
	If (Test-Path -Path .\cds\$bcd_name\files\lib\*) {
		If ($mb_deb -eq 1) { Write-Host "DEBUG: Removing 'lib' directory from '.\cds\$bcd_name\files'" }
		Remove-Item -Path ".\cds\$bcd_name\files\lib\*" -Recurse
	}
}

function Abort {
	If (Test-Path -Path $bcd_img -PathType Leaf) {
		Write-Host "MB-CD: Removing '$bcd_img'"
		Remove-Item -Path $bcd_img
	}
	Abort1
}

function Abort1 {
	Write-Host "MB-CD: Aborted..."
	Set-Variable -Name rv -Value 1
	End2
}

function End1 {
	Set-Variable -Name rv -Value 0
	End2
}

function End2 {
	Write-Host "MB-CD: Exiting with return value $rv"
	Exit $rv
}
