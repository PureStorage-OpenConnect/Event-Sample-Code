#
# Pure Storage FlashArray SafeMode.
#

# Connect to FlashArray.
$FA2 = Connect-Pfa2Array -Endpoint 10.1.1.1 -Credential (Get-Credential) -IgnoreCertificateError

# Create new volumes.
Measure-Command {
    For ($demovol=75; $demovol -le 85 ; $demovol++) { 
        New-Pfa2Volume -Array $FA2 -Name "WebinarDemoVol_$($demovol)" -Provisioned 1GB
    }
}

# Create new volume snapshots
Measure-Command {
    For ($demovol=75; $demovol -le 85 ; $demovol++) { 
        New-Pfa2VolumeSnapshot -Array $FA2 -SourceNames "WebinarDemoVol_1"
    }
}

# Retrieve WebinarDemoVol_1 snapshots
Get-Pfa2VolumeSnapshot -Array $FA2 -SourceNames "WebinarDemoVol_1" | `
    Select-Object Name, Destroyed, Suffix

# Destroy snapshots
For ($demovol=75; $demovol -le 85 ; $demovol++) { 
    Remove-Pfa2VolumeSnapshot -Array $FA2 -Name "WebinarDemoVol_1.$($demovol)"
}

# >> Check FlashArray GUI

# Retrieve destroyed snapshots
Get-Pfa2VolumeSnapshot -Array $FA2 -Destroyed $true | `
    Select-Object Name, Created, Destroyed, TimeRemaining | Format-Table -AutoSize

# This operation will generate the following Error.
#    Remove-Pfa2Volume: Eradication is disabled. (), https://10.1.1.1/api/2.20/volumes?names=Test (DELETE)
#
# Eradicate snapshot .1
Remove-Pfa2VolumeSnapshot -Array $FA2 -Name "WebinarDemoVol_1.1" `
        -Eradicate -Confirm:$false

# Retrieve destroyed snapshots
Get-Pfa2VolumeSnapshot -Array $FA2 -Destroyed $true | `
    Select-Object Name, Created, Destroyed, TimeRemaining | Format-Table -AutoSize


 
