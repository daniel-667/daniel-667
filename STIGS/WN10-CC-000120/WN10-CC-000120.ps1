<#
.SYNOPSIS
The script ensures that the system is configured to use stronger encryption algorithms by prioritizing ECC curves with larger key lengths, 
aligning with security best practices.
.NOTES
    Author          : Daniel Avila
    LinkedIn        : linkedin.com/in/avdaniel/
    GitHub          : github.com/daniel-667
    Date Created    : 2025-03-14
    Last Modified   : 2025-03-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000120

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regName = "DontDisplayNetworkSelectionUI"
$regValue = 1

# Create the registry key if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

# Confirm the change
$setValue = Get-ItemProperty -Path $regPath -Name $regName
if ($setValue.$regName -eq $regValue) {
    Write-Host "Network selection UI is now disabled on the logon screen." -ForegroundColor Green
} else {
    Write-Host "Failed to disable network selection UI." -ForegroundColor Red
}
