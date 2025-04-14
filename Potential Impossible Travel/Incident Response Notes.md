### Incident Response Notes

#### Detection and Analysis

An account was flagged for potential impossible travel:
- **User Account:** 438a279e99fee6cfe703039e2d222257721e2f137acd040cc9e6cedae10075e5@lognpacific.com
- **User ID:** 9c8795b4-825c-4577-aa5e-1852b23aae97 
- **Instances of Potential Impossible Travel:** 3

![Image](https://i.imgur.com/Mi4HLc2.png) ![Image](https://i.imgur.com/lk5mxae.png)

To inspect detailed login information for the account, the following query was used:

```kusto
let TargetUserPrincipalName = "438a279e99fee6cfe703039e2d222257721e2f137acd040cc9e6cedae10075e5@lognpacific.com";
let TimePeriodThreshold = timespan(7d);
SigninLogs
| where TimeGenerated > ago(TimePeriodThreshold)
| where UserPrincipalName == TargetUserPrincipalName
| project TimeGenerated, UserPrincipalName, City = tostring(parse_json(LocationDetails).city), State = tostring(parse_json(LocationDetails).state), Country = tostring(parse_json(LocationDetails).countryOrRegion)
| order by TimeGenerated desc
```

![Image](https://i.imgur.com/yhy2BR1.png)

The account showed a sign-in from Las Vegas, NV on April 14, 2025, at 8:33 PM UTC, followed by another sign-in from Boydton, VA, at 9:53 PM UTC on the same day. This login pattern is suspicious, as it would require approximately a 35-hour drive between the two locations.

### Containment, Eradication, and Recovery
The account was immediately disabled in Entra ID (Azure Active Directory), and the user was contacted for investigation. It was determined that the alert was a false positive; the user had signed into their account via an Azure virtual machine. The datacenter for the virtual machine is located in East US-Virginia, specifically Boydton, VA, which corresponds with the sign-in from Boydton. The user's account was re-enabled, and they were advised to sign in from their desktop machine instead of a virtual machine to avoid being flagged for impossible travel in the future.

### Post-Incident Activities
Users were advised against signing in from virtual machines, as this could trigger alerts for potential impossible travel. Additionally, the option of implementing geofencing was explored to prevent logins from outside the workplace location.
