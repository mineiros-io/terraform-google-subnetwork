module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  network       = "projects/test-project/global/networks/test-network"
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
}
