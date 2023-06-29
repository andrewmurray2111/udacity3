resource "azurerm_network_interface" "test" {
  name                = "test-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

data "azurerm_shared_image" "test" {
  name                = var.shared_image_name
  gallery_name        = var.shared_image_gallery
  resource_group_name = var.shared_image_resource_group
}

resource "azurerm_windows_virtual_machine" "test" {
  name                  = "TEST"
  location              = var.location
  resource_group_name   = var.resource_group
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.test.id]

  # Windows VMs don't support ssh out of the box
  # admin_ssh_key {
  #   username   = var.admin_username    
  #   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1nFZzUvmqkXR6QoKj/XslqMCI62xIImhEIvQieKkb9wL0oE616ReBnDfA8xSAkr8c1E51g2naf/KRFEpaC//fk+YrWBefulJNTFQwUv6/3VQEwHw/SVH1Ti8/lgLzZK6CBY2fbEXiQLRJpkj1Z6hdYi8nd4+3uCSoqToo/XBMovzTl5OqmAzoAgy675drM33u9oXB0/CXl4FtYYySdUd7aaVRbODkjH1yVV8w/0dpqVCyCLg+HknqJXkVN3fPZVFYtpIdLbW+WXTHLjjSfn7Ng2g9hQs+TBjuITPyUQk7bGIJlfRR+PZPHrcfCP4LodQ7TSctzy7W9Ex1nxJ6iAQreA6Aqj+zbXW2cUf/khUeujGGzosekd6LHc9UN+cw/2E/qqEPVUEyqHEsti6KTdJk86Hxgpn4MBeV6KNsEeV94jasqdi94KLjHOyErkFEKcoIdUO+hKyX2vKlpBnIWrp3tGGcYVvKd1j31KrLxPpfEWUnED8Q4KJRRmk7cbVvbak= generated-by-azure"
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  #source_image_id       = data.azurerm_shared_image.test.id

  # original image
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}