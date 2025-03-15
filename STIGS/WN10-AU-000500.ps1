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

<h2>Manual Configuration</h2>

<p>1. <b>Tenable Scan</b>: Initially, I ran a Tenable scan using the <b>Windows Compliance Checks</b> plugin on a target VM, identifying 137 failed items. Among them, the <b>WN10-AU-000500</b> was flagged.</p>

<p align="center">
  Initial Scan Result: <br/>
  <img src="https://example.com/scan-result.png" height="80%" width="80%" alt="Initial Scan Result"/>
</p>

<p>2. <b>Manual Fix</b>: 
   - I identified that the <b>Application Event Log</b> maximum size was not configured correctly. According to the STIG, this value should be <b>32768 KB</b> or greater.
   - After researching on <b>stigaview.com</b>, I implemented the fix manually:
     <ol>
       <li>Opened the <b>Registry Editor</b>.</li>
       <li>Navigated to <code>HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows</code>.</li>
       <li>Created the missing <b>EventLog</b> key, and then the <b>Application</b> subkey.</li>
       <li>Created a <b>DWORD</b> value named <code>MaxSize</code> and set it to <b>32768</b> (decimal).</li>
       <li>Restarted the VM and performed a follow-up Tenable scan to confirm that the STIG was now passed.</li>
     </ol>
</p>

<p align="center">
  Registry Editor - Manual Fix: <br/>
  <img src="images/registry-editor-manual-fix.png" height="80%" width="80%" alt="Registry Editor - Manual Fix"/>
</p>
