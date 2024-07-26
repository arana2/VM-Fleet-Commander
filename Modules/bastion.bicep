//Declare parameters
@description('The name of the Bastion public IP address')
param publicIPBastionName string = 'PublicIP-Bastion'

@description('The name of the Bastion host')
param bastionHostName string

@description('Bastion location')
param location string  = resourceGroup().location

@description('Bastion subnet name')
param subnetBastion string

@description('virtualNetwork name')
param virtualNetworkName string

//virtual network resource
resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
  //scope is based on resource group and subscription ID
  scope: resourceGroup(subscription().subscriptionId, resourceGroup().name)
}

output id string = virtualNetworkName_resource.id

//virtual subnet resource for Bastion
resource virtualsubnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: subnetBastion
  parent: virtualNetworkName_resource
}

//Get vSubnet ID and assign to var
var mySubnetId = virtualsubnet_resource.id

//Return subnetID and save as string
output mySubnetId string = mySubnetId

//Public IP address resource for Bastion
resource publicIpAddressForBastion_resource 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIPBastionName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  dependsOn: [
  ]
}

//Bastion resource
resource bastionHost 'Microsoft.Network/bastionHosts@2023-11-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: virtualsubnet_resource.id
          }
          publicIPAddress: {
            id: publicIpAddressForBastion_resource.id
          }
        }
      }
    ]
  }
  dependsOn: [
  ]
}
