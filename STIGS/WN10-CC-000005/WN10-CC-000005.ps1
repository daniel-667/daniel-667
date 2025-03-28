<#
.SYNOPSIS
    This PowerShell script is designed to disable camera access from the Windows lock screen by modifying the system's registry.

.NOTES
    Author          : Daniel Avila
    LinkedIn        : linkedin.com/in/avdaniel/
    GitHub          : github.com/daniel-667
    Date Created    : 2025-03-14
    Last Modified   : 2025-03-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 


#>

# PowerShell script to disable camera access from the lock screen

# Registry path and value details
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$registryValueName = "NoLockScreenCamera"
$desiredValue = 1

# Check if the registry path exists
if (-Not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating registry path..."
    # Create the registry path if it does not exist
    New-Item -Path $registryPath -Force
}

# Check if the registry value exists and its value
$existingValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

if ($existingValue -eq $null) {
    Write-Host "Registry value does not exist. Creating registry value..."
    # Create the registry value with the desired value
    New-ItemProperty -Path $registryPath -Name $registryValueName -Value $desiredValue -PropertyType DWord -Force
} else {
    Write-Host "Registry value exists. Checking value..."
    # Check if the value is already set to the desired value
    if ($existingValue.$registryValueName -ne $desiredValue) {
        Write-Host "Registry value is not set to $desiredValue. Updating registry value..."
        # Set the registry value to the desired value
        Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $desiredValue
    } else {
        Write-Host "Registry value is already set to $desiredValue. No changes needed."
    }
}
