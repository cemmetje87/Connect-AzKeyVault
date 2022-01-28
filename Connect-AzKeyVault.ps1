requires -version 7
<#
.SYNOPSIS
  Module script
.DESCRIPTION
    This script can be used as a module to connect to MS Azure Key Vault and return a secret value as SecureString.
    Then this value can be used in credential variables.

    ATTENTION - Make sure you have your permissions set up correctly in Azure. You'll need a App Registration giving the proper access to Azure Key Vault.
.PARAMETER VaultName
    Required - Specifiy a VaultName in Azure KeyVault
.PARAMETER SecretName
    Required - Specifiy a SecretName in the vault
.INPUTS
    None
.OUTPUTS
    Return SecureString Value
.NOTES
    Version:        1.0
    Author:         Cem Ozugur
    Creation Date:  1/28/2022
    Purpose/Change: Initial script
  
.EXAMPLE
    Connect-AzKeyVault -VaultName "myvault" -SecretName "mysecret"
#>
#Checking for MSAL.PS Module - install if missing
if (Get-InstalledModule | where-object name -eq MSAL.PS){
    Import-Module MSAL.PS
} else {
    Install-PackageProvider Nuget -ErrorAction Ignore
    Install-Module PowerShellGet -AllowClobber –Force
    Install-Module MSAL.PS -AllowClobber -Force -Confirm:$False
    Import-Module MSAL.PS -Force
}

function Connect-AzKeyVault {
    param (
        [Parameter(Mandatory=$true)]    
        [string]$VaultName,
        [Parameter(Mandatory=$true)]
        [string]$SecretName
    )
    # TenantID required
    $TenantId = 'xxxxxxxxxxxxxxxxxxxxxxxxx'
    # ClientID required
    $ClientId = 'xxxxxxxxxxxxxxxxxxxxxxxxx'
    $Scope = "https://vault.azure.net/.default"

    #Use either a cert or a secret to generate an access token
    $CertPath = $null   #"cert:\\LocalMachine\\My\\*************************", Create one if necessary using New-SelfSignedCertificate, Google is your best friend...
    $ClientSecret = $null # Can be created under the App Registration in Azure under secrificates and secrets
    $ClientCert = Get-ChildItem $CertPath
    $APIVersion = "7.1"
    if ($CertPath) {
        $MsalGetToken = Get-MsalToken -ClientId $ClientId -ClientCertificate $ClientCert -TenantId $TenantId -Scope $Scope
    } 
    else {
        $MsalGetToken = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -ClientSecret $ClientSecret -Scope $Scope
    }
    $KeyVaultSecret = convertto-securestring ((Invoke-RestMethod -Headers @{Authorization = "Bearer $($MsalGetToken.AccessToken)" } `
    -Uri "https://$VaultName.vault.azure.net/secrets/$($SecretName)?api-version=$APIVersion" `
    -Method Get).value) -asplaintext -force

    return $KeyVaultSecret
}

