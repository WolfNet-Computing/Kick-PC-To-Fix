<#
.SYNOPSIS
	This script downloads files from the internet and sets up the netboot files...

.NOTES
    Author: John Wolfe
    Last Edit: 23-08-2023 15:11
#>

#----------------[ Declarations ]----------------

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$file_list = @(
# Individual files.
	("iPXE", "https://wolfnet-computing.com/pxe/ipxe.lkrn", "kernels\ipxe.lkrn", $False),
# ISO images.
	("DSL Linux", "http://distro.ibiblio.org/damnsmall/dslcore/dslcore_20080717.iso", (("boot\dslcore.gz", "kernels\dsl"), ("boot\bzimage", "kernels\dsl")), $True),
	("SliTaz Linux", "http://mirror.slitaz.org/iso/rolling/slitaz-rolling-core-5in1.iso", (("BOOT\BZIMAGE", "kernels\slitaz"), ("BOOT\BZIMAGE6", "kernels\slitaz"), ("BOOT\ROOTFS1.GZ", "kernels\slitaz"), ("BOOT\ROOTFS1.GZ6", "kernels\slitaz"), ("BOOT\ROOTFS2.GZ", "kernels\slitaz"), ("BOOT\ROOTFS3.GZ", "kernels\slitaz"), ("BOOT\ROOTFS4.GZ", "kernels\slitaz"), ("BOOT\ROOTFS5.GZ", "kernels\slitaz")), $True),
	("TinyCore Linux", "http://tinycorelinux.net/14.x/x86/release/CorePlus-current.iso", (
		("boot\core.gz", "kernels\tinycore"),
		("boot\vmlinuz", "kernels\tinycore"),
		("cde\installer.instlist", "tinycore"),
		("cde\kmaps.instlist", "tinycore"),
		("cde\onboot.lst", "tinycore"),
		("cde\remaster.instlist", "tinycore"),
		("cde\wifi.instlist", "tinycore"),
		("cde\wififirmware.instlist", "tinycore"),
		("cde\xbase.lst", "tinycore"),
		("cde\xfbase.lst", "tinycore"),
		("cde\xibase.lst", "tinycore"),
		("cde\xwbase.lst", "tinycore"),
		("cde\optional\advcomp.tcz", "tinycore\optional"),
		("cde\optional\advcomp.tcz.dep", "tinycore\optional"),
		("cde\optional\advcomp.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\aterm.tcz", "tinycore\optional"),
		("cde\optional\aterm.tcz.dep", "tinycore\optional"),
		("cde\optional\aterm.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\atk.tcz", "tinycore\optional"),
		("cde\optional\atk.tcz.dep", "tinycore\optional"),
		("cde\optional\atk.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\bzip2-lib.tcz", "tinycore\optional"),
		("cde\optional\bzip2-lib.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\cairo.tcz", "tinycore\optional"),
		("cde\optional\cairo.tcz.dep", "tinycore\optional"),
		("cde\optional\cairo.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\dbus.tcz", "tinycore\optional"),
		("cde\optional\dbus.tcz.dep", "tinycore\optional"),
		("cde\optional\dbus.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\dosfstools.tcz", "tinycore\optional"),
		("cde\optional\dosfstools.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\expat2.tcz", "tinycore\optional"),
		("cde\optional\expat2.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\ezremaster.tcz", "tinycore\optional"),
		("cde\optional\ezremaster.tcz.dep", "tinycore\optional"),
		("cde\optional\ezremaster.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\firmware-amd-ucode.tcz", "tinycore\optional"),
		("cde\optional\firmware-amd-ucode.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\firmware-atheros.tcz", "tinycore\optional"),
		("cde\optional\firmware-atheros.tcz.md5.txt", "tinycore\optional"),
		("cde\optional\firmware-chelsio.tcz", "tinycore\optional"),
		("cde\optional\firmware-chelsio.tcz.md5.txt", "tinycore\optional")
	), $True),
# ZIP archives.
	("CHNTPW", "http://pogostick.net/~pnh/ntpasswd/usb140201.zip", (("initrd.cgz", "kernels\chntpw\initrd.cgz"), ("scsi.cgz", "kernels\chntpw\scsi.cgz"), ("vmlinuz", "kernels\chntpw\vmlinuz")), $True)
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
$label.Text = "Select the Operating Systems to add to the disk."
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
					Write-Host "CUSTOM: Mounting image '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' at '$_mount_point\'."
					$_mount_point = ((Mount-DiskImage "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -PassThru | Get-Volume).DriveLetter) + ":"
					ForEach ($location in $file[2]) {
						If (-not (Test-Path -Path "$($location[1])")) {
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
						Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$($file[0])\$($location[0])' to '$PSScriptRoot\files\$($location[1])'."
						Move-Item -Path "$env:temp\_netboot_\$($file[0])\$($location[0])" -Destination "$PSScriptRoot\files\$($location[1])" -Force | Out-Null
					}
				}
			}
			Else {
				Write-Host "CUSTOM: Moving file '$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])' to '$PSScriptRoot\files\$($file[2])'."
				Move-Item -Path "$env:temp\_netboot_\$(([uri]$file[1]).Segments[-1])" -Destination "$PSScriptRoot\files\$($file[2])" | Out-Null
			}
			Break
		}
	}
}

# Remove the temporary directory.
Remove-Item -Path "$env:temp\_netboot_" -recurse
End1