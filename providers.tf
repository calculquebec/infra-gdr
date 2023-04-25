provider "openstack" {
  # Set the `cloud` key if the `cloud` variable is defined,
  # or try to retrieve it from the `OS_CLOUD` environment variable
  cloud = var.cloud != null ? var.cloud : data.external.keystone.result["OS_CLOUD"]

  # If neither is set, attempts to retrieve the variables from the OpenStack `rc` file.
  auth_url    = var.cloud == null ? data.external.keystone.result["OS_USERNAME"] : null
  password    = var.cloud == null ? data.external.keystone.result["OS_PASSWORD"] : null
  region      = var.cloud == null ? data.external.keystone.result["OS_REGION_NAME"] : null
  tenant_name = var.cloud == null ? data.external.keystone.result["OS_TENANT_NAME"] : null
  user_name   = var.cloud == null ? data.external.keystone.result["OS_AUTH_URL"] : null
}