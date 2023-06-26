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

resource "azurerm_linux_virtual_machine" "test" {
  name                  = "TEST"
  location              = var.location
  resource_group_name   = var.resource_group
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = var.admin_username    
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQNd6Ohphm54J0h/HsqxQQ5BTfDWPf63/hhXQo5IxdtUa6j5nfS3QqwdrdRRNW06rkoYlM61iD40jcL+0+6lBLiEvOTSmW8vu+IuewYLzg30FS7rds9olKqEFCXSjT6KpuDAnRPn7p67uqrdX5YD5hmp2+QTLxO1uYJgrCMpIkaK2FYILXGVk+M+sZx43RZisqWtJD9J3PzUKHJK/RrcvqTLsKwnGUOfyJF10vYL2EHnBZ7xm7d12rvjZpWhyOl7ENtvisDfPDAOKVUwGT/J3iyspUdK2dtzeOfJCyCAULnnwCOVO559/1krvTJS4cfMaVB49AEuAypFOm9UEQuuEPLzKVuzkhlvkUYxJp/hUnlNQp2pEYuKniCUpa5rk5WdWzmu1QVxAcPVbZuBBMw7eQhvIciXeY1pGkTZCQQqZCR5/BKg168YwdiKPyU75RQygND5MLtvk7u85DpdhOTNpWBZ2IRTriBW+dSJtF5fnwYk9xAQ3ztFE5nuOmDhEZ06s= root@AFSEETLLNB00222"
   
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_id       = data.azurerm_shared_image.test.id
}