param virtualNetworkName string = 'vm-arana2-vnet'
param virtualMachineName string = 'arana2-vm'
param OSVersion string = '2019-Datacenter'
param adminUsername string = 'arana2admin'
param location string = 'Canada Central'
param bastionHostName string = 'ba-bastion'
param VMsubnet string = 'VMsubnet'
param publicIpName string = 'ba-bastion-pip'
param subnetbastion string = 'AzureBastionSubnet'
param vmCount int = 1
param addressPrefixes string = '10.30.0.0/16'
param Prefix string = '10.30.10.0/24'
param bastionprefix string = '10.30.40.0/24'

//Request user to enter an admin password
@description('Admin password for VM')
@minLength(12)
@secure()
param adminPassword string

/*
Require user to provide admin password instead of storing in Secrets
resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {     
  name: 'bicepkvlab'
  scope: resourceGroup(subscription().subscriptionId, 'bicepvmdeploy' )
}
*/

// Virtual network resource
resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: virtualNetworkName
  //scope relies on the resource group name
  scope: resourceGroup(subscription().subscriptionId, 'Bicep_deploy_arana2')
}
  output id string = virtualNetworkName_resource.id

module VNet './Modules/vNET.bicep' = {
  name: 'vnetDeploy'
  params: {
    virtualNetworkName: virtualNetworkName
    bastionsubnetName: subnetbastion
    location: location
    addressPrefixes: addressPrefixes
    Prefix: Prefix
    VMsubnet: VMsubnet
    bastionPrefix: bastionprefix
  }
}

module bastion './Modules/bastion.bicep' = {
  name: 'bastionDeploy'
  params: {
    location: location
    publicIPBastionName: publicIpName
    bastionHostName: bastionHostName
    subnetBastion: subnetbastion
    virtualNetworkName: virtualNetworkName
  }
}

module virtualmachine './Modules/vm.bicep' = [for i in range(1, vmCount): {
  name: 'vm-${i}'
  params: {
    virtualMachineName: virtualMachineName
    OSVersion: OSVersion
    adminUsername: adminUsername
    adminpassword: adminPassword
    location: location
    VMsubnet: VMsubnet
    vnetId: virtualNetworkName_resource.id
  }
}]
