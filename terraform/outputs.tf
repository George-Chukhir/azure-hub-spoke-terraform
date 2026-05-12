output "current_ip"{
    value = chomp(data.http.my_public_ip.response_body)
}

output "vm_public_ips"{
    description = "Public IP addresses of the provisioned VMs"
    value = azurerm_public_ip.vm_public_ip[*].ip_address
}