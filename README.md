[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-subnetwork)

[![Build Status](https://github.com/mineiros-io/terraform-google-subnetwork/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-subnetwork/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-subnetwork.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-subnetwork/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-subnetwork

A [Terraform](https://www.terraform.io) module to create a [Google Network Subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version and 5.10+

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation](#terraform-google-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources:

- `google_compute_subnetwork`

and supports additional features of the following modules:

- [terraform-google-subnetwork-iam](https://github.com/mineiros-io/terraform-google-subnetwork-iam)

## Getting Started

Most common usage of the module:

```hcl
  module "terraform-google-subnetwork" {
    source        = "github.com/mineiros-io/terraform-google-subnetwork.git?ref=v0.1.0"

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project in which the resources belong. If it is not set, the provider project is used.

- [**`network`**](#var-network): *(**Required** `string`)*<a name="var-network"></a>

  The ID of the VPC network the subnets belong to. Only networks that are in the distributed mode can have subnetworks.

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of this subnetwork, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with [RFC1035](https://datatracker.ietf.org/doc/html/rfc1035).
  Specifically, the name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  An optional description of this subnetwork. Provide this property when you create the resource. This field can be set only at resource creation time.

- [**`region`**](#var-region): *(**Required** `string`)*<a name="var-region"></a>

  The GCP region for this subnetwork.

- [**`private_ip_google_access`**](#var-private_ip_google_access): *(Optional `bool`)*<a name="var-private_ip_google_access"></a>

  When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.

  Default is `true`.

- [**`purpose`**](#var-purpose): *(Optional `string`)*<a name="var-purpose"></a>

  (Optional) This field can be either PRIVATE_RFC_1918, REGIONAL_MANAGED_PROXY, 
  GLOBAL_MANAGED_PROXY, PRIVATE_SERVICE_CONNECT or PRIVATE_NAT(Beta).
  If unspecified, the purpose defaults to PRIVATE_RFC_1918.

  Default is `null`.

- [**`role`**](#var-role): *(Optional `string`)*<a name="var-role"></a>

  The role of subnetwork. Currently, this field is only used when 
  purpose is REGIONAL_MANAGED_PROXY. The value can be set to ACTIVE or BACKUP. 
  An ACTIVE subnetwork is one that is currently being used for Envoy-based 
  load balancers in a region. A BACKUP subnetwork is one that is ready to 
  be promoted to ACTIVE or is currently draining.

  Default is `null`.

- [**`private_ipv6_google_access`**](#var-private_ipv6_google_access): *(Optional `bool`)*<a name="var-private_ipv6_google_access"></a>

  The private IPv6 google access type for the VMs in this subnet.

  Default is `true`.

- [**`stack_type`**](#var-stack_type): *(Optional `string`)*<a name="var-stack_type"></a>

  The stack type for this subnet to identify whether the IPv6 feature is enabled or not. 
  If not specified IPV4_ONLY will be used. Possible values are: IPV4_ONLY, IPV4_IPV6.

  Default is `null`.

- [**`ipv6_access_type`**](#var-ipv6_access_type): *(Optional `string`)*<a name="var-ipv6_access_type"></a>

  The access type of IPv6 address this subnet holds. 
  It's immutable and can only be specified during creation or the first time the subnet is updated 
  into IPV4_IPV6 dual stack. If the ipv6_type is EXTERNAL then this subnet cannot enable direct path. 
  Possible values are: EXTERNAL, INTERNAL.

  Default is `null`.

- [**`external_ipv6_prefix`**](#var-external_ipv6_prefix): *(Optional `string`)*<a name="var-external_ipv6_prefix"></a>

  The range of external IPv6 addresses that are owned by this subnetwork.

  Default is `null`.

- [**`ip_cidr_range`**](#var-ip_cidr_range): *(**Required** `string`)*<a name="var-ip_cidr_range"></a>

  The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.

- [**`secondary_ip_ranges`**](#var-secondary_ip_ranges): *(Optional `list(secondary_ip_range)`)*<a name="var-secondary_ip_ranges"></a>

  An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.

  Example:

  ```hcl
  secondary_ip_range = {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
  ```

  Each `secondary_ip_range` object in the list accepts the following attributes:

  - [**`range_name`**](#attr-secondary_ip_ranges-range_name): *(**Required** `string`)*<a name="attr-secondary_ip_ranges-range_name"></a>

    The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.

  - [**`ip_cidr_range`**](#attr-secondary_ip_ranges-ip_cidr_range): *(**Required** `string`)*<a name="attr-secondary_ip_ranges-ip_cidr_range"></a>

    The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only `IPv4` is supported.

- [**`log_config`**](#var-log_config): *(Optional `object(log_config)`)*<a name="var-log_config"></a>

  Logging options for the subnetwork flow logs. Setting this value to 'null' will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.

  Example:

  ```hcl
  log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    metadata_fields      = "CUSTOM_METADATA"
    filter_expr          = true
  }
  ```

  The `log_config` object accepts the following attributes:

  - [**`aggregation_interval`**](#attr-log_config-aggregation_interval): *(Optional `string`)*<a name="attr-log_config-aggregation_interval"></a>

    Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of `5 seconds` per connection. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.

  - [**`flow_sampling`**](#attr-log_config-flow_sampling): *(Optional `number`)*<a name="attr-log_config-flow_sampling"></a>

    Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported.

  - [**`metadata`**](#attr-log_config-metadata): *(Optional `string`)*<a name="attr-log_config-metadata"></a>

    Can only be specified if VPC flow logging for this subnetwork is `enabled`. Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.

  - [**`metadata_fields`**](#attr-log_config-metadata_fields): *(Optional `list(string)`)*<a name="attr-log_config-metadata_fields"></a>

    List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `"metadata"` is set to `CUSTOM_METADATA`.

  - [**`filter_expr`**](#attr-log_config-filter_expr): *(Optional `string`)*<a name="attr-log_config-filter_expr"></a>

    Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.

### Extended Resource Configuration

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access.

  Example:

  ```hcl
  iam = [{
    role          = "roles/compute.networkUser"
    members       = ["user:member@example.com"]
    authoritative = false
  }]
  ```

  Each `iam` object in the list accepts the following attributes:

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

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
    - `computed:{identifier}`: An existing key from `var.computed_members_map`.

    Default is `[]`.

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`roles`**](#attr-iam-roles): *(Optional `list(string)`)*<a name="attr-iam-roles"></a>

    The set of roles that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

  - [**`condition`**](#attr-iam-condition): *(Optional `object(condition)`)*<a name="attr-iam-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

- [**`computed_members_map`**](#var-computed_members_map): *(Optional `map(string)`)*<a name="var-computed_members_map"></a>

  A map of members to replace in `members` of various IAM settings to handle terraform computed values.

  Default is `{}`.

- [**`policy_bindings`**](#var-policy_bindings): *(Optional `list(policy_binding)`)*<a name="var-policy_bindings"></a>

  A list of IAM policy bindings.

  Example:

  ```hcl
  policy_bindings = [{
    role      = "roles/compute.networkUser"
    members   = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]
  ```

  Each `policy_binding` object in the list accepts the following attributes:

  - [**`role`**](#attr-policy_bindings-role): *(**Required** `string`)*<a name="attr-policy_bindings-role"></a>

    The role that should be applied.

  - [**`members`**](#attr-policy_bindings-members): *(Optional `set(string)`)*<a name="attr-policy_bindings-members"></a>

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - [**`condition`**](#attr-policy_bindings-condition): *(Optional `object(condition)`)*<a name="attr-policy_bindings-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    The `condition` object accepts the following attributes:

    - [**`expression`**](#attr-policy_bindings-condition-expression): *(**Required** `string`)*<a name="attr-policy_bindings-condition-expression"></a>

      Textual representation of an expression in Common Expression Language syntax.

      You can find more information about the usage of Common Expression Language for IAM conditions
      in the [official IAM Conditions documentation](https://cloud.google.com/iam/docs/conditions-overview#cel).

    - [**`title`**](#attr-policy_bindings-condition-title): *(**Required** `string`)*<a name="attr-policy_bindings-condition-title"></a>

      A title for the expression, i.e. a short string describing its purpose.

    - [**`description`**](#attr-policy_bindings-condition-description): *(Optional `string`)*<a name="attr-policy_bindings-condition-description"></a>

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `google_compute_subnetwork`,

  Example:

  ```hcl
  module_timeouts = {
    null_resource = {
      create = "4m"
      update = "4m"
      delete = "4m"
    }
  }
  ```

  Each `timeout` object in the map accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`subnetwork`**](#output-subnetwork): *(`map(subnetwork)`)*<a name="output-subnetwork"></a>

  The created subnet resource.

## External Documentation

### Google Documentation

- Configuring Private Google Access: <https://cloud.google.com/vpc/docs/configure-private-google-access>
- Using VPC networks: <https://cloud.google.com/vpc/docs/using-vpc>

### Terraform Google Provider Documentation

- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#flow_sampling>

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-subnetwork
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-subnetwork/issues
[license]: https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-subnetwork/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-subnetwork/blob/main/CONTRIBUTING.md
