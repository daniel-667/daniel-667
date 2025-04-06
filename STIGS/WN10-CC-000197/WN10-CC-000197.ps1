<#
.SYNOPSIS
    This PowerShell script automatically remediates the issue by disabling Microsoft consumer experiences through the registry.

.NOTES
    Author          : Daniel Avila
    LinkedIn        : linkedin.com/in/avdaniel/
    GitHub          : github.com/daniel-667
    Date Created    : 2025-04-06
    Last Modified   : 2025-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-00197

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 
 
#>

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$valueName = "DisableWindowsConsumerFeatures"

# Check if the registry path exists, if not, create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the registry value to disable Microsoft consumer experiences
Set-ItemProperty -Path $registryPath -Name $valueName -Value 1 -Type DWord

# Confirm that the setting has been applied
$settingValue = Get-ItemProperty -Path $registryPath -Name $valueName
if ($settingValue.DisableWindowsConsumerFeatures -eq 1) {
    Write-Host "Successfully disabled Microsoft consumer experiences." -ForegroundColor Green
} else {
    Write-Host "Failed to disable Microsoft consumer experiences." -ForegroundColor Red
}


