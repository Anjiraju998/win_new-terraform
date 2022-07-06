provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "anjiRG9" {
  name     = "anjiRG9"
  location = "east us"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "anji-vnet1"
  address_space       = ["14.0.0.0/16"]
  location            = azurerm_resource_group.anjiRG9.location
  resource_group_name = azurerm_resource_group.anjiRG9.name
}

resource "azurerm_subnet" "snet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.anjiRG9.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["14.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "anji-nic"
  location            = azurerm_resource_group.anjiRG9.location
  resource_group_name = azurerm_resource_group.anjiRG9.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "anjivm1"
  resource_group_name = azurerm_resource_group.anjiRG9.name
  location            = azurerm_resource_group.anjiRG9.location
  size                = "Standard_F2"
  admin_username      = "raju"
  admin_password      = "Raju@2022"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}