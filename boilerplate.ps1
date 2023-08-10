If (-not (Test-Path -Path VERSION -PathType Leaf)) {
    Write-Error "VERSION file doesn't exist!"
	Write-Error "Unknown version error."
	Exit
}
Else {
    Set-Variable -Name _version -Value (Get-Content -Path VERSION)
}

#$Host.UI.RawUI.BackgroundColor = 'Green'
#$Host.UI.RawUI.ForegroundColor = 'DarkGray'
$Host.UI.RawUI.WindowTitle = “Boot Tools - v$_version”
function prompt { 'WolfNet Computing Boot Tools> ' }

Clear-Host
Write-Host "Setting up environment for WolfNet Computing Boot Tools..."
Write-Host "You're running version: $_version"