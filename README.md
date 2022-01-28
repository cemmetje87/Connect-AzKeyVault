# Connect-AzKeyVault
## SYNOPSIS
Module script
## DESCRIPTION
This script can be used as a module to connect to MS Azure Key Vault and return a secret value as SecureString.
Then this value can be used in credential variables.

ATTENTION - Make sure you have your permissions set up correctly in Azure. You'll need a App Registration giving the proper access to Azure Key Vault.
### PARAMETER VaultName
    Required - Specifiy a VaultName in Azure KeyVault
### PARAMETER SecretName
    Required - Specifiy a SecretName in the vault
## INPUTS
    None
## OUTPUTS
    Return SecureString Value
## NOTES
    Version:        1.0
    Author:         Cem Ozugur
    Creation Date:  1/28/2022
    Purpose/Change: Initial script
  
## EXAMPLE
    Connect-AzKeyVault -VaultName "myvault" -SecretName "mysecret"
