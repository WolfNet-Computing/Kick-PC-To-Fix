<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 21-08-2023 02:55
#>

#----------------[ Declarations ]----------------

$file_list = @(
	"https://wolfnet-computing.com/pxe/ipxe.lkrn"
)

$iso_list = @(
	"http://distro.ibiblio.org/damnsmall/dslcore/dslcore_20080717.iso"
)

$zip_list = @(
	"http://pogostick.net/~pnh/ntpasswd/usb140201.zip"
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

function Add-DownloadToList {
	<#
	.SYNOPSIS
		This advanced function adds a location to the download list.

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
	If ($downloads -eq $null) {
		$downloads = @(
			()
		)
	}
}

#----------------[ Main Execution ]---------------

# Create the temporary directory for the downloaded ISO files...
If (Test-Path -Path "$env:temp\_iso_") { Remove-Item -Path "$env:temp\_iso_" -recurse }
New-Item -Name "_iso_" -Path $env:temp -itemType Directory

# Create the temporary directory for the downloaded ZIP files...
If (Test-Path -Path "$env:temp\_zip_") { Remove-Item -Path "$env:temp\_zip_" -recurse }
New-Item -Name "_zip_" -Path $env:temp -itemType Directory

# Download any missing files that can be downloaded...
For ($i=0; $i -lt $file_list.Length; $i++) {
	Download-File -url "$($file_list[$i])" -filename ".\usbs\$busbd_name\files\kernels\$(([uri]$file_list[$i]).Segments[-1])"
	If (-not (Test-Path -Path ".\usbs\$busbd_name\files\kernels\$(([uri]$file_list[$i]).Segments[-1])")) {
		Write-Host "CUSTOM: Couldn't download file '.\usbs\$busbd_name\files\kernels\$(([uri]$file_list[$i]).Segments[-1])'."
		Exit
	}
}

# Download any ISO files necessary for the disk...
For ($i=0; $i -lt $iso_list.Length; $i++) {
	Download-File -url "$($iso_list[$i])" -filename "$env:temp\_iso_\$(([uri]$iso_list[$i]).Segments[-1])"
	If (-not (Test-Path -Path "$env:temp\_iso_\$(([uri]$iso_list[$i]).Segments[-1])")) {
		Write-Host "CUSTOM: Couldn't download file '$env:temp\_iso_\$(([uri]$iso_list[$i]).Segments[-1])'."
		Exit
	}
}

# Download any ZIP files necessary for the disk...
For ($i=0; $i -lt $zip_list.Length; $i++) {
	Download-File -url "$($zip_list[$i])" -filename "$env:temp\_zip_\$(([uri]$zip_list[$i]).Segments[-1])"
	If (-not (Test-Path -Path "$env:temp\_zip_\$(([uri]$zip_list[$i]).Segments[-1])")) {
		Write-Host "CUSTOM: Couldn't download file '$env:temp\_zip_\$(([uri]$zip_list[$i]).Segments[-1])'."
		Exit
	}
}

# Mount ISOs and extract necessary files.

# Extract necessary files from ZIP archives.

Remove-Item -Path "$env:temp\_iso_" -recurse
Remove-Item -Path "$env:temp\_zip_" -recurse