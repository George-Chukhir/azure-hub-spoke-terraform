resource "azurerm_virtual_network" "vnet" {
    count = length(var.prefixes)
    name = "${var.prefixes[count.index]}-network"
    resource_group_name = element(azurerm_resource_group.rg.*.name, count.index) # old style: tf 0.11 
    address_space = [element(var.address_spaces, count.index)]
    location = var.location


    tags = local.final_tags[var.prefixes[count.index]]
}

resource "azurerm_virtual_network_peering" "peering" {
    count = length(var.prefixes)
    name = "peering-to-${element(azurerm_resource_group.rg.*.name, 1 - count.index)}"
    resource_group_name = azurerm_resource_group.rg[count.index].name
    virtual_network_name = azurerm_virtual_network.vnet[count.index].name
    remote_virtual_network_id = (azurerm_virtual_network.vnet[1 - count.index].id)
    
    
    allow_virtual_network_access = true # vnet -> remote vnet 
    allow_forwarded_traffic = true # remote vnet -> vnet

}


resource "azurerm_subnet" "subnet" {
    count = length(var.prefixes)
    
    name = "${var.prefixes[count.index]}-subnet"
    resource_group_name = azurerm_resource_group.rg[count.index].name
    virtual_network_name = azurerm_virtual_network.vnet[count.index].name
    address_prefixes = [ 
        cidrsubnet(
            azurerm_virtual_network.vnet[count.index].address_space[0], 
            13, # add 13 bits to the mask 
            0 # first ip of subnet
        )
    ]
}