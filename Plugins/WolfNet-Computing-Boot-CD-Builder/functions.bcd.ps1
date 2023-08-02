function Write-CD {
    Clear-Variable -Name bcd_tmp
    If (-not ($bcd_spd -eq $null)) {
        Set-Variable -Name bcd_tmp -Value $bcd_spd -Scope Script
        Set-Variable -Name speed -Value $bcd_spd -Scope Script
    }
    Write-Host "BCD: Burning CD-Rom (running cdrecord.exe)"
    Write-Host "BCD: Arguments; dev=$bcd_dev $bcd_tmp -v $bcd_cdr $_save_location"
    bin\cdrecord.exe dev=$bcd_dev $bcd_tmp -v $bcd_cdr $_save_location
    If ($LASTEXITCODE -eq 1) {
	    Write-Host "BCD: cdrecord returned an error"
	    Abort
    }
    Clear-Variable -Name bcd_tmp
    Write-Host "BCD: Recording '$bcd_name' done."
    End1
}

function Detect-CD {
    Write-Host "BCD: Looking for devices, running 'cdrecord -scanbus'"
    bin\cdrecord.exe -scanbus > $env:temp\_bcd_.tmp | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Error "BCD:'cdrecord -scanbus' returned an error! Burning not possible!"
	    Set-Variable -Name bcd_noburn -Value 1 -Scope Script
	    Abort
    }
    findstr /I "/C:cd-rom" $env:temp\_bcd_.tmp > $env:temp\_bcd_.tm2
    If (-not (Test-Path -Path "$env:temp\_bcd_.tm2" -PathType Leaf)) {
        Write-Error "BCD: No CD-ROM type devices found! Burning not possible!"
        Set-Variable -Name bcd_noburn -Value 1 -Scope Script
        Abort
    }
    Write-Host "BCD: Found CD-ROM devices:"
    type $env:temp\_bcd_.tm2
    Write-Host "BCD: Looking for a CD-RW drive:"
    ForEach ($string in (Get-Content -Path "$env:temp\_bcd_.tm2" -Delimiter "")) {
	    Set-Variable -Name bcd_tmp -Value $string -Scope Script
	    Check-CD "Does write CD-RW media"
        If (-not ($bcd_dev -eq $null)) { Break }
    }
    Write-Host "BCD: Looking for a CD-R drive:"
    ForEach ($string in (Get-Content -Path "$env:temp\_bcd_.tm2" -Delimiter "")) {
	    Set-Variable -Name bcd_tmp -Value $string -Scope Script
	    Check-CD "Does write CD-R media"
        If (-not ($bcd_dev -eq $null)) { Break }
    }
    Write-Host "BCD: Looking for a DVD-R drive:"
    ForEach ($string in (Get-Content -Path "$env:temp\_bcd_.tm2" -Delimiter "")) {
	    Set-Variable -Name bcd_tmp -Value $string -Scope Script
	    Check-CD "Does write DVD-R media"
        If (-not ($bcd_dev -eq $null)) { Break }
    }
    If ($bcd_dev -eq $null) {
	    Write-Error "BCD: No CD writer device found! Burning not possible!"
	    Set-Variable -Name bcd_noburn -Value 1 -Scope Script
	    Abort
    }

}

function Detect-CDOptions {
    Write-Host "BCD: Found writer device at '$bcd_dev'."
    If ($bcd_cdr -eq $null) {
	    Write-Host "BCD: No cdrecord options, adding '-data -eject'"
	    Set-Variable -Name bcd_cdr -Value "-data -eject" -Scope Script
    }
    Write-Host "BCD: Checking driver specific options"
    Write-Host "BCD: Running 'cdrecord.exe dev=$bcd_dev -checkdrive driveropts=help'"
    bin\cdrecord.exe dev=$bcd_dev -checkdrive driveropts=help >$env:temp\_bcd_.tmp | Out-Null
    If (-not ($LASTEXITCODE -eq 0)) {
        findstr /I /B "burnfree " $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm2
        If (Test-Path -Path $env:temp\_bcd_.tm2 -PathType Leaf) {
            Write-Host "BCD: Drive supports burnfree, adding 'driveropts=burnfree'"
            Set-Variable -Name bcd_cdr -Value "%bcd_cdr% driveropts=burnfree" -Scope Script
        }
    }
    Write-Host "BCD: Loading media"
    bin\cdrecord.exe dev=%bcd_dev% -load >nul | Out-Null
    If ($LASTEXITCODE -eq 1) { NoMedia }
    Write-Host "BCD: Checking media type"
    bin\cdrecord.exe dev=%bcd_dev% -atip >$env:temp\_bcd_.tmp | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Error "BCD: cdrecord returned an error"
	    type $env:temp\_bcd_.tmp
	    Abort
    }
    findstr /I "/C:No disk / Wrong disk!" $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm3
    If (Test-Path -Path "$env:temp\_bcd_.tm3" -PathType Leaf) { NoMedia }
    findstr /I "/C:Is erasable" $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm3
    If (Test-Path -Path "$env:temp\_bcd_.tm3" -PathType Leaf) { IsCDRW }
    IsCDR
}

function IsCDRW {
    Write-Host "BCD: Media is CD-RW, checking If erase is needed"
    bin\cdrecord.exe dev=$bcd_dev -toc >$env:temp\_bcd_.tmp | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Host "BCD: cdrecord returned an error"
	    type $env:temp\_bcd_.tmp
	    Abort
    }
    findstr /I "/C:Cannot read TOC header" $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm3
    If (Test-Path -Path "$env:temp\_bcd_.tm3" -PathType Leaf) { 
        IsBlank
        Break
    }
    Write-Host "BCD: Erasing CD-RW"
    Clear-Variable -Name bcd_tmp
    If (-not ($bcd_spd -eq $null)) {
        Set-Variable -Name bcd_tmp -Value $bcd_spd -Scope Script
        Set-Variable -Name speed -Value $bcd_spd -Scope Script
    }
    bin\cdrecord.exe dev=$bcd_dev $bcd_tmp -v blank=fast
    If ($LASTEXITCODE -eq 1) {
	    Write-Host "BCD: cdrecord returned an error"
	    Abort
    }
    Write-CD
    Clear-Variable -Name bcd_tmp
}

function IsBlank {
    Write-Host "BCD: Media is blank, so we're ready to record."
    Write-CD
}

function IsCDR {
    Write-Host "BCD: Media is CD-R, checking blank"
    bin\cdrecord.exe dev=%bcd_dev% -toc >$env:temp\_bcd_.tmp | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Error "BCD: cdrecord returned an error"
	    type $env:temp\_bcd_.tmp
	    Abort
    }
    findstr /I "/C:Cannot read TOC header" $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm3
    If (Test-Path -Path "$env:temp\_bcd_.tm3" -PathType Leaf) {
        IsBlank
        Break
    }
    Write-Host "BCD: Media not blank, insert other media for '$bcd_name'..."
    bin\cdrecord.exe dev=$bcd_dev -eject >nul | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Error "BCD: cdrecord returned an error"
	    type "$env:temp\_bcd_.tmp"
	    Abort
    }
    bin\bchoice.exe /c:ca /d:c Press C or Enter to continue or A to Abort?
    If ($LASTEXITCODE -eq 1) { goto End1 }
    Write-CD
}

function NoMedia {
    Write-Host "BCD: Insert media for '%bcd_name%'..."
    bin\cdrecord.exe dev=%bcd_dev% -eject | Out-Null
    If ($LASTEXITCODE -eq 1) {
	    Write-Host "BCD: cdrecord returned an error"
	    type "$env:temp\_bcd_.tmp"
	    Abort
    }
    bin\bchoice /c:ca /d:c Press C or Enter to continue or A to Abort?
    If ($LASTEXITCODE -eq 1) { End1 }
    Write-CD
}

function Check-CD {
	If ($bcd_dev -eq $null) { End2 }
	If (Test-Path -Name "$env:temp\_bcd_.tm3" -PathType Leaf) { Remove-Item -Path "$env:temp\_bcd_.tm3" }
	Write-Host "BCD: Get drive capabilities for device $bcd_tmp"
	bin\cdrecord.exe dev=%bcd_tmp% -prcap > $env:temp\_bcd_.tmp | Write-Host 
	If ($LASTEXITCODE -eq 1) { End2 }
	If (-not ($bcd_deb -eq $null)) {
	    Write-Host "DEBUG: Drive capabilities output from device $bcd_tmp"
	    type "$env:temp\_bcd_.tmp"
	    Write-Host "DEBUG: End of drive capabilities output"
	    Write-Host "DEBUG: Looking for '%*'"
        findstr /L "/C:%*" $env:temp\_bcd_.tmp >$env:temp\_bcd_.tm3
	    If (Test-Path -Path "$env:temp\_bcd_.tm3" -PathType Leaf) { Set-Variable -Name bcd_dev -Value $bcd_tmp -Scope Script }
	    End2
    }
}

function Parse-Configuration {
    ForEach ($line in $(Get-Content -Path $($args[0]))) {
        If ((-not ($line.StartsWith("#"))) -and (-not ($line -eq ''))) {
            $line = $line.split('#')
            $_a, $_b, $_c, $_d, $_e, $_f = $line[0].split(' ')
            If ($args[0].EndsWith("bcd.cfg")) {
                Parse-ConfigFile $_a $_b $_c $_d $_e $_f
            }
            Else {
                Parse-BootConfigFile $_a $_b $_c $_d $_e $_f
            }
        }
    }
}

function Parse-ConfigFile {
	#If ($bcd_deb -ne $null) {
        Write-Host "DEBUG: cmd=[$($args[0])] arg=[$($args[1])] err=[$bcd_err]"
    #}
	If ($bcd_err -eq 1) { Abort }
	If ($($args[0]) -eq "bootfile") {
		Set-Variable -Name bcd_boot -Value $($args[1]) -Scope Script
		Add-VarToIsofs "-b"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "volumeid") {
		Add-VarToIsofs "-volid"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "volumeset") {
		Add-VarToIsofs "-volset"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "preparer") {
		Add-VarToIsofs "-preparer"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "publisher") {
		Add-VarToIsofs "-publisher"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "application") {
		Add-VarToIsofs "-appid"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "system") {
		Add-VarToIsofs "-sysid"
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "mkisofsargs") {
		Add-VarToIsofs $($args[1])
		Return
    }
	If ($($args[0]) -eq "cdrecordargs") {
		Set-Variable -Name bcd_cdr -Value $($args[1]) -Scope Script
		Return
    }
	If ($($args[0])-eq "call") {
		Set-Variable -Name bcd_call -Value $($args[1]) -Scope Script
		Return
    }
	If ($($args[0])-eq "addpath") {
		Set-Variable -Name bcd_path -Value $($args[1]) -Scope Script
		Return
    }
	Write-Host "BCD: unknown keyword '$($args[0])'"
	Set-Variable -Name bcd_err -Value 1
}

function ParseAndCount-BootConfigFile {
	If ($bcd_err -eq 1) { Break }
	Write-Host "BCD: Creating bootimage '$($args[2])'"
	bfd.cmd -i $($args[0])\files\$($args[2]) $($args[1])
	If ($rv -eq 1) {
		Set-Variable -Name bcd_err -Value 1
		Break
    }
	Set-Variable -Name bcd_cnt -Value $($bcd_cnt++)
}
	
function Parse-BootConfigFile {
	If ($bcd_err -eq 1) { Break }
	If (Test-Path -Path "cds\%bcd_name%\files\$($args[1])" -PathType Leaf) {
        Write-Host "BCD: Bootimage '$($args[1])' already exists, skip creation"
        Break
    }
	Write-Host "BCD: Bootimage '$($args[1])' does not exist, let's create it now!"
	bfd.cmd -i cds\%bcd_name%\files\$($args[1]) $($args[0])
	If ($rv -eq 1) {
        Set-Variable -Name bcd_err -Value 1
    }
}

function IsNotNT {
    ForEach ($item in $bcd_tmp) {
        Write-Host "BCD: Hiding boot image in ISO9660, adding '-hide $(Split-Path $item -Leaf)'"
        Add-VarToIsofs "-hide"
        Add-VarToIsofs "$(Split-Path $item -Leaf)"
    }
    Write-Host "BCD: Hiding boot catalog in ISO9660, adding '-hide boot.cat'"
    Add-VarToIsofs "-hide"
    Add-VarToIsofs "boot.cat"
    If ($bcd_isofs -like "*-J*") {
        ForEach ($item in $bcd_tmp) {
            Write-Host "BCD: Hiding boot image in Joliet adding '-hide-joliet $(Split-Path $item -Leaf)'"
            Add-VarToIsofs "-hide-joliet"
            Add-VarToIsofs "$(Split-Path $item -Leaf)"
        }
        Write-Host "BCD: Hiding boot catalog in Joliet adding '-hide-joliet boot.cat'"
        Add-VarToIsofs "-hide-joliet"
        Add-VarToIsofs "boot.cat"
    }
}

function Add-VarToIsofs {
    If ($bcd_isofs -eq $null) {
        $global:bcd_isofs = @($($args[0]))
    }
    Else {
        $global:bcd_isofs += $($args[0])
    }
}

function Build-All {
	If ($bcd_err -eq 1) { Break }
	Write-Host "BCD: Processing CD/DVD '$($args[0])'"
	If (-not (Test-Path -Path "$($args[0])\bootdisk.cfg" -PathType Leaf)) { Break }
	Write-Host "BCD: Processing bootdisk config file '$($args[0])\bootdisk.cfg'"
	Clear-Variable -Name rv
	ForEach ($line in "$($args[0])\bootdisk.cfg") {
        Parse-BootConfigFile $($args[0]) %%j %%k
	}
    If ($bcd_err -eq 1) { Abort }
}

function Build-AllBoot {
	Write-Host "BCD: Build all bootimages!"
	Set-Variable -Name bcd_cnt -Value 0
	ForEach ($item in (Get-ChildItem -Path "cds" -Directory)) {
        Build-All $item
    }
	Write-Host "BCD: $bcd_cnt boot disk(s) were built."
}

function Abort {
	If (Test-Path -Path $_save_location -PathType Leaf) {
		Write-Host "BCD: Aborting, removing ISO file '$_save_location'"
		Remove-Item -Path %_save_location%
	}
	Write-Error "BCD: Aborted..."
	Set-Variable -Name rv -Value 1
	End2
}

function End1 {
	Set-Variable -Name rv -Value 0
    End2
}

function End2 {
    If (Test-Path -Path "$env:temp\_bcd_.tm?" -PathType Leaf) {
		Write-Host "BCD: Removing temp file(s) '$env:temp\_bcd_.tm?'"
		Remove-Item -Path "$env:temp\_bcd_.tm?"
	}
    If ($bcd_isofs -ne $null) {
        Remove-Item variable:bcd_isofs
    }
	Write-Host "BCD: Exiting with return value $rv"
    End3
}

function End3 {
    Exit
}
