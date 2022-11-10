module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  network       = "projects/test-project/global/networks/test-network"
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"

  # add all optional arguments that create additional resources
  secondary_ip_ranges = [
    {
      range_name    = "kubernetes-pods"
      ip_cidr_range = "10.10.0.0/20"
    }
  ]
}
