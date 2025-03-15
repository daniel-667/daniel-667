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
    STIG-ID         : WN10-AU-0000052

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

#>

# PowerShell script to configure Windows to prioritize ECC Curves with longer key lengths (NistP384 before NistP256)

# Registry path and value details
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
$registryValueName = "EccCurves"
$desiredValue = @("NistP384", "NistP256")

# Check if the registry path exists
if (-Not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating registry path..."
    # Create the registry path if it does not exist
    New-Item -Path $registryPath -Force
}

# Check if the registry value exists
$existingValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

if ($existingValue -eq $null) {
    Write-Host "Registry value does not exist. Creating registry value..."
    # Create the registry value with the desired values (MULTI_SZ)
    New-ItemProperty -Path $registryPath -Name $registryValueName -Value $desiredValue -PropertyType MultiString -Force
} else {
    Write-Host "Registry value exists. Checking value..."
    # Check if the value is already configured as desired
    if ($existingValue.$registryValueName -ne $desiredValue) {
        Write-Host "Registry value is not set to the desired ECC curve order. Updating registry value..."
        # Set the registry value to the desired value
        Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $desiredValue
    } else {
        Write-Host "Registry value is already configured correctly. No changes needed."
    }
}

Write-Host "ECC Curve Order configuration is now set to prioritize NistP384 before NistP256."
