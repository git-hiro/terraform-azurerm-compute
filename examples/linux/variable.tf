variable "service_principal" {
  type = "map"

  default = {
    subscription_id = ""
    tenant_id       = ""
    client_id       = ""
    client_secret   = ""
  }
}

variable "remote_state" {
  type = "map"

  default = {
    storage_account_name = ""
    container_name       = ""
    key                  = ""
    access_key           = ""
  }
}

variable "vnet" {
  type = "map"

  default = {
    resource_group_name = ""
    name                = ""
    subnet_name         = ""
  }
}

variable "avset" {
  type = "map"

  default = {
    name     = ""
    location = ""

    platform_fault_domain_count  = 2
    platform_update_domain_count = 5

    managed = true
  }
}

variable "common" {
  type = "map"

  default = {
    resource_group_name = ""
  }
}

variable "default" {
  type = "map"

  default = {
    vnet_resource_group_name = ""
    vnet_name                = ""
  }
}

variable "computes" {
  type = "list"

  default = []
}
