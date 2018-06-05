# load_balancer
variable "lb_subnet" {
  default = {
    resource_group_name = ""
    vnet_name           = ""
    name                = ""
  }
}

variable "lb" {
  default = {
    exists   = true
    location = "japaneast"
    ip_type  = "public"

    # public
    domain_name_label     = ""
    ip_address_allocation = "Dynamic"

    # private
    private_ip_address = ""
  }
}

# virtual_machine
variable "subnet" {
  default = {
    resource_group_name = ""
    vnet_name           = ""
    name                = ""
  }
}

variable "storage_account" {
  default = {
    resource_group_name = ""
    name                = ""
  }
}

variable "image" {
  default = {
    resource_group_name = ""
    name                = ""
  }
}

variable "platform_image" {
  default = {
    publisher = ""
    offer     = ""
    sku       = ""
    version   = ""
  }
}

variable "compute" {
  default = {
    resource_group_name = ""

    name     = ""
    location = "japaneast"
    vm_size  = ""

    admin_username = ""
    key_data_path  = ""

    os_type = "Linux"

    os_disk_type    = ""
    os_disk_size_gb = ""

    os_disk_on_termination = true

    private_ip_address = ""

    boot_diagnostics_enabled = true
  }
}

variable "computes" {
  default = []
}

variable "avset" {
  default = {
    exists = true

    name     = ""
    location = "japaneast"

    platform_fault_domain_count  = 2
    platform_update_domain_count = 5

    managed = true
  }
}
