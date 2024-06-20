## 📖 README.md

```markdown
# 🌐 Azure Infrastructure Setup

Welcome to the Azure Infrastructure Setup repository! This repository contains Terraform configurations to create and manage an Azure environment with a resource group, virtual network, subnets, public IP, NAT gateway, and necessary associations.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Usage](#usage)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

## 🚀 Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

# Quick start
Step 1: Create terraform.tfvars file
Create a file named terraform.tfvars and add the following content:

```hcl
name = "resource-group-name"
```
Step 2: Apply the Terraform Configuration
Run the following command to apply your Terraform configuration using the variables defined in terraform.tfvars:

```sh
terraform apply -var-file="terraform.tfvars"
```

## 🛠 Configuration

### Resource Group

Creates an Azure resource group.

```hcl
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = "${var.name}-Group"
}

provider "azurerm" {
  features {}
}
```

### Virtual Network

Creates a virtual network in Azure.

```hcl
resource "azurerm_virtual_network" "VN" {
  name                = var.name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
```

### Subnets

Creates public and private subnets.

```hcl
resource "azurerm_subnet" "public-subnet" {
  name                 = "${var.name}-public-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.VN.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}

resource "azurerm_subnet" "private-subnet" {
  name                 = "${var.name}-private-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.VN.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 10)]
}
```

### Public IP

Creates a static public IP address.

```hcl
resource "azurerm_public_ip" "public-IP" {
  name                = "${var.name}-Public-IP"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1]
}
```

### NAT Gateway

Creates a NAT gateway.

```hcl
resource "azurerm_nat_gateway" "natgateway" {
  name                    = "${var.name}-NAT"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1]
}
```

### Associations

Associates the NAT gateway with the public IP and private subnet.

```hcl
resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.natgateway.id
  public_ip_address_id = azurerm_public_ip.public-IP.id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id       = azurerm_subnet.private-subnet.id
  nat_gateway_id  = azurerm_nat_gateway.natgateway.id
}
```

## 📦 Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/azure-infrastructure-setup.git
   cd azure-infrastructure-setup
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## 📚 Resources

For more details, check the [Terraform documentation](https://www.terraform.io/docs/providers/azurerm/index.html).

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```
