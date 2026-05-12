// Create public IP for load balancer 
resource "azurerm_public_ip" "vm_public_ip" {
    count = length(var.prefixes)

    name = "${var.prefixes[count.index]}-vm-pip"

    location = azurerm_resource_group.rg[count.index].location
    resource_group_name = azurerm_resource_group.rg[count.index].name

    sku = "Standard" // Microsoft resricts Basic SKU 
    allocation_method = "Static" // required for Standard SKU 
    
}

resource "azurerm_network_interface" "nic" {
    count = length(var.prefixes)


    name = "${var.prefixes[count.index]}-nic"
    location = azurerm_public_ip.vm_public_ip[count.index].location
    resource_group_name = azurerm_resource_group.rg[count.index].name

    ip_configuration{
        name = "${var.prefixes[count.index]}-ipconfig"
        subnet_id = azurerm_subnet.subnet[count.index].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.vm_public_ip[count.index].id
    }

    tags = local.final_tags[var.prefixes[count.index]]
}




resource "azurerm_linux_virtual_machine" "vm"{
    count = length(var.prefixes)


    name = "${var.prefixes[count.index]}-vm"
    location = azurerm_network_interface.nic[count.index].location
    resource_group_name = azurerm_resource_group.rg[count.index].name
    network_interface_ids = [azurerm_network_interface.nic[count.index].id]
    size = var.vm_size[0]
    admin_username = var.admin_username

    admin_ssh_key {
        username = var.admin_username
        public_key = data.azurerm_key_vault_secret.ssh_rsa_public_key.value
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "ubuntu-24_04-lts-daily"
        sku = "server-gen1"
        version = "latest" // compromise

    }

    os_disk {
        caching = "ReadWrite" // operetion with cache storage (disk caching)
        storage_account_type = "Standard_LRS"
    }

    tags = local.final_tags[var.prefixes[count.index]]

}
