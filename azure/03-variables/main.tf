
resource "azurerm_resource_group" "rg" {
  name     = "${var.project}-${var.env}-rg"
  location = var.location[1]
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-${var.env}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-${var.env}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.project}-${var.env}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.project}-${var.env}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.project}-${var.env}-nic-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "velma_nsg" {
  name                = "${var.project}-${var.env}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
    name                = "${var.project}-${var.env}-nsg-rule-ssh"
    priority              = 100
    direction             = "Inbound"
    access                = "Allow"
    protocol              = "Tcp"
    source_port_range     = "*"
    destination_port_range = "22"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.velma_nsg.name
}

resource "azurerm_network_security_rule" "allow_web" {
    name                = "${var.project}-${var.env}-nsg-rule-http"
    priority              = 200
    direction             = "Inbound"
    access                = "Allow"
    protocol              = "Tcp"
    source_port_range     = "*"
    destination_port_ranges = [var.port_ranges[0], var.port_ranges[1]]
    source_address_prefix     = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.velma_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "velma_nsg_association" {
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.velma_nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.project}-${var.env}-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size[0]
  admin_username                  = "velma"
  admin_password                  = var.admin_password
  disable_password_authentication = var.diable_password
  network_interface_ids           = [azurerm_network_interface.nic.id]

  os_disk {
    name                 = "${var.project}-${var.env}-osdisk"
    caching              = "ReadWrite"
    disk_size_gb         = var.os_disk_size
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

  tags = {
    vm_type = var.tags.vm_type
    os_type = var.tags.os_type
    project = var.project
    env     = var.env
  }

}


