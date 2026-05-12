// Create public IP for load balancer 
resource "azurerm_public_ip" "vm_public_ip" {
    name = "${var.prefixes[1]}-vm-pip"

    location = azurerm_resource_group.rg[1].location
    resource_group_name = azurerm_resource_group.rg[1].name

    sku = "Standard" // Microsoft resricts Basic SKU 
    allocation_method = "Static" // required for Standard SKU 
    
}

resource "azurerm_network_interface" "nic" {
    name = "${var.prefixes[1]}-nic"
    location = var.location
    resource_group_name = azurerm_resource_group.rg[1].name

    ip_configuration{
        name = "${var.prefixes[1]}-ipconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.vm_public_ip.id
    }

    tags = local.final_tags["prod"]

}




resource "azurerm_linux_virtual_machine" "vm"{
    name = "${var.prefixes[1]}-vm"
    location = var.location
    resource_group_name = azurerm_resource_group.rg[1].name
    network_interface_ids = [azurerm_network_interface.nic.id]
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
        version = "24.04.202605080"

    }

    os_disk {
        caching = "ReadWrite" // operetion with cache storage (disk caching)
        storage_account_type = "Standard_LRS"
    }

    tags = local.final_tags["prod"]

}
