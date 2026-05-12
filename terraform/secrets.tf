# ref to existing key vault
data "azurerm_key_vault" "existing-kv" {
    name = var.key_vault_name
    resource_group_name = var.key_vault_rg
}

#ref to existing secret (rsa_pub key)in key vault
data "azurerm_key_vault_secret" "ssh_rsa_public_key" {
    name = var.ssh_pub_key_secret_name
    key_vault_id = data.azurerm_key_vault.existing-kv.id
}


