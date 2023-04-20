#
# Pure Storage Volume Snapshots and Immutability.
#

# Connect to FlashArray
$FA1 = Connect-Pfa2Array -Endpoint 10.1.1.1 -Credential (Get-Credential) -IgnoreCertificateError

# Create new volume snapshots.
Measure-Command {
    For ($demovol=1; $demovol -le 50 ; $demovol++) { 
        New-Pfa2VolumeSnapshot -Array $FA1 -SourceNames "WebinarDemoVol_1"
    }
}

# Retrieve WebinarDemoVol_1 snapshots.
Get-Pfa2VolumeSnapshot -Array $FA1 -SourceNames "WebinarDemoVol_1" | `
    Select-Object Name, Destroyed, Suffix

# Fully destroying snapshots is a 2-step operation -Destroy then -Eradicate.
# Destroy snapshots.
For ($demovol=35; $demovol -le 48 ; $demovol++) { 
    Remove-Pfa2VolumeSnapshot -Array $FA1 -Name "WebinarDemoVol_1.$($demovol)"
}

# Retrieve destroyed snapshots.
Get-Pfa2VolumeSnapshot -Array $FA1 -Destroyed $true | `
    Select-Object Name, Created, Destroyed, TimeRemaining | Format-Table -AutoSize

# Eradicate snapshots.
For ($demovol=35; $demovol -le 48 ; $demovol++) { 
    Remove-Pfa2VolumeSnapshot -Array $FA1 -Name "WebinarDemoVol_1.$($demovol)" `
        -Eradicate -Confirm:$false
}

# Retrieve destroyed snapshots. There are none.
Get-Pfa2VolumeSnapshot -Array $FA1 -Destroyed $true | `
    Select-Object Name, Created, Destroyed, TimeRemaining | Format-Table -AutoSize

 
