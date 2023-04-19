# Variables
$Creds=(Get-Credential)
$ArrayEndPoint1 = "10.10.10.10"
$ArrayEndpoint2 = "10.10.10.11"

# Authentication examples
# OAuth2
$ArrayClientname = "demodev1"
$ArrayIssuer = $ArrayClientname
$ArrayPassword = ConvertTo-SecureString "pureuser" -AsPlainText -Force
$ArrayUsername = "pureuser"
$MaxRole = "array_admin"
$privateKeyPass = ConvertTo-SecureString "R00tr00t#" -AsPlainText -Force
# Show created tokens
Write-Host "ClientID: $($clientId)"
Write-Host "KeyID $($KeyId)"
Write-Host "PrivateKey $($privateKeyFile)"
# Create the authentication object
$fa = New-Pfa2ArrayAuth -MaxRole $MaxRole -Endpoint $ArrayEndpoint1 -APIClientName $ArrayClientname -Issuer $ArrayIssuer -Credential $Creds
# Set the new variables
$clientId = $fa.PureClientApiClientInfo.clientId
$keyId = $fa.PureClientApiClientInfo.KeyId
$privateKeyFile = $fa.pureCertInfo.privateKeyFile
# Make the connection
$arrayoauth = Connect-Pfa2Array -Endpoint $ArrayEndpoint1 -Username $ArrayUsername -Issuer $ArrayIssuer -ClientId $clientId -KeyId $keyId -PrivateKeyFile $privateKeyFile -PrivateKeyPassword $privateKeyPass -IgnoreCertificateError -ApiClientName $ArrayClientname

# Test authentication
Get-Pfa2Array -Array $arrayoauth -Verbose

## OAUTH2 Function to be referenced by multiple scripts
function ArrayAuth () {
    $global:fa = New-Pfa2ArrayAuth -MaxRole $MaxRole -Endpoint $ArrayEndpoint1 -APIClientName $ArrayClientname -Issuer $ArrayIssuer -Username $ArrayUsername -Password $ArrayPassword
    $global:clientId = $fa.PureClientApiClientInfo.clientId
    Write-Host "ClientID: $($clientId)"
    Write-Host " "
    $global:keyId = $fa.PureClientApiClientInfo.KeyId
    Write-Host "KeyID $($KeyId)"
    Write-Host " "
    $global:privateKeyFile = $fa.pureCertInfo.privateKeyFile
    Write-Host "PrivateKey $($privateKeyFile)"
}
ArrayAuth
$arrayoauth = Connect-Pfa2Array -Endpoint $ArrayEndpoint2 -Username $ArrayUsername -Issuer $ArrayIssuer -ClientId $clientId -KeyId $keyId -PrivateKeyFile $privateKeyFile -PrivateKeyPassword $privateKeyPass -IgnoreCertificateError -ApiClientName $ArrayClientname


# User/Pass token authentication
$arraytoken = Connect-Pfa2Array -Endpoint $ArrayEndpoint2 -Credential $Creds -IgnoreCertificateError
Get-Pfa2Array -Array $arraytoken -Verbose

# Host and Volume creation
Get-Pfa2Host -Array $arrayoauth | Select-Object Name
Get-Pfa2Volume -Array $arrayoauth
$iqn = @("iqn.1998-01.com.sample1.iscsi", "iqn.1998-01.com.sample2.iscsi")
New-Pfa2Host -Array $arrayoauth -Host "demohost" -iqns $iqn
New-Pfa2Volume -Array $arrayoauth -Volume "demovolume" -Provisioned 10737418240
New-Pfa2Connection -Array $arrayoauth -HostNames "demohost" -VolumeNames "demovolume"
Get-Pfa2Connection -Array $arrayoauth -Hostnames "demohost"

# PowerShell Toolkit 3.x
Get-Pfa2StaleSnapshots -Endpoint 10.21.185.110 -Credential $Creds -SnapAgeThreshold 900
Get-Pfa2StaleSnapshots -Endpoint 10.21.185.110 -Credential $Creds -SnapAgeThreshold 900 -Delete -Confirm:$false
Get-Pfa2ConnectDetails -Endpoint 10.21.185.110 -Credential $Creds
# Create array Excel report
New-Pfa2ExcelReport -Endpoint 10.21.185.110 -Credential $Creds -OutPath ".\..\output"
