<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Daniel Avila
    LinkedIn        : linkedin.com/in/avdaniel/
    GitHub          : github.com/daniel-667
    Date Created    : 2025-03-19
    Last Modified   : 2025-03-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000095

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 
 
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regName = "SCRemoveOption"
$regValue = "1" # Use "1" for Lock Workstation, "2" for Force Logoff

# Create the registry key if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type String

# Confirm the change
$setValue = Get-ItemProperty -Path $regPath -Name $regName
if ($setValue.$regName -eq $regValue) {
    if ($regValue -eq "1") {
        Write-Host "Smart Card removal is now set to 'Lock Workstation'." -ForegroundColor Green
    } elseif ($regValue -eq "2") {
        Write-Host "Smart Card removal is now set to 'Force Logoff'." -ForegroundColor Green
    }
} else {
    Write-Host "Failed to configure Smart Card removal option." -ForegroundColor Red
}
