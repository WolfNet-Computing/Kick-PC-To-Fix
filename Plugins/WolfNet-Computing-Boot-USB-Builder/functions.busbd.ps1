function End2 {
	If (Test-Path -path "$env:TEMP\temp.ps1" -PathType Leaf) { Remove-Item -Path "$env:TEMP\temp.ps1" }
	If (Test-Path -path "$env:TEMP\_diskpart_.txt" -PathType Leaf) { Remove-Item -Path "$env:TEMP\_diskpart_.txt" }
	Write-Host "BUSBD: Returning with return value $rv"
    Exit
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
	Write-Host "BUSBD: Creating bootdrive '$args[3]'"
	.\bfd -i "$($args[1])\files\$($args[3])" -p "$($args[2])"
	If ($rv -eq 1) {
		Set-Variable -Name busbd_err -Value 1 -Scope Script
		Return
	}
}

function Parse-Configuration {
    ForEach ($line in (Get-Content -Path $($args[0]))) {
        If ((-not ($line.StartsWith("#*"))) -and (-not ($line.StartsWith("")))) {
            $line = $line.split("#")
            $a, $b, $c = $line[0].split(" ")
            If ($args[0].EndsWith("busbd.cfg")) {
                Parse-ConfigFile $a $b $c
            }
            Else {
                Parse-BootConfigFile $a $b $c
            }
        }
    }
}

function Parse-ConfigFile {
	If ($busbd_deb -eq 1) { Write-Host ("debug: cmd=[$($args[0])] arg=[$($args[1])] err=[$busbd_err]") }
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
	Set-Variable -Name busbd_err -Value 1 -Scope Script
}

function Parse-BootConfigFile {
	If ($busbd_err -eq 1) { Return }
    If (Test-Path -path usbs\$busbd_name\files\$args[2] -PathType Leaf) {
		Write-Information "BUSBD: Bootdrive '$args[2]' already exists, skip creation"
		Return
	}
	Write-Host "BUSBD: Bootdrive '$args[2]' does not exist, let's create it now!"
	.\bfd -i usbs\$busbd_name\files\$args[2] $args[0]
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