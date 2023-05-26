# ---------------------------------------------------------------------------------------------------------------------
# Subnetwork Config
# The default gateway automatically configures public internet access for instances with addresses for 0.0.0.0/0
# External access is configured with Cloud NAT, which serves egress traffic for instances without external addresses
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_subnetwork" "subnetwork" {
  count = var.module_enabled ? 1 : 0

  project     = var.project
  network     = var.network
  region      = var.region
  name        = var.name
  description = var.description
  purpose     = var.purpose
  private_ip_google_access = var.private_ip_google_access
  ip_cidr_range            = cidrsubnet(var.ip_cidr_range, 0, 0)

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []

    content {
      aggregation_interval = try(log_config.value.aggregation_interval, null)
      flow_sampling        = try(log_config.value.flow_sampling, null)
      metadata             = try(log_config.value.metadata, null)
      metadata_fields      = try(log_config.value.metadata_fields, null)
      filter_expr          = try(log_config.value.filter_expr, null)
    }
  }

  dynamic "timeouts" {
    for_each = try([var.module_timeouts.google_compute_subnetwork], [])

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  depends_on = [var.module_depends_on]
}
