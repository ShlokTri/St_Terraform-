resource "azurerm_resource_group" "RG" {
  name     = "Shlok_Terrform"
  location = "West Europe"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = "ade434f1-c60f-4e07-ad39-e711388e902a"
  client_secret   = "ar68Q~I_bzsqEgRGJOcRpykRToG51z_U3VaX~chn"
  tenant_id       = "d54a5c48-6802-46d8-bf80-f556250ad7cf"
  subscription_id = "6cd39a43-8d67-4203-8fed-25185bcbf080"
}



# Virtual Network Creation
resource "azurerm_virtual_network" "vnet" {
 name                = "shlok-network"
 address_space       = ["10.0.0.0/16"]
 location            = azurerm_resource_group.RG.location
 resource_group_name = azurerm_resource_group.RG.name
 
}
resource "azurerm_subnet" "subnet" {
 name                 = "vm-subnet"
 resource_group_name  = azurerm_resource_group.RG.name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
 name                         = "shlok-nic"
 location                     = azurerm_resource_group.RG.location
 resource_group_name          = azurerm_resource_group.RG.name
 ip_configuration {
  name ="internal" 
  subnet_id= azurerm_subnet.subnet.id
  private_ip_address_allocation ="Dynamic" 
            
 }



}resource "azurerm_windows_virtual_machine" "vm"{
name                         = "shlok-vm"
 resource_group_name          = azurerm_resource_group.RG.name
 location = azurerm_resource_group.RG.location
size="Standard_F2"
admin_username = "adminuser"
admin_password = "Password@123"
network_interface_ids = [azurerm_network_interface.nic.id,]

os_disk {
  caching="ReadWrite"
  storage_account_type="Standard_LRS"
}
source_image_reference {
  publisher="MicrosoftWindowsServer"
  offer="WindowsServer"
  sku="2016-Datacenter"
  version="latest"
}
}





