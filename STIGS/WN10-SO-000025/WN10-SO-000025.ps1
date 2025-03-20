
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
    STIG-ID         : WN10-SO-000025

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 
 
#>

# Define the new name for the guest account
$newGuestName = "DisabledGuest"

# Get the guest account object
$guestAccount = Get-WmiObject -Class Win32_UserAccount -Filter "SID LIKE 'S-1-5-%-501'"

if ($guestAccount) {
    # Rename the guest account
    Rename-LocalUser -Name $guestAccount.Name -NewName $newGuestName
    
    # Confirm the change
    $renamedAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$newGuestName'"
    
    if ($renamedAccount) {
        Write-Host "Guest account renamed to '$newGuestName' successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to rename the guest account." -ForegroundColor Red
    }
} else {
    Write-Host "No guest account found on this machine." -ForegroundColor Yellow
}
