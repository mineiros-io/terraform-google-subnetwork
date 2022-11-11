# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add support for `computed_members_map`
- Add support for `iam.condition`

### Removed

- BREAKING CHANGE: remove output `module_enabled`
- BREAKING CHANGE: remove support for `google` provider version `3`

## [0.0.2]

### Fixed

- use `count` instead `for_each`

## [0.0.1]

### Added

- Add IAM support
- Add support for `google_compute_subnetwork` Terraform resource

[unreleased]: https://github.com/mineiros-io/terraform-google-subnetwork/compare/v0.0.1...HEAD
<!-- [0.0.2]: https://github.com/mineiros-io/terraform-google-subnetwork/compare/v0.0.1...v0.0.2 -->
[0.0.1]: https://github.com/mineiros-io/terraform-google-subnetwork/releases/tag/v0.0.1
