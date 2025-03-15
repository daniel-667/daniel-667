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

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
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

# Windows Security Configuration Automation - STIG Compliance

## Overview

This project demonstrates how I implemented a fix for the STIG ID **WN10-AU-000500**, which mandates that the **Application Event Log's maximum size** be set to **32768 KB** or greater. 

### Manual Configuration

1. **Tenable Scan**: Initially, I ran a Tenable scan using the **Windows Compliance Checks** plugin on a target VM, identifying 137 failed items. Among them, the **WN10-AU-000500** was flagged.

   <p align="center">
Initial Scan Result: <br/>
<img src="https://imgur.com/a/gUadrf4" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
2. **Manual Fix**: 
   - I identified that the **Application Event Log** maximum size was not configured correctly. According to the STIG, this value should be **32768 KB** or greater.
   - After researching on **stigaview.com**, I implemented the fix manually:
     1. Opened the **Registry Editor**.
     2. Navigated to `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows`.
     3. Created the missing **EventLog** key, and then the **Application** subkey.
     4. Created a **DWORD** value named `MaxSize` and set it to `32768` (decimal).
     5. Restarted the VM and performed a follow-up Tenable scan to confirm that the STIG was now passed.

   ![Registry Editor - Manual Fix](images/registry-editor-manual-fix.png)

### Automation with PowerShell

After manually fixing the issue, I explored automating the process using PowerShell to replicate the registry changes.

1. **PowerShell Script**: Using ChatGPT, I generated a PowerShell script to automate the registry modifications.
2. **Testing the Script**:
   - I ran the PowerShell script in **PowerShell**.
   - I performed a scan, and it confirmed that the STIG passed successfully.

   ![PowerShell Script Output](images/powershell-script-output.png)

### Validation

To validate the fix:
1. I removed the registry modification and rescanned, which resulted in the STIG failing.
2. I then reapplied the PowerShell script, and the STIG passed again, confirming that the automated solution worked as intended.

### Conclusion

This project blends **manual configuration** with a **scalable, script-based solution**, ensuring that the system adheres to security best practices while being efficient and automatable.
