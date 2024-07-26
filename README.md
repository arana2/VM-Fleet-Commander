# VM-Fleet-Commander
The project demonstrates how to implement an infrastructure-as-code approach to provision and manage virtual machines in Azure, using Bicep. The hopes of this project is to provide hands-on experience in automating the deployment of Azure resources and organizing them efficiently.

Bicep is the perfect solution when we need to provision multiple Azure Resources and manage the infrastructure with reusable templates and eliminate repetitive manual tasks altogether.

# Solution Diagram
<img width="700" alt="image" src="https://github.com/user-attachments/assets/d910c4a1-01c5-4b40-8bfa-2ae93a5f2fb2">

# File Description
Main.bicep
Main deployment file.
Contains parameters to deploy the Azure resources.

# Modules
A module is a Bicep file (or an Azure Resource Manager JSON template) that is deployed from another Bicep file.

Bastion.bicep
<br>A managed service provided by Microsoft Azure that allows you to securely and seamlessly connect to your virtual machines (VMs) within a virtual network (VNet). It provides secure and seamless RDP (Remote Desktop Protocol) and SSH (Secure Shell) connectivity to your VMs directly through the Azure portal over SSL (port 443).
Contains parameters to deploy the Bastion resource.

vNET.bicep
<br>Contains parameters to deploy the Azure Virtual Network which includes the virtual network name, resource location, Subnet, and Bastion.

vm.bicep
<br>Contains parameters to deploy the Azure Virtual Machine resources.
<br>This file contains the bulk of the resources, as each VM deployed requires a NIC, a dynamic private IP address from the VM subnet, access to a public IP address for Bastion, an OS image, and storage.

# Deploying the Solution
Helpful Tips:
-	I recommend developing in Visual Studio Code. From my experience, it is lightweight, rich feature set, and support for various extensions.
-	As for extensions, I used:
  <br>o	Bicep – validates the code syntax and provide helpful suggestions.
  <br>o	Powershell - write and debug PowerShell scripts within Visual Studio Code.
  <br>o	Azure Resource Manager (ARM) Tools - The Azure Resource Manager (ARM) Tools for Visual Studio Code provides language support, resource snippets, and resource auto-completion to help you create and validate Azure Resource Manager templates.
-	GitHub is a great resource for backing up the Bicep files and version control. What’s great is Visual Studio Code has GitHub integrated into the software for easily backing up your code and accessing the repository anywhere.

Steps:
1.	Clone the repository to your local disk.

2.	Open Visual Studio Code and navigate to the project folder.

3.	Open a terminal and ensure it’s set to PowerShell
  <br>a.	In the command prompt, type pwsh and press Enter.

4.	Create an Azure Resource Group. This will be used to store the Azure resources.
```
New-AzResourceGroup -Name Bicep_deploy_arana2 -Location canadacentral
```

5.	Create variables and assign string values. These variables will be used to create unique deployment names.
```
$date = Get-Date -Format "MM-dd-yyyy"
$deploymentName = "arana2_Bicep_Deployment"+"$date"
```

6.	Deploy the Bicep solution:
```
New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName Bicep_deploy_arana2 `
-TemplateFile .\main.bicep `
-adminUsername "arana2admin" -c
```
# Conclusion:
This was a challenging and fulfilling project that involved deploying multiple Azure resources using the Infrastructure as Code (IaC) methodology. By utilizing modular BICEP templates, PowerShell, and GitHub, I successfully automated my environments.

In terms of real-world applications, this solution can rapidly deploy environments for testing and development needs. Compared to an on-premises solution, the IaC approach offers several benefits:

<br>•	Scalability: Easily scale resources up or down based on demand, automating the provisioning of new instances.
<br>•	Cost Efficiency: Pay-as-you-go pricing models allow you to pay only for what you use, reducing wasted resources.
<br>•	Consistency and Repeatability: Use version-controlled scripts to ensure consistent and repeatable infrastructure setups across environments.
<br>•	Security: Leverage cloud providers' security features and best practices to ensure robust security measures.

Considering these advantages, IaC provides a more flexible, efficient, and scalable approach compared to traditional on-premises solutions.

# Resources Used
I found Microsoft Learn to be an excellent resource for learning new concepts.
-	https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/
-	https://learn.microsoft.com/en-us/training/modules/arm-template-specs/

Here’s an article that helped me understand how to create multiple VM instances.
-	https://blog.azinsider.net/deploy-multiple-resources-by-using-loops-in-azure-bicep-language-6aa4d60a4c2f
