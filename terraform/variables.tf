variable "prefixes" {
    type = list(string)
    default = ["hub", "prod"]
    description = "List of prefixes for resource naming"
}

variable "location" {
  type        = string
  default     =  "Poland Central" 
  description = "Azure region for resource deployment"
}

variable "address_spaces" {
    default = [
        "10.0.0.0/16", 
        "10.1.0.0/16"
    ]
}

variable "vm_size" {
    default = [
                "Standard_B2as_v2",
                "Standard_B2als_v2", 
                "Standard_B2ats_v2", 
                "Standard_A1_v2",]
}

variable "key_vault_name"{
    type = string
    default = "chukhir-main-kv"
}

variable "key_vault_rg"{
    type = string
    default = "global-infra-rg"
}

variable "ssh_pub_key_secret_name"{
    type = string
    default = "sshPublicKey"
}


variable "admin_username" {
    type = string
    default = "adminuser"
    description = "The admin username for the VMs."
}