# Windows 11 Debloat Script with Logging
# Removes pre-installed apps and disables telemetry

# DISCLAIMER: Use this script at your own risk. This script was inspired by the Win11Debloat project on GitHub (https://github.com/Raphire/Win11Debloat) and has been modified for my personal use. Ensure you understand the changes before executing this script on your system.

Write-Host "WARNING: This script makes significant changes to Windows, including removing built-in apps, disabling telemetry, and modifying system settings. Some changes may impact functionality."
Write-Host "\nPotential impacts:"
Write-Host "- Removing MicrosoftWindows.Client.WebExperience may cause taskbar or start menu issues."
Write-Host "- Disabling OneDrive will prevent automatic file syncing to the cloud."
Write-Host "- Disabling telemetry may interfere with Microsoft's diagnostic tools."
Write-Host "- Removing Clipchamp removes the default video editor."
Write-Host "\nIf you need to restore anything later, refer to these fixes:"
Write-Host "- Restore Widgets: reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\Widgets /v EnableWidgets /f"
Write-Host "- Re-enable OneDrive: winget install Microsoft.OneDrive"
Write-Host "- Re-enable telemetry: Set-Service -Name DiagTrack -StartupType Automatic; Start-Service DiagTrack"

$Confirmation = Read-Host "\nAre you sure you want to continue? Type 'yes' to proceed"
If ($Confirmation -ne "yes") {
    Write-Host "Exiting script. No changes were made."
    Exit
}

# Log file location
$LogFile = "C:\DebloatLog.txt"

# Function to log messages
Function Log-Message {
    Param (
        [string]$Message
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -Append -FilePath $LogFile
    Write-Host "$Timestamp - $Message"
}

# Create log file
New-Item -ItemType File -Path $LogFile -Force | Out-Null
Log-Message "Starting Windows 11 Debloat Script."

# List of pre-installed apps to remove
$BloatwareApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MixedReality.Portal",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.Whiteboard",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.BingWeather",
    "Microsoft.Copilot",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.GamingApp",
    "Microsoft.Windows.DevHome",
    "Microsoft.Services.Store.Engagement",
    "Clipchamp.Clipchamp",
    "MicrosoftWindows.Client.WebExperience",
    "Microsoft.WidgetsPlatformRuntime",
    "Microsoft.OneDrive"
)

# Uninstall bloatware apps
ForEach ($App in $BloatwareApps) {
    $CheckApp = Get-AppxPackage -AllUsers -Name $App
    If (-Not $CheckApp) {
        Log-Message "$App is already removed. Skipping."
        Continue
    }
    
    Log-Message "Removing $App..."
    
    # Attempt removal for current users
    Get-AppxPackage -AllUsers -Name $App | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    
    # Attempt removal from provisioned packages
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "*$App*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Log-Message "Finished removing bloatware apps."

# Disable OneDrive
Log-Message "Disabling OneDrive..."
Start-Process -NoNewWindow -FilePath "$env:SystemRoot\System32\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
Log-Message "OneDrive disabled."

# Script finished
Log-Message "Windows 11 Debloat completed successfully."
