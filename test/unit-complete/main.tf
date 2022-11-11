module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.0.12"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source = "../.."

  module_enabled = true
  project        = local.project_id

  # add all required arguments
  network       = "projects/test-project/global/networks/test-network"
  name          = "test-subnetwork"
  description   = "unit-complete"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  secondary_ip_ranges = [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.10.0.0/20"
    }
  ]

  private_ip_google_access = false

  # add all optional arguments that create additional resources

  # add most/all other optional arguments

  # module_tags = {
  #   Environment = "unknown"
  # }

  log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "CUSTOM_METADATA"
    metadata_fields      = ["field0"]
    filter_expr          = true
  }

  iam = [
    {
      role    = "roles/browser"
      members = ["domain:example-domain"]
      condition = {
        title       = "expires_after_2021_12_31"
        description = "Expiring at midnight of 2021-12-31"
        expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      }
    },
    {
      role          = "roles/viewer"
      members       = ["domain:example-domain"]
      authoritative = false
    },
    {
      roles   = ["roles/editor", "roles/browser"]
      members = ["computed:computed_sa"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  module_depends_on = ["nothing"]
}

module "test2" {
  source = "../.."

  module_enabled = true
  project        = local.project_id

  # add all required arguments
  network       = "projects/test-project/global/networks/test-network"
  name          = "test-subnetwork"
  description   = "unit-complete"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  secondary_ip_ranges = [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.10.0.0/20"
    }
  ]

  private_ip_google_access = false

  # add all optional arguments that create additional resources

  # add most/all other optional arguments

  # module_tags = {
  #   Environment = "unknown"
  # }

  log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    filter_expr          = true
  }

  policy_bindings = [{
    role    = "roles/storage.admin"
    members = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  module_depends_on = ["nothing"]
}
