//Declare parameters
@description('Name of the virtual machine:')
param virtualMachineName string

@description('The virtual machine size.')
param virtualMachineSize string = 'Standard_B2s'

@description('The OS version for the VM')
param OSVersion string

@description('Name of the virtual machine subnet')
param VMsubnet string

@description('The admin username of the VM')
param adminUsername string

@description('Location for all VM resources.')
param location string = resourceGroup().location

@description('Name of the Network Security Group')
param networkSecurityGroupName string = '${virtualMachineName}-nsg'

@description('Admin password for VM')
@secure()
param adminpassword string

@description('The vNet ID')
param vnetId string

// Declare variables for VM
var networkSecurityGroupRules = []
var publicIpAddressName = '${virtualMachineName}-publicIP'
var publicIpAddressType = 'Dynamic'
var publicIpAddressSku = 'Basic'
var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var subnetRef = '${vnetId}/subnets/${VMsubnet}'
var networkInterfaceName = '${virtualMachineName}-nic'

// Public IP Resource
resource publicIpAddressName_resource 'Microsoft.Network/publicIpAddresses@2023-11-01' = {
  name: publicIpAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
}

// NSG resource
resource networkSecurityGroup_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

//NIC resource
resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    /* ipConfigurations:[
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
            properties: {
            }
          }
        }
      }
    ] */
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
            properties: {
            }
          }
        }
      }
    ]

    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    //these resources must be deployed before the NIC can be created
    networkSecurityGroup_resource
    publicIpAddressName_resource
  ]
}

//VM Resource
resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceName_resource.id
          properties: {
          }
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminpassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
  }
}
