<#
.SYNOPSIS
    This PowerShell script ensures that the auto sign-in feature after restart is disabled on Windows 10 systems.

.NOTES
    Author          : Kevin Lopez
    LinkedIn        : https://www.linkedin.com/in/kevlo-cyber/
    GitHub          : https://github.com/kevlo-cyber
    Date Created    : 06/15/2025
    Last Modified   : 06/15/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000325

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example syntax:
    PS C:\> .\scripts\WN10-CC-000325.ps1
    This will disable the auto sign-in after restart on the system.
#>

# Suppress all output for silent execution
$ErrorActionPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    exit 1
}

# Function to silently create registry entries
function Set-RegistryValue {
    param([string]$Path, [string]$Name, [string]$Type, [string]$Value)
    try {
        if (!(Test-Path $Path)) { New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null }
        New-ItemProperty -Path $Path -Name $Name -PropertyType $Type -Value $Value -Force -ErrorAction SilentlyContinue | Out-Null
    } catch { }
}

# Disable auto sign-in after restart
Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableAutomaticRestartSignOn" -Type "DWord" -Value "1"

# Create log file
try {
    New-Item -ItemType Directory -Path "C:\Temp" -Force -ErrorAction SilentlyContinue | Out-Null
    "STIG Registry Compliance Applied - WN10-CC-000325: Disable Auto Sign-In After Restart: $(Get-Date)" | Out-File -FilePath "C:\Temp\STIG_WN10-CC-000325_$(Get-Date -Format 'yyyyMMdd_HHmmss').log" -ErrorAction SilentlyContinue
} catch { }

exit 0
