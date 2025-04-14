# Detecting Malicious PowerShell Activity: Implementing Alerts for Invoke-WebRequest in Microsoft Sentinel


When a bad actor gains access to a system, they often attempt to download harmful software or tools from the internet to gain more control or remain undetected. They frequently use standard system tools like PowerShell to disguise their actions as normal behavior. By executing commands such as `Invoke-WebRequest`, they can download files or scripts from another server and run them immediately, thereby evading detection by security systems. This tactic is commonly employed after they have already compromised a system, enabling them to install malware, steal data, or communicate with a remote server. It is crucial to identify this behavior to prevent an ongoing attack.

When actions are performed on the local virtual machine (VM), logs are sent to Microsoft Defender for Endpoint, specifically in the `DeviceProcessEvents` table. These logs are then forwarded to the Log Analytics Workspace utilized by Microsoft Sentinel, our security information and event management (SIEM) system. In Sentinel, I will set up an alert to notify us whenever PowerShell is used to download a file from the internet.

To achieve this, I used Azure Log Analytics to design a KQL query that detects when PowerShell is using `Invoke-WebRequest` to download content. The `Invoke-WebRequest` command in PowerShell allows users to send HTTP requests to web servers, facilitating interaction with websites and web services by fetching data or sending information.

Here is the Sentinel Scheduled Query Rule I created:

```kql
let TargetDevice = "cddar-test";
DeviceProcessEvents
| where DeviceName == TargetDevice 
| where FileName == "powershell.exe"
| where InitiatingProcessCommandLine contains "Invoke-WebRequest" 
    or ProcessCommandLine contains "Invoke-WebRequest"
```

This KQL query retrieves events from the `DeviceProcessEvents` table for the specific device (`cddar-test`) where PowerShell was used, specifically looking for instances where the `Invoke-WebRequest` command appeared in either the initiating command line or the process command line.

After finalizing the query, I created the Scheduled Query Rule in Microsoft Sentinel under Analytics, using the following MITRE ATT&CK categories: 

- Application Layer Protocol: Web Protocols
- Command and Scripting Interpreter: PowerShell
- Ingress Tool Transfer
- Exploitation for Client Execution
- Exfiltration Over Command and Control Channel

I named the Scheduled Query Rule "CDDAR-PowerShell Sus Web Request." The query is configured to run every four hours and to look up data from the last 24 hours. I also set up Entity Mapping to include the Account, Host, and Process. An incident will be automatically generated if the rule is triggered.

![Image](https://i.imgur.com/m40c7XH.png)
