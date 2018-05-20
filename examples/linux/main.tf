module "linux" {
  source = "../../"

  vnet     = "${var.vnet}"
  avset    = "${var.avset}"
  common   = "${var.common}"
  default  = "${var.default}"
  computes = "${var.computes}"
}
