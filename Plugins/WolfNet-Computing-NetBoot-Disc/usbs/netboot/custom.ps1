<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 30-08-2023 23:20
#>

#----------------[ Declarations ]----------------

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Invoke-WebRequest -Uri "https://wolfnet-computing.com/netboot_list.ps1" -OutFile $PSScriptRoot\netboot_list.ps1
. $PSScriptRoot\netboot_list.ps1

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

function Abort {
	Write-Host "CUSTOM: Aborted..."
	Set-Variable -Name rv -Value 1
	End2
}

function End1 {
	Set-Variable -Name rv -Value 0
	End2
}

function End2 {
	Write-Host "CUSTOM: Exiting with return value $rv"
	Exit $rv
}

#----------------[ Main Execution ]---------------

# Create the form to select the components to be added to the USB.
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select the OSes."
$form.AutoSize = $True
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select the Operating Systems/Tools to add to the disk."
$label.Location  = New-Object System.Drawing.Point(10,10)
$label.AutoSize = $True
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.CheckedListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(265,260)
$listBox.CheckOnClick = $True
$form.Controls.Add($listBox)

For ($i=0; $i -lt $file_list.Length; $i++) {
	$listBox.Items.Add($file_list[$i][0], $False) | Out-Null
}

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(125,310)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(200,310)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$result = $form.ShowDialog()
If ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
	Write-Error "User cancelled the dialog."
	Abort
}

# Create the temporary directory for the downloaded files...
If (Test-Path -Path "$env:temp\_netboot_") { Remove-Item -Path "$env:temp\_netboot_" -recurse }
New-Item -Name "_netboot_" -Path $env:temp -itemType Directory | Out-Null

# Download any OSes that have been selected...
ForEach ($item in $listBox.CheckedItems) {
	ForEach ($file in $file_list) {
		If ($($file[0]) -eq [string]$item) {
			Download-File -url $file[1] -filename "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])"
			If (-not (Test-Path -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])")) {
				Write-Error "CUSTOM: Couldn't download file '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])'."
				Abort
			}
			If ($($file[3])) {
				If ($(([uri]$file[1]).Segments[-1].EndsWith(".iso"))) {
					$_mount_point = ((Mount-DiskImage "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -PassThru | Get-Volume).DriveLetter) + ":"
					Write-Host "CUSTOM: Mounted image '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' at '$_mount_point\'."
					ForEach ($location in $file[2]) {
						If (-not (Test-Path -Path "$PSScriptRoot\files\$($location[1])")) {
							Write-Host "CUSTOM: Creating Directory '$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)' in '$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)'."
							New-Item -Name "$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)" -Path "$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)" -itemType Directory -Force | Out-Null
						}
						Write-Host "CUSTOM: Copying file '$_mount_point\$($location[0])' to '$PSScriptRoot\files\$($location[1])'."
						Copy-Item -Path "$_mount_point\$($location[0])" -Destination "$PSScriptRoot\files\$($location[1])\$(Split-Path $location[0] -leaf)" -Force | Out-Null
					}
					Dismount-DiskImage -ImagePath "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" | Out-Null
				}
				ElseIf ($(([uri]$file[1]).Segments[-1].EndsWith(".zip"))) {
					Write-Host "CUSTOM: Extracting archive '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])'."
					New-Item -Name "$($file[0])" -Path "$env:temp\_netboot_" -itemType Directory | Out-Null
					Expand-Archive -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -DestinationPath "$env:temp\_netboot_\$($file[0])"
					ForEach ($location in $file[2]) {
						If (-not (Test-Path -Path "$PSScriptRoot\files\$($location[1])")) {
							Write-Host "CUSTOM: Creating Directory '$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)' in '$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)'."
							New-Item -Name "$(Split-Path $PSScriptRoot\files\$($location[1]) -leaf)" -Path "$(Split-Path $PSScriptRoot\files\$($location[1]) -parent)" -itemType Directory -Force | Out-Null
						}
						Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$($file[0])\$($location[0])' to '$PSScriptRoot\files\$($location[1])'."
						Move-Item -Path "$env:temp\_netboot_\$($file[0])\$($location[0])" -Destination "$PSScriptRoot\files\$($location[1])" -Force | Out-Null
					}
				}
				Else {
					Write-Host "CUSTOM: Unrecognised archive type..."
					Write-Host "CUSTOM: Unable to extract!"
				}
			}
			Else {
				Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' to '$PSScriptRoot\files\$($file[2])\$(([uri]$file[1]).Segments[-1])'."
				Move-Item -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -Destination "$PSScriptRoot\files\$($file[2])\$(([uri]$file[1]).Segments[-1])" | Out-Null
			}
			Break
		}
	}
}

# Remove the temporary directory and files.
Remove-Item -Path "$env:temp\_netboot_" -recurse
Remove-Item -Path "$PSScriptRoot\netboot_list.ps1"

End1