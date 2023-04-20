#
# Pure Storage PowerShell Toolkit 3 - Pre-release
#

Import-Module "Import-PureStoragePowerShellToolkit.ps1"
Get-Module -Name PureStorage* | Select-Object Version, Name

#
# Configure Windows Server with Test Best Practices cmdlet.
# 
Test-Pfa2WindowsBestPractices -IncludeIscsi -Confirm -Repair 