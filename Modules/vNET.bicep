//Declare parameters
@description('Address Prefix for virtual network')
param Prefix string

@description('Address Prefixes for virtual network')
param addressPrefixes string 

@description('Bastion Prefix')
param bastionPrefix string

@description('Virtual network name')
param virtualNetworkName string

@description('Location based on location of the Resource Group')
param location string = resourceGroup().location

@description('Subnet Prefix for VM')
param VMsubnet string

@description('Subnet Prefix for Bastion')
param bastionsubnetName string

// vNet resource with subnets
resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
    subnets: [
      {
        name: VMsubnet
        properties: {
          addressPrefix: Prefix
        }
      }
      {
        name: bastionsubnetName
        properties: {
          addressPrefix: bastionPrefix
        }
      }
    ]
  }
}
