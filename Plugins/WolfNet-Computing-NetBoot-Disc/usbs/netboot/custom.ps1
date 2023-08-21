<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 21-08-2023 02:55
#>

#----------------[ Declarations ]----------------

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$file_list = @(
	("iPXE", "https://wolfnet-computing.com/pxe/ipxe.lkrn"),
	("DSL Linux", "http://distro.ibiblio.org/damnsmall/dslcore/dslcore_20080717.iso"),
	("CHNTPW", "http://pogostick.net/~pnh/ntpasswd/usb140201.zip")
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

Function Add-DownloadToList {
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
	If ($download_list -eq $null) {
		$download_list = @(
			($url, $filename)
		)
	}
	Else {
		$download_list += @($url, $filename)
	}
}

#----------------[ Main Execution ]---------------

# Create the form to select the components to be added to the USB.
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select which OSes you want on the USB."
$form.AutoSize = $True
$form.StartPosition = 'CenterScreen'

$listBox = New-Object System.Windows.Forms.CheckedListBox

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# Create the temporary directory for the downloaded files...
If (Test-Path -Path "$env:temp\_netboot_") { Remove-Item -Path "$env:temp\_netboot_" -recurse }
New-Item -Name "_netboot_" -Path $env:temp -itemType Directory

# Download any missing files that can be downloaded...
For ($i=0; $i -lt $download_list.Length; $i++) {
	Download-File -url "$($download_list[$i])" -filename "$env:temp\_netboot_\$(([uri]$download_list[$i]).Segments[-1])"
	If (-not (Test-Path -Path "$env:temp\_netboot_\$(([uri]$download_list[$i]).Segments[-1])")) {
		Write-Host "CUSTOM: Couldn't download file '$env:temp\_netboot_\$(([uri]$download_list[$i]).Segments[-1])'."
		Exit
	}
}

# Remove the temporary directory.
Remove-Item -Path "$env:temp\_netboot_" -recurse