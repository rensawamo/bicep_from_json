param virtualMachines_ToyTruckServer_name string = 'ToyTruckServer'virtualNetwork
param networkInterfaces_toytruckserver918_name string = 'toytruckserver918'
param publicIPAddresses_ToyTruckServer_ip_name string = 'ToyTruckServer-ip'
param virtualNetworks_ToyTruckServer_vnet_name string = 'ToyTruckServer-vnet'
param networkSecurityGroups_ToyTruckServer_nsg_name string = 'ToyTruckServer-nsg'
param schedules_shutdown_computevm_toytruckserver_name string = 'shutdown-computevm-toytruckserver'

resource networkSecurityGroups_ToyTruckServer_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: networkSecurityGroups_ToyTruckServer_nsg_name
  location: 'eastus'
  properties: {
    securityRules: []
  }
}

resource publicIPAddresses_ToyTruckServer_ip_name_resource 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: publicIPAddresses_ToyTruckServer_ip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '13.92.2.65'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_ToyTruckServer_vnet_name_resource 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: virtualNetworks_ToyTruckServer_vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_ToyTruckServer_vnet_name_default.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_ToyTruckServer_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_ToyTruckServer_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_ToyTruckServer_name}_OsDisk_1_94463ef204864ebd9ab29f75e9d9aea8'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_ToyTruckServer_name}_OsDisk_1_94463ef204864ebd9ab29f75e9d9aea8'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_ToyTruckServer_name
      adminUsername: 'toytruckadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
            bypassPlatformSafetyChecksOnUserSchedule: false
          }
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_toytruckserver918_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    priority: 'Spot'
    evictionPolicy: 'Delete'
    billingProfile: {
      maxPrice: -1
    }
  }
}

resource schedules_shutdown_computevm_toytruckserver_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_toytruckserver_name
  location: 'eastus'
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '0000'
    }
    timeZoneId: 'Tokyo Standard Time'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
      notificationLocale: 'ja'
    }
    targetResourceId: virtualMachines_ToyTruckServer_name_resource.id
  }
}

resource virtualNetworks_ToyTruckServer_vnet_name_default 'Microsoft.Network/virtualNetworks/subnets@2023-06-01' = {
  name: '${virtualNetworks_ToyTruckServer_vnet_name}/default'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [virtualNetworks_ToyTruckServer_vnet_name_resource]
}

resource networkInterfaces_toytruckserver918_name_resource 'Microsoft.Network/networkInterfaces@2023-06-01' = {
  name: networkInterfaces_toytruckserver918_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_toytruckserver918_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"31ddc4b6-a77d-4d55-9c94-7b187d2b81c5"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_ToyTruckServer_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_ToyTruckServer_vnet_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_ToyTruckServer_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
