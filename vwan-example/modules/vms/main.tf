locals {
  vmName = substr("vm-${var.location}", 0, 15)
  nicName = "nic-${local.vmName}"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "pip-${local.nicName}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = local.nicName
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "vm" {
  name                  = local.vmName
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS2_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk-${local.vmName}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = local.vmName
    admin_username = var.adminUsername
    admin_password = var.adminPassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = var.tags
}