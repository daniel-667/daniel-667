<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Daniel Avila
    LinkedIn        : linkedin.com/in/avdaniel/
    GitHub          : github.com/daniel-667
    Date Created    : 2025-03-13
    Last Modified   : 2024-03-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 
 
#>

# Define the registry path and the value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$valueData = 32768  # 0x00008000 in hexadecimal

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    # Create the registry path if it does not exist
    New-Item -Path $registryPath -Force
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Confirm the change
$setValue = Get-ItemProperty -Path $registryPath -Name $valueName
Write-Host "Successfully set $valueName to $($setValue.$valueName) at $registryPath"



