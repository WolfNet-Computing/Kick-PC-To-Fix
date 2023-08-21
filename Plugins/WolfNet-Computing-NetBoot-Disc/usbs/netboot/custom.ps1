<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 16-08-2023 03:07
#>

#----------------[ Declarations ]----------------

$file_list = @(
	"https://wolfnet-computing.com/pxe"
)

$iso_list = @(
	"http://distro.ibiblio.org/damnsmall/dslcore"
)

$zip_list = @(
	"http://pogostick.net/~pnh/ntpasswd"
)

#----------------[ Functions ]------------------

Function Download-File {
	<#
	.SYNOPSIS
		This advanced function downloads a file from the internet.

	.PARAMETER url
		The parameter url is used to define the URI to be downloaded from.

	.PARAMETER filename
		The parameter filename is used to define the file to download to.

	.NOTES
		Author: John Wolfe
	#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, Position=0)]
        [string]$url,

        [Parameter(Mandatory=$True)]
        [string]$filename
    )
	Write-Host "CUSTOM: Downloading '$filename' from '$url'."
	Invoke-WebRequest -Uri $url -OutFile $filename
}

#----------------[ Main Execution ]---------------

# Download any missing files that can be downloaded...
ForEach ($directory in ".\usbs\$busbd_name\files") {
	ForEach ($file in "$directory\kernels\ipxe.lkrn") {
		If (-not (Test-Path -Path "$file")) {
			For ($i=0; $i -le $file_list.Length; $i++) {
				Download-File -url "$($file_list[$i])/$([System.IO.Path]::GetFileName($file))" -filename "$file"
				If (Test-Path -Path "$file") { Break }
			}
			If (-not (Test-Path -Path "$file")) {
				Write-Host "CUSTOM: Couldn't download file '$file'."
				Exit
			}
		}
	}
}

# Create the temporary directory for the downloaded ISO files...
New-Item -Name "_iso_" -Path $env:temp -itemType Directory

# Download any ISO files necessary for the disk...
ForEach ($directory in "$env:temp\_iso_") {
	ForEach ($file in "$directory\dslcore_20080717.iso") {
		If (-not (Test-Path -Path "$file")) {
			For ($i=0; $i -le $iso_list.Length; $i++) {
				Download-File -url "$($iso_list[$i])/$([System.IO.Path]::GetFileName($file))" -filename "$file"
				If (Test-Path -Path "$file") { Break }
			}
			If (-not (Test-Path -Path "$file")) {
				Write-Host "CUSTOM: Couldn't download file '$file'."
				Exit
			}
		}
	}
}

# Create the temporary directory for the downloaded ZIP files...
New-Item -Name "_zip_" -Path $env:temp -itemType Directory

# Download any ZIP files necessary for the disk...
ForEach ($directory in "$env:temp\_zip_") {
	ForEach ($file in "$directory\usb140201.zip") {
		If (-not (Test-Path -Path "$file")) {
			For ($i=0; $i -le $zip_list.Length; $i++) {
				Download-File -url "$($zip_list[$i])/$([System.IO.Path]::GetFileName($file))" -filename "$file"
				If (Test-Path -Path "$file") { Break }
			}
			If (-not (Test-Path -Path "$file")) {
				Write-Host "CUSTOM: Couldn't download file '$file'."
				Exit
			}
		}
	}
}

# Mount ISOs and extract necessary files.

# Extract necessary files from ZIP archives.

Remove-Item -Path $env:temp\_iso_ -recurse
Remove-Item -Path $env:temp\_zip_ -recurse