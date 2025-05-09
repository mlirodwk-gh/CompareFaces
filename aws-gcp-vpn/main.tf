locals {
  interpolated_tags = merge(
    { "Customer" = var.customer },
    { "Environment" = var.environment },
    var.tags
  )
}

terraform {
  backend "local" {
    path = "local.tfstate"
  }
}
