locals {
  iam_map = { for iam in var.iam : iam.role => iam }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-subnetwork-iam.git?ref=v0.0.1"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  subnetwork    = try(google_compute_subnetwork.subnetwork[0].name, null)
  role          = each.value.role
  members       = each.value.members
  authoritative = try(each.value.authoritative, true)
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-subnetwork-iam.git?ref=v0.0.1"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  subnetwork      = try(google_compute_subnetwork.subnetwork[0].name, null)
  policy_bindings = var.policy_bindings
}
