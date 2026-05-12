terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 3.0"
      }
    }

    // account storage 
    backend "azurerm" {
        resource_group_name  = "terraform_state-rg"
        storage_account_name = "tfstatechukhir"
        container_name       = "my-lab-storage-container"
        key                  = "terraform.tfstate" // name of the file in cloud storage 
    }
}

provider "azurerm" {
    features{}  
}


locals {
    common_tags = {
        project = "Hub-Spoke-Network"
        owner   = "Stringer"
        managed_by = "Terraform"
    }

    env_settings = {
        hub = {
            env_tag = "Hub"
            billing = "Hub-Cost_Center"
        }
        prod = {
            env_tag = "Prod"
            billing = "Prod-Cost-Center"
        }
    }

    final_tags = {
        for key, settings in local.env_settings :
            key => merge(local.common_tags,  {
                environment = settings.env_tag
                billing = settings.billing
        })
    }
}

resource "azurerm_resource_group" "rg" {
    count = length(var.prefixes)
    name = "rg-${var.prefixes[count.index]}"
    location = var.location


    tags = local.final_tags[var.prefixes[count.index]]
}



# "listOfAllowedLocations": {
        # "value": [
        #   "italynorth",
        #   "uaenorth",
        #   "germanywestcentral",
        #   "spaincentral",
        #   "polandcentral"
    #     # ]

    #   }
