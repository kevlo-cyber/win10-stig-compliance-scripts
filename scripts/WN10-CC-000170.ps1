<#
.SYNOPSIS
    This PowerShell script ensures that Microsoft accounts are optional for modern apps on Windows 10 systems.

.NOTES
    Author          : Kevin Lopez
    LinkedIn        : https://www.linkedin.com/in/kevlo-cyber/
    GitHub          : https://github.com/kevlo-cyber
    Date Created    : 06/15/2025
    Last Modified   : 06/15/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000170

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example syntax:
    PS C:\> .\scripts\WN10-CC-000170.ps1
    This will make Microsoft accounts optional for modern apps on the system.
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

# Make Microsoft accounts optional for modern apps
Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "MSAOptional" -Type "DWord" -Value "1"

# Create log file
try {
    New-Item -ItemType Directory -Path "C:\Temp" -Force -ErrorAction SilentlyContinue | Out-Null
    "STIG Registry Compliance Applied - WN10-CC-000170: Make Microsoft Accounts Optional for Modern Apps: $(Get-Date)" | Out-File -FilePath "C:\Temp\STIG_WN10-CC-000170_$(Get-Date -Format 'yyyyMMdd_HHmmss').log" -ErrorAction SilentlyContinue
} catch { }

exit 0
