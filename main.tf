resource "azurerm_resource_group" "this" {
  location = var.location
  name     = "${var.name}-Group"
}


#creating a virtual network in Azure 
resource "azurerm_virtual_network" "VN" {
  name                = var.name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

#creating subnets
resource "azurerm_subnet" "public-subnet" {
  name                 = "${var.name}-public-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.VN.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}
resource "azurerm_subnet" "private" {
  name                 = "${var.name}-private-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.VN.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 10)]

}

#create public IP
resource "azurerm_public_ip" "public-IP" {
  name                = "${var.name}-Public-IP"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1]
}
#Nat Gateway
resource "azurerm_nat_gateway" "natgateway" {
  name                    = "${var.name}-NAT"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1]
}
#NAT public ip association
resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.natgateway.id
  public_ip_address_id = azurerm_public_ip.public-IP.id
}
resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.natgateway.id
}
