# Overview

- `apps.tf`: Terraform configuration for deploying the research data management services.
- `databases.tf`: Terraform configuration for deploying the databases required by the services.
- `external`: Directory containing external scripts and files required by the project.
  - `databases/setup.sh`: Shell script for setting up the databases.
  - `keystone.py`: Python script for authenticating with the Keystone identity service.
- `firewall.tf`: Terraform configuration for setting up the firewall rules.
- `outputs.tf`: Terraform configuration for defining the output variables.
- `providers.tf`: Terraform configuration for defining the provider information.
- `variables.tf`: Terraform configuration for defining the input variables.
- `versions.tf`: Terraform configuration for defining the required Terraform version.
