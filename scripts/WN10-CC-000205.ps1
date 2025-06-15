<#
.SYNOPSIS
    This PowerShell script ensures that Windows Telemetry is set to minimal on Windows 10 systems.

.NOTES
    Author          : Kevin Lopez
    LinkedIn        : https://www.linkedin.com/in/kevlo-cyber/
    GitHub          : https://github.com/kevlo-cyber
    Date Created    : 06/15/2025
    Last Modified   : 06/15/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000205

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example syntax:
    PS C:\> .\scripts\WN10-CC-000205.ps1
    This will set Windows Telemetry to minimal on the system.
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

# Set Windows Telemetry to minimal
Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type "DWord" -Value "0"

# Create log file
try {
    New-Item -ItemType Directory -Path "C:\Temp" -Force -ErrorAction SilentlyContinue | Out-Null
    "STIG Registry Compliance Applied - WN10-CC-000205: Set Windows Telemetry to Minimal: $(Get-Date)" | Out-File -FilePath "C:\Temp\STIG_WN10-CC-000205_$(Get-Date -Format 'yyyyMMdd_HHmmss').log" -ErrorAction SilentlyContinue
} catch { }

exit 0
