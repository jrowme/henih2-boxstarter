# Description: Boxstarter script for henih2 workstation
# Author: henih2

Disable-UAC
Set-MpPreference -DisableRealtimeMonitoring $true

#--- Browsers ---
choco install -y googlechrome firefox

# --- Chef Tools ---
choco install -y chefdk

# --- Dev Tools ---
choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y python 7zip.install sysinternals f.lux bleachbit dropbox windirstat

# --- Communication Tools ---
choco install -y hipchat slack microsoft-teams signal gitter

# --- Docker Tools ---
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
choco install -y docker-for-windows

#--- Configuring Windows properties ---
#--- Windows Features ---
# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

# --- HashiCorp Tools ---
choco install -y packer vagrant

# --- HyperV ---
choco install Microsoft-Hyper-V-All --source="'WindowsFeatures'"

# --- Media Tools ---
choco install -y vlc spotify

# --- PowerShell Tools ---
choco install -y dotnetcore-sdk
choco install -y powershell-core
choco install -y colortool
(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/dracula/iterm/master/Dracula.itermcolors').Content | Out-File -FilePath 'C:\ProgramData\Chocolatey\lib\colortool\content\schemes\Dracula.itermcolors'

# --- PowerShell Modules ---
Install-Module psake -Force
Install-Module pester -Force -SkipPublisherCheck
Install-Module PSLogging -Force
Install-Module PackageManagement -Force
Install-Module PowerShellGet -Force
Install-Module PSWindowsUpdate -Force
Install-Module PendingReboot -Force
Install-Module PSScriptAnalyzer -Force
Install-Module Posh-Docker -Force

# --- Puppet Tools ---
choco install -y pdk puppet-bolt

# --- Remove Default Apps ---
#--- Uninstall unecessary applications that come with Windows out of the box ---
Write-Host "Uninstall some applications that come with Windows out of the box" -ForegroundColor "Yellow"

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
  Param ([string]$appName)
  Write-Output "Trying to remove $appName"
  Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
  Get-AppXProvisionedPackage -Online | Where DisplayNam -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
  "Microsoft.BingFinance"
  "Microsoft.3DBuilder"
  "Microsoft.BingFinance"
  "Microsoft.BingNews"
  "Microsoft.BingSports"
  "Microsoft.BingWeather"
  "Microsoft.CommsPhone"
  "Microsoft.Getstarted"
  "Microsoft.WindowsMaps"
  "*MarchofEmpires*"
  "Microsoft.GetHelp"
  "Microsoft.Messaging"
  "*Minecraft*"
  "Microsoft.MicrosoftOfficeHub"
  "Microsoft.OneConnect"
  "Microsoft.WindowsPhone"
  "Microsoft.WindowsSoundRecorder"
  "*Solitaire*"
  "Microsoft.MicrosoftStickyNotes"
  "Microsoft.Office.Sway"
  "Microsoft.XboxApp"
  "Microsoft.XboxIdentityProvider"
  "Microsoft.ZuneMusic"
  "Microsoft.ZuneVideo"
  "Microsoft.NetworkSpeedTest"
  "Microsoft.FreshPaint"
  "Microsoft.Print3D"
  "*Autodesk*"
  "*BubbleWitch*"
  "king.com*"
  "G5*"
  "*Dell*"
  "*Facebook*"
  "*Keeper*"
  "*Netflix*"
  "*Twitter*"
  "*Plex*"
  "*.Duolingo-LearnLanguagesforFree"
  "*.EclipseManager"
  "ActiproSoftwareLLC.562882FEEB491" # Code Writer
  "*.AdobePhotoshopExpress"
);

foreach ($app in $applicationList) {
  removeApp $app
}

# --- RSAT Tools ---
Get-WindowsCapability -Online -Name rsat* | Add-WindowsCapability -Online

# --- Windows Subsystem Linux ---
choco install Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"

#--- Ubuntu ---
# TODO: Move this to choco install once --root is included in that package
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx
# run the distro once and have it install locally with root user, unset password

RefreshEnv
Ubuntu1804 install --root
# Ubuntu1804 run apt update
# Ubuntu1804 run apt upgrade -y

<#
NOTE: Other distros can be scripted the same way for example:

#--- SLES ---
# Install SLES Store app
Invoke-WebRequest -Uri https://aka.ms/wsl-sles-12 -OutFile ~/SLES.appx -UseBasicParsing
Add-AppxPackage -Path ~/SLES.appx
# Launch SLES
sles-12.exe

# --- openSUSE ---
Invoke-WebRequest -Uri https://aka.ms/wsl-opensuse-42 -OutFile ~/openSUSE.appx -UseBasicParsing
Add-AppxPackage -Path ~/openSUSE.appx
# Launch openSUSE
opensuse-42.exe
#>

# --- Kali Linux ---
# Invoke-WebRequest -Uri https://www.microsoft.com/store/apps/9PKR34TNCV07 -OutFile ~/Kali-Linux.appx -UseBasicParsing
# Add-AppxPackage -Path ~/Kali-Linux.appx
# run the distro once and have it install locally with root user, unset password
# 
# kali install --root
# kali run apt update
# kali run apt upgrade -y