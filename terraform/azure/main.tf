resource "azurerm_resource_group" "p20" {
  name     = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "p20" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.p20.location
  resource_group_name = azurerm_resource_group.p20.name
}

resource "azurerm_subnet" "p20" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.p20.name
  virtual_network_name = azurerm_virtual_network.p20.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "p20" {
  name                = "${var.project_name}-pip"
  location            = azurerm_resource_group.p20.location
  resource_group_name = azurerm_resource_group.p20.name
  allocation_method   = "Static"
  sku                = "Standard"
}

resource "azurerm_network_interface" "p20" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.p20.location
  resource_group_name = azurerm_resource_group.p20.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.p20.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.p20.id
  }
}

resource "azurerm_network_security_group" "p20" {
  name                = "${var.project_name}-nsg"
  location            = azurerm_resource_group.p20.location
  resource_group_name = azurerm_resource_group.p20.name
  
  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "p20" {
  network_interface_id      = azurerm_network_interface.p20.id
  network_security_group_id = azurerm_network_security_group.p20.id
}

resource "azurerm_linux_virtual_machine" "p20" {
  name                = "${var.project_name}-azure"
  resource_group_name = azurerm_resource_group.p20.name
  location            = azurerm_resource_group.p20.location
  size                = var.vm_size
  
  admin_username = "azureuser"
  disable_password_authentication = true
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/../keys/p20-key.pub")
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  
  network_interface_ids = [azurerm_network_interface.p20.id]
  
  identity {
    type = "SystemAssigned"
  }
}