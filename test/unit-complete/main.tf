module "test" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  network       = "projects/test-project/global/networks/test-network"
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  secondary_ip_ranges = [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.10.0.0/20"
    }
  ]

  # add all optional arguments that create additional resources

  # add most/all other optional arguments

  # module_tags = {
  #   Environment = "unknown"
  # }

  module_depends_on = ["nothing"]
}
