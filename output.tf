output "computes" {
  value = "${
    map(
      "id", "${azurerm_virtual_machine.vms.*.id}",
      "name", "${azurerm_virtual_machine.vms.*.name}",
    )
  }"
}

output "avset" {
  value = "${
    map(
      "id", "${azurerm_availability_set.avset.*.id}",
      "name", "${azurerm_availability_set.avset.*.name}",
    )
  }"
}
