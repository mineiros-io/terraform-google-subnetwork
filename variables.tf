# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "(Required) The VPC network the subnets belong to. Only networks that are in the distributed mode can have subnetworks."
  type        = string
}

variable "name" {
  type        = string
  description = "(Required) The name of this subnetwork, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with [RFC1035](https://datatracker.ietf.org/doc/html/rfc1035). Specifically, the name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."

}

variable "description" {
  type        = string
  description = "(Optional) An optional description of this subnetwork. Provide this property when you create the resource. This field can be set only at resource creation time."
  default     = null
}

variable "region" {
  type        = string
  description = "(Required) The GCP region for this subnetwork."
}
variable "private_ip_google_access" {
  type        = bool
  description = "(Optional) When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access."
  default     = true

}
variable "ip_cidr_range" {
  type        = string
  description = "(Required) The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
}

variable "secondary_ip_ranges" {

  type = list(any)
  # type = list(object({
  #   range_name    = string
  #   ip_cidr_range = string
  # }))
  description = "An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges."
  default     = []
}

variable "log_config" {
  description = "(Optional) Logging options for the subnetwork flow logs. Setting this value to 'null' will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples."
  # type = object({
  #   aggregation_interval = optional(string)
  #   flow_sampling        = optional(number)
  #   metadata             = optional(string)
  #   metadata_fields      = optional(list(string))
  #   filter_expr          = optional(string)
  # })
  type    = any
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resources belong. If it is not set, the provider project is used."
  default     = null
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_timeouts" {
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  # type = object({
  #   google_compute_subnetwork = optional(object({
  #     create = optional(string)
  #     update = optional(string)
  #     delete = optional(string)
  #   }))
  # })
  default = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
