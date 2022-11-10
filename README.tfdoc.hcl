header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-subnetwork"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-subnetwork/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-subnetwork/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-subnetwork.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-subnetwork/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-subnetwork"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Network Subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources:

      - `google_compute_subnetwork`

      and supports additional features of the following modules:

      - [terraform-google-subnetwork-iam](https://github.com/mineiros-io/terraform-google-subnetwork-iam)
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
        module "terraform-google-subnetwork" {
          source        = "github.com/mineiros-io/terraform-google-subnetwork.git?ref=v0.0.2"

          network       = google_compute_network.custom-test.id
          name          = "test-subnetwork"
          ip_cidr_range = "10.2.0.0/16"
          region        = "us-central1"

          secondary_ip_ranges = [
            {
              range_name    = "kubernetes-pods"
              ip_cidr_range = "10.10.0.0/20"
            }
          ]
        }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "project" {
        type        = string
        description = <<-END
            The ID of the project in which the resources belong. If it is not set, the provider project is used.
          END
      }

      variable "network" {
        required    = true
        type        = string
        description = <<-END
            The ID of the VPC network the subnets belong to. Only networks that are in the distributed mode can have subnetworks.
          END
      }

      variable "name" {
        required    = true
        type        = string
        description = <<-END
            The name of this subnetwork, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with [RFC1035](https://datatracker.ietf.org/doc/html/rfc1035).
            Specifically, the name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.
            END
      }

      variable "description" {
        type        = string
        description = <<-END
              An optional description of this subnetwork. Provide this property when you create the resource. This field can be set only at resource creation time.
            END
      }

      variable "region" {
        required    = true
        type        = string
        description = <<-END
              The GCP region for this subnetwork.
            END
      }

      variable "private_ip_google_access" {
        type        = bool
        default     = true
        description = <<-END
            When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
        END
      }

      variable "ip_cidr_range" {
        required    = true
        type        = string
        description = <<-END
              The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.
            END
      }

      variable "secondary_ip_ranges" {
        type           = list(secondary_ip_range)
        description    = <<-END
              An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.
            END
        readme_example = <<-END
              secondary_ip_range {
                range_name    = "tf-test-secondary-range-update1"
                ip_cidr_range = "192.168.10.0/24"
              }
            END

        attribute "range_name" {
          required    = true
          type        = string
          description = <<-END
                The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.
              END
        }

        attribute "ip_cidr_range" {
          required    = true
          type        = string
          description = <<-END
                The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only `IPv4` is supported.
              END
        }
      }

      variable "log_config" {
        type        = object(log_config)
        description = <<-END
            Logging options for the subnetwork flow logs. Setting this value to 'null' will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.
          END

        readme_example = <<-END
              log_config {
                aggregation_interval = "INTERVAL_10_MIN"
                flow_sampling        = 0.5
                metadata             = "INCLUDE_ALL_METADATA"
                metadata_fields      = "CUSTOM_METADATA"
                filter_expr          = true
              }
            END

        attribute "aggregation_interval" {
          type        = string
          description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of `5 seconds` per connection. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.
              END
        }

        attribute "flow_sampling" {
          type        = number
          description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported.
              END
        }

        attribute "metadata" {
          type        = string
          description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is `enabled`. Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.
              END
        }

        attribute "metadata_fields" {
          type        = list(string)
          description = <<-END
                List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `"metadata"` is set to `CUSTOM_METADATA`.
              END
        }

        attribute "filter_expr" {
          type        = string
          description = <<-END
                Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.
              END
        }
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "iam" {
        type           = list(iam)
        description    = <<-END
          A list of IAM access.
        END
        readme_example = <<-END
          iam = [{
            role          = "roles/compute.networkUser"
            members       = ["user:member@example.com"]
            authoritative = false
          }]
        END

        attribute "members" {
          type        = set(string)
          default     = []
          description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`
          END
        }

        attribute "role" {
          type        = string
          description = <<-END
            The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        attribute "authoritative" {
          type        = bool
          default     = true
          description = <<-END
            Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
          END
        }
      }

      variable "policy_bindings" {
        type           = list(policy_binding)
        description    = <<-END
          A list of IAM policy bindings.
        END
        readme_example = <<-END
          policy_bindings = [{
            role      = "roles/compute.networkUser"
            members   = ["user:member@example.com"]
            condition = {
              title       = "expires_after_2021_12_31"
              description = "Expiring at midnight of 2021-12-31"
              expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
            }
          }]
        END

        attribute "role" {
          required    = true
          type        = string
          description = <<-END
            The role that should be applied.
          END
        }

        attribute "members" {
          type        = set(string)
          default     = var.members
          description = <<-END
            Identities that will be granted the privilege in `role`.
          END
        }

        attribute "condition" {
          type           = object(condition)
          description    = <<-END
            An IAM Condition for a given binding.
          END
          readme_example = <<-END
            condition = {
              expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
              title      = "expires_after_2021_12_31"
            }
          END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
              Textual representation of an expression in Common Expression Language syntax.

              You can find more information about the usage of Common Expression Language for IAM conditions
              in the [official IAM Conditions documentation](https://cloud.google.com/iam/docs/conditions-overview#cel).
            END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
              A title for the expression, i.e. a short string describing its purpose.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
              An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
            END
          }
        }
      }
    }


    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_timeouts" {
        type           = map(timeout)
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.

          Supported resources are: `google_compute_subnetwork`,
        END
        readme_example = <<-END
          module_timeouts = {
            null_resource = {
              create = "4m"
              update = "4m"
              delete = "4m"
            }
          }
        END

        attribute "create" {
          type        = string
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "subnetwork" {
      type        = map(subnetwork)
      description = <<-END
        The created subnet resource.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Configuring Private Google Access: <https://cloud.google.com/vpc/docs/configure-private-google-access>
        - Using VPC networks: <https://cloud.google.com/vpc/docs/using-vpc>
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#flow_sampling>
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-subnetwork"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/CONTRIBUTING.md"
  }
}
