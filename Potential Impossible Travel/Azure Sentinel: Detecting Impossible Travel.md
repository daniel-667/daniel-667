**Azure Sentinel: Detecting Potential Impossible Travel**

In order to detect potential instances of impossible travel in Azure, a scheduled query rule is created within Microsoft Sentinel to monitor user login patterns for unusual behavior across geographic locations. The primary goal is to flag cases where a user logs in from more than one geographic region within a 7-day window, indicating potentially compromised credentials or other suspicious activity.

### Key Points:
- **Data Source:** The query uses the "SigninLogs" table from Azure, which records all user login events.
- **Timeframe & Thresholds:**
  - The query is designed to check logins within the past 7 days.
  - The system flags a user if they log in from more than 2 distinct locations during this period.

### KQL Query
```
// Investigate Potential Impossible Travel Instances
let TargetUserPrincipalName = "EXAMPLE"; // Change to your target user (UserPrincipalName)
let TimePeriodThreshold = timespan(7d); // Change to how far back you want to look
SigninLogs
| where TimeGenerated > ago(TimePeriodThreshold)
| where UserPrincipalName == TargetUserPrincipalName
| project TimeGenerated, UserPrincipalName, City = tostring(parse_json(LocationDetails).city), State = tostring(parse_json(LocationDetails).state), Country = tostring(parse_json(LocationDetails).countryOrRegion)
| order by TimeGenerated desc
```
  
### Query Logic:
1. **Query Breakdown:**
   - The query filters for logins in the last 7 days.
   - It counts how many distinct locations (City, State, Country) a user logs in from.
   - If a user logs in from more than 2 distinct locations within 7 days, it’s flagged as potential impossible travel.
   
2. **Alert Rule Configuration:**
   - **Name & Description:** The rule is given a clear and descriptive title (e.g., "Potential Impossible Travel Detection").
   - **Mitre ATT&CK Framework:** The relevant tactics like "Initial Access" --> "Valid Accounts" --> "Cloud Accounts" are mapped.
   - **Execution:** The query runs every 4 hours, checking the last 24 hours of data.
   - **Incident Handling:** If triggered, an incident is automatically created. All alerts within a 24-hour period are grouped into one incident for streamlined investigation.

### Outcome:
This scheduled rule and its associated alert logic provide a proactive approach to detecting potentially suspicious login behavior in Azure environments, helping security teams investigate anomalies before they escalate.
