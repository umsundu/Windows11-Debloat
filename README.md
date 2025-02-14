# Windows11-Debloat

## DISCLAIMER: Use this script at your own risk. This script was inspired by the Win11Debloat project on GitHub (https://github.com/Raphire/Win11Debloat) and has been modified for my personal use. Ensure you understand the changes before executing this script on your system.

This PowerShell script is designed to remove pre-installed bloatware, disable telemetry, and optimize system settings on Windows 11. It was inspired by the Win11Debloat project and has been customized for personal use.
Features:

* ✔ Removes unnecessary apps (e.g., Bing News, Xbox, Copilot, Your Phone)
* ✔ Disables OneDrive to prevent automatic file syncing
* ✔ Turns off Windows telemetry & tracking services
* ✔ Disables widgets and news feeds to declutter the UI
* ✔ Includes logging to track all changes

**Usage:**
Run the script as an Administrator in PowerShell:
```
Set-ExecutionPolicy Bypass -Scope Process -Force
.\Win11-Debloat.ps1
```
 ⚠ **Warning:** Use at your own risk! This script makes system-level changes, so ensure you review the code before running it.
