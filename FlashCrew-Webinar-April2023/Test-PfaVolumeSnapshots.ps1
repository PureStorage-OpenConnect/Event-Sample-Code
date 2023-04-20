#
# Working with Pure Storage Volumes
#

# Check Modules and Commands.
Get-Module -Name PureStorage*
Get-Command -Module PureStoragePowerShellSDK2
(Get-Command -Module PureStoragePowerShellSDK2).Count
 
# Connect to FlashArray.
$FA1 = Connect-Pfa2Array -Endpoint 10.21.219.50 -Credential (Get-Credential) -IgnoreCertificateError

# Get FlashArray information.
Get-Pfa2Array -Array $FA1 | Select-Object Name, Os, Version, EradicationConfig

# Retrieve volumes.
Get-Pfa2Volume -Array $FA1 | Select-Object Name | Format-Table -Autosize
Write-Host "# of Volumes:"(Get-Pfa2Volume -Array $FA1).Count

# Create new volumes.
Measure-Command {
    For ($demovol=1; $demovol -le 100 ; $demovol++) { 
        New-Pfa2Volume -Array $FA1 -Name "WebinarDemoVolX_$($demovol)" -Provisioned 1GB
    }
}

# Retrieve new volumes.
Get-Pfa2Volume -Array $FA1 | Select-Object Name, Provisioned