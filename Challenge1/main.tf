 terraform {
   required_version = ">=0.12"
   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
 }

 provider "azurerm" {
   features {}
 }

 resource "azurerm_resource_group" "RG22012023" {
   name     = "${var.rg_name}"
   location = "${var.location}"
 }


 resource "azurerm_virtual_network" "vn" {
  name                = "${var.vm_name}-network"
  address_space       = ["10.0.0.0/28"]
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.RG22012023.name
  depends_on = [
    azurerm_resource_group.RG22012023
  ]
}

resource "azurerm_subnet" "vmsub" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.RG22012023.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.0.0/29"]
  depends_on = [
    azurerm_virtual_network.vn
  ]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.RG22012023.name

  ip_configuration {
    name                          = "vmipconfig"
    subnet_id                     = azurerm_subnet.vmsub.id
    private_ip_address_allocation = "Dynamic"
  }
    depends_on = [
    azurerm_virtual_network.vn,
    azurerm_subnet.vmsub
  ]
}

resource "azurerm_virtual_machine" "main" {
  name                  	 		= "${var.vm_name}"
  location							= "${var.location}"
  resource_group_name				= azurerm_resource_group.RG22012023.name
  network_interface_ids				= [azurerm_network_interface.main.id]
  vm_size               			= "Standard_B1ls"
  delete_os_disk_on_termination 	= true
  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher 						= "Canonical"
    offer    						= "UbuntuServer"
    sku       						= "18_04-lts-gen2"
    version   						= "latest"
  }
  storage_os_disk {
    name              				= "myosdisk1"
    caching           				= "ReadWrite"
    create_option     				= "FromImage"
    managed_disk_type 				= "StandardSSD_LRS"
  }
  os_profile {
    computer_name  					= "hostname"
    admin_username 					= "kpmguser"
    admin_password 					= "${var.password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
  depends_on = [
    azurerm_virtual_network.vn,
    azurerm_subnet.vmsub,
    azurerm_network_interface.main
  ]
}