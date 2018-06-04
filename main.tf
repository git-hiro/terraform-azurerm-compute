locals {
  vm_name_format = "${var.compute["name"]}-%02d"
}

data "azurerm_subnet" "subnet" {
  resource_group_name  = "${var.subnet["resource_group_name"]}"
  virtual_network_name = "${var.subnet["vnet_name"]}"
  name                 = "${var.subnet["name"]}"
}

data "azurerm_storage_account" "storage_account" {
  count = "${var.compute["boot_diagnostics_enabled"] ? 1 : 0}"

  resource_group_name = "${var.storage_account["resource_group_name"]}"
  name                = "${var.storage_account["name"]}"
}

resource "azurerm_virtual_machine" "vms" {
  count = "${length(var.computes)}"

  resource_group_name = "${var.compute["resource_group_name"]}"

  name     = "${lookup(var.computes[count.index], "name", format(local.vm_name_format, count.index + 1))}"
  location = "${lookup(var.computes[count.index], "location", var.compute["location"])}"
  vm_size  = "${lookup(var.computes[count.index], "vm_size", var.compute["vm_size"])}"

  os_profile {
    computer_name  = "${lookup(var.computes[count.index], "name", format(local.vm_name_format, count.index + 1))}"
    admin_username = "${lookup(var.computes[count.index], "admin_username", var.compute["admin_username"])}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${lookup(var.computes[count.index], "admin_username", var.compute["admin_username"])}/.ssh/authorized_keys"
      key_data = "${file("${lookup(var.computes[count.index], "key_data_path", var.compute["key_data_path"])}")}"
    }
  }

  storage_os_disk {
    name              = "${lookup(var.computes[count.index], "name", format(local.vm_name_format, count.index + 1))}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.computes[count.index], "os_disk_type", var.compute["os_disk_type"])}"
    disk_size_gb      = "${lookup(var.computes[count.index], "os_disk_size_gb", var.compute["os_disk_size_gb"])}"
  }

  delete_os_disk_on_termination = "${lookup(var.computes[count.index], "os_disk_on_termination", var.compute["os_disk_on_termination"])}"

  storage_image_reference {
    publisher = "${lookup(var.computes[count.index], "os_image_publisher", var.compute["os_image_publisher"])}"
    offer     = "${lookup(var.computes[count.index], "os_image_offer", var.compute["os_image_offer"])}"
    sku       = "${lookup(var.computes[count.index], "os_image_sku", var.compute["os_image_sku"])}"
    version   = "${lookup(var.computes[count.index], "os_image_version", var.compute["os_image_version"])}"
  }

  network_interface_ids = ["${element(azurerm_network_interface.nics.*.id, count.index)}"]
  availability_set_id   = "${var.avset["exists"] ? "${join("", azurerm_availability_set.avset.*.id)}" : ""}"

  boot_diagnostics {
    enabled     = "${var.compute["boot_diagnostics_enabled"] ? lookup(var.computes[count.index], "boot_diagnostics_enabled", var.compute["boot_diagnostics_enabled"]) : false}"
    storage_uri = "${join("", data.azurerm_storage_account.storage_account.*.primary_blob_endpoint)}"
  }

  depends_on = [
    "azurerm_network_interface.nics",
    "azurerm_availability_set.avset",
  ]
}

resource "azurerm_network_interface" "nics" {
  count = "${length(var.computes)}"

  resource_group_name = "${var.compute["resource_group_name"]}"

  name     = "${lookup(var.computes[count.index], "name", format(local.vm_name_format, count.index + 1))}-nic"
  location = "${lookup(var.computes[count.index], "location", var.compute["location"])}"

  ip_configuration {
    name      = "${lookup(var.computes[count.index], "name", format(local.vm_name_format, count.index + 1))}-ip-config"
    subnet_id = "${data.azurerm_subnet.subnet.id}"

    private_ip_address_allocation = "${lookup(var.computes[count.index], "private_ip_address", "") != "" ? "static" : "dynamic"}"
    private_ip_address            = "${lookup(var.computes[count.index], "private_ip_address", "")}"
  }
}

resource "azurerm_availability_set" "avset" {
  count = "${var.avset["exists"] ? 1 : 0}"

  resource_group_name = "${var.compute["resource_group_name"]}"

  name     = "${var.avset["name"] != "" ? var.avset["name"] : "${var.compute["name"]}-avset"}"
  location = "${var.avset["location"]}"

  platform_fault_domain_count  = "${var.avset["platform_fault_domain_count"]}"
  platform_update_domain_count = "${var.avset["platform_update_domain_count"]}"

  managed = "${var.avset["managed"]}"
}
