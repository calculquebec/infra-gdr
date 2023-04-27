variable "cloud" {
  type        = string
  description = "The name of the OpenStack cloud to use from the `clouds.yaml` file.\nIf not provided, falls back to the `OS_CLOUD` environment variable.\nIf neither is set, attempts to retrieve the variables from the OpenStack `rc` file."
}

data "external" "keystone" {
  program = ["python3", "${path.module}/external/keystone.py"]
}
