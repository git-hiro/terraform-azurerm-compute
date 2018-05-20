provider "azurerm" {
  subscription_id = "${var.service_principal["subscription_id"]}"
  tenant_id       = "${var.service_principal["tenant_id"]}"
  client_id       = "${var.service_principal["client_id"]}"
  client_secret   = "${var.service_principal["client_secret"]}"
}
