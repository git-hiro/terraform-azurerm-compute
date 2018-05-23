variable "subnet" {
  type = "map"

  default = {
    resource_group_name = ""
    vnet_name           = ""
    name                = ""
  }
}

variable "avset" {
  type = "map"

  default = {
    name     = ""
    location = "japaneast"

    platform_fault_domain_count  = 2
    platform_update_domain_count = 5

    managed = true
  }
}

variable "sa" {
  type = "map"

  default = {
    resource_group_name = ""
    name                = ""
  }
}

variable "default" {
  type = "map"

  default = {
    resource_group_name = ""

    location = "japaneast"
    vm_size  = ""

    admin_username = ""
    key_data_path  = ""

    os_disk_on_termination = true

    os_disk_type    = ""
    os_disk_size_gb = ""

    private_ip_address_allocation = "dynamic"
  }
}

variable "computes" {
  type = "list"

  default = []
}
