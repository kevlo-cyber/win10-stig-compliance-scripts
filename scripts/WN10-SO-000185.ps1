<#
.SYNOPSIS
    This PowerShell script ensures that PKU2U Authentication is prevented on Windows 10 systems.

.NOTES
    Author          : Kevin Lopez
    LinkedIn        : https://www.linkedin.com/in/kevlo-cyber/
    GitHub          : https://github.com/kevlo-cyber
    Date Created    : 06/15/2025
    Last Modified   : 06/15/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000185

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example syntax:
    PS C:\> .\scripts\WN10-SO-000185.ps1
    This will prevent PKU2U authentication on the system.
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

# Prevent PKU2U authentication
Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\pku2u" -Name "AllowOnlineID" -Type "DWord" -Value "0"

# Create log file
try {
    New-Item -ItemType Directory -Path "C:\Temp" -Force -ErrorAction SilentlyContinue | Out-Null
    "STIG Registry Compliance Applied - WN10-SO-000185: Prevent PKU2U Authentication: $(Get-Date)" | Out-File -FilePath "C:\Temp\STIG_WN10-SO-000185_$(Get-Date -Format 'yyyyMMdd_HHmmss').log" -ErrorAction SilentlyContinue
} catch { }

exit 0
