# Azure Infrastructure: Hub & Spoke Foundation [INFRA-402]

## Project Overview
This repository contains Terraform code for deploying a baseline Azure network architecture based on the **Hub & Spoke** pattern. This setup ensures network isolation, centralized management, and secure access to cloud resources.

## Ticket Information
- **Ticket ID:** `[INFRA-402]`
- **Assignee:** Heorhii
- **Epic:** Azure Advanced Networking Foundation
- **Story Points:** 5
- **Tools:** Terraform, Azure CLI

## Architecture Context
In preparation for service migration to Azure, we established a core network backbone. 
- **Hub VNet:** Acts as the central point for shared services (connectivity, security).
- **Prod VNet (Spoke):** Isolated environment for production workloads.
- **Security:** Access is strictly controlled via Network Security Groups (NSG) and bidirectional peering.

## Implemented Features

### 1. Network Layer
- **VNet Hub:** Address space planned to avoid overlaps.
- **VNet Prod:** Subnetting configured for compute workloads.
- **VNet Peering:** Established bidirectional peering between Hub and Prod to allow internal communication.

### 2. Compute Layer
- **Virtual Machine:** Deployed a `Standard_B1s` instance running **Ubuntu LTS** in the Prod network.
- **Authentication:** Hardened security using **SSH Key-based authentication** (passwords disabled).

### 3. Security Layer
- **NSG (Network Security Group):** Applied to the VM/Subnet.
- **Inbound Rules:** Strictly limited to **Port 22 (SSH)** only from the administrator's **current public IP address**. All other inbound traffic is denied by default.

## Project Structure
```text
├── provider.tf      # AzureRM provider configuration (Managed Identity ready)
├── variables.tf     # Network CIDR blocks, location, and IP whitelist
├── network.tf       # Hub & Spoke VNets and Peering resources
├── security.tf      # NSG rules and associations
├── compute.tf       # VM, NIC, and Public IP definitions
└── outputs.tf       # VM IP and connection details
```

## How to Deploy
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Apply Configuration:**
   ```bash
   terraform apply -var="my_public_ip=$(curl -s ifconfig.me)"
   ```

## Definition of Done (Validation)
- [x] Bidirectional peering status is `Connected`.
- [x] SSH access is successful from the whitelisted IP.
- [x] SSH connection fails (Timeout) when attempting to connect from a different network/IP.

## Verification 
<img width="722" height="329" alt="image" src="https://github.com/user-attachments/assets/5d942e83-b002-49a9-a525-3fd142777907" />
<img width="792" height="201" alt="image" src="https://github.com/user-attachments/assets/e203277e-d330-410d-9220-b6c935c263f4" />

