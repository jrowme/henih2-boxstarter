# Description: Boxstarter script for henih2 workstation
# Author: henih2

$creds = Get-Credential

Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
  Param ([string]$script)
  write-host "executing $script ..."
  Invoke-Expression "scripts\$script"
}

#--- Setting up Windows ---
executeScript "Browsers.ps1";
executeScript "CommonDevTools.ps1";
executeScript "Communications.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "MediaTools.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "HyperV.ps1";
executeScript "ChefTools.ps1";
executeScript "Docker.ps1";
executeScript "PuppetTools.ps1";
executeScript "PowerShellModules.ps1";
executeScript "RsatTools.ps1";

#--- Update PowerShell Help ---#
Update-Help -Force

#--- ReEnable Critical Items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula