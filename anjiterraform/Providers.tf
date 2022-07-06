terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "anjiresource_4" {
    name= "anjiresource_4"
    location = "East us"
}
resource "azurerm_virtual_network" "anjivnet_4" {
  name                = "anjivnet_4"
  location            = "east us"
  resource_group_name = "anjiresource_4"
  address_space       = ["15.0.0.0/16"]
  }

resource "azurerm_subnet" "anjisubnet_4" {
  name                 = "anjisubnet_4"
  resource_group_name  = "anjiresource_4"
  virtual_network_name = "anjivnet_4"
  address_prefixes     = ["15.0.1.0/24"]
}
resource "azurerm_network_interface" "anjiinterface_4" {
  name                = "anjiinterface_4"
  location            = "east us"
  resource_group_name = "anjiresource_4"

  ip_configuration {
    name                          = "anjiipconfig_4"
    subnet_id                     = azurerm_subnet.anjisubnet_4.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "anjivm_4" {
  name                  = "anjivm_4"
  location              = "east us"
  resource_group_name   = "anjiresource_4"
  network_interface_ids = [azurerm_network_interface.anjiinterface_4.id]
  vm_size               = "Standard_DS1_v2"
   storage_image_reference {
    publisher = "Microsoftwindowsserver"
    offer     = "windowsserver"
    sku       = "2016-datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "anjiosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  tags = {
    environment = "anjiVM_4"
  }
}