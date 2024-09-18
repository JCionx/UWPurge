Add-Type -AssemblyName PresentationCore,PresentationFramework

cd $env:UserProfile


# Install winget dependencies

Write-Host -ForegroundColor Cyan "[#] Downloading Microsoft UI XAML package"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile msuixaml.msixbundle

Write-Host -ForegroundColor Cyan "[#] Installing Microsoft UI XAML package..."
Add-AppxPackage -Path ".\msuixaml.msixbundle"

Write-Host -ForegroundColor Cyan "[#] Removing Microsoft UI XAML package..."
Remove-Item ".\msuixaml.msixbundle"

# Enable winget

Write-Host -ForegroundColor Cyan "[#] Downloading WinGet package"
Invoke-WebRequest https://aka.ms/getwinget -OutFile winget.msixbundle

Write-Host -ForegroundColor Cyan "[#] Installing WinGet package..."
Add-AppxPackage -Path ".\winget.msixbundle"

Write-Host -ForegroundColor Cyan "[#] Removing WinGet package..."
Remove-Item ".\winget.msixbundle"


# Debloat
Write-Host -ForegroundColor Cyan "[#] Cloning Win11Debloat repository..."
Invoke-WebRequest https://github.com/Raphire/Win11Debloat/archive/refs/heads/master.zip -OutFile win11debloat.zip

Write-Host -ForegroundColor Cyan "[#] Decompressing Win11Debloat repository archive..."
Expand-Archive -Path win11debloat.zip

Write-Host -ForegroundColor Cyan "[#] Removing Win11Debloat repository archive..."
Remove-Item ".\win11debloat.zip"

cd ".\win11debloat\Win11Debloat-master"

Write-Host -ForegroundColor Cyan "[#] Downloading CustomAppsList file..."
Invoke-WebRequest https://raw.githubusercontent.com/JCionx/UWPurge/master/assets/CustomAppsList -OutFile CustomAppsList

Write-Host -ForegroundColor Cyan "[#] Running Win11Debloat script..."
Set-ExecutionPolicy Bypass -Scope Process -Force
.\Win11Debloat.ps1 -HideGallery -DisableRecall -DisableCopilot -DisableWidgets -HideChat -HideTaskview -HideSearchTb -TaskbarAlignLeft -ShowKnownFileExt -DisableSuggestions -DisableBing -DisableTelemetry -ClearStartAllUsers -DisableDVR -RemoveGamingApps -RemoveDevApps -RemoveW11Outlook -RemoveCommApps -RemoveAppsCustom -ForceRemoveEdge -Silent
Write-Host -ForegroundColor Cyan "[#] Removing UWP notepad..."
Get-AppxPackage *Microsoft.WindowsNotepad* | Remove-AppxPackage
cd ../../

Write-Host -ForegroundColor Cyan "[#] Removing Win11Debloat repository..."
Remove-Item .\win11debloat -Recurse


# Install apps

Write-Host -ForegroundColor Cyan "[#] Installing 7-Zip..."
winget install 7zip

Write-Host -ForegroundColor Cyan "[#] Installing VLC..."
winget install VideoLAN.VLC

Write-Host -ForegroundColor Cyan "[#] Installing ExplorerPatcher..."
winget install valinet.ExplorerPatcher

Write-Host -ForegroundColor Cyan "[#] Installing OpenShell..."
winget install --id "Open-Shell.Open-Shell-Menu" --source winget --silent --custom 'ADDLOCAL=StartMenu'


# Setup ExplorerPatcher config

cd $env:UserProfile/Desktop

Write-Host -ForegroundColor Cyan "[#] Downloading ExplorerPatcher config file..."
Invoke-WebRequest https://raw.githubusercontent.com/JCionx/UWPurge/master/assets/ExplorerPatcherConfig.reg -OutFile ExplorerPatcherConfig.reg

Write-Host ""
Write-Host -ForegroundColor Red "[!] Load the ExplorerPatcher config!"
Write-Host -ForegroundColor Red "1. Right click on the taskbar"
Write-Host -ForegroundColor Red "2. Click on Properties"
Write-Host -ForegroundColor Red "3. Click on Settings and uninstall"
Write-Host -ForegroundColor Red "4. Click on Import Settings"
Write-Host -ForegroundColor Red "5. Navigate to your desktop and choose the ExplorerPatcherConfig.reg file"
pause

Write-Host -ForegroundColor Cyan "[#] Removing ExplorerPatcher config file..."
Remove-Item .\ExplorerPatcherConfig.reg

Write-Host -ForegroundColor Cyan "[#] Restarting explorer..."
taskkill /F /IM explorer.exe
Start explorer.exe

Write-Host ""
Write-Host -ForegroundColor Cyan "Script complete!"

pause
