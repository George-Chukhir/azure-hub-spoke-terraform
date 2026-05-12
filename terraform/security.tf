data "http" "my_public_ip" {
    url = "https://ipv4.icanhazip.com"
}

resource "azurerm_network_security_group" "nsg"{
    name = "${var.prefixes[1]}-nsg"
    location = var.location
    resource_group_name = azurerm_resource_group.rg[1].name

    security_rule {
        name = "Allow-SSH"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "${chomp(data.http.my_public_ip.response_body)}/32"
        destination_address_prefix = "*"
    }    

    tags = local.final_tags["prod"]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}