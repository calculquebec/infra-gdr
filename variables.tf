variable "cloud" {
  type        = string
  description = "The name of the OpenStack cloud to use from the `clouds.yaml` file.\nIf not provided, falls back to the `OS_CLOUD` environment variable.\nIf neither is set, attempts to retrieve the variables from the OpenStack `rc` file."
}

data "external" "keystone" {
  program = ["python3", "${path.module}/external/keystone.py"]
}

variable "name" {
  type        = string
  description = "The research group name.\nMust start with a letter or number, and can contain letters, numbers, hyphens, and underscores.\nRead more at https://www.rfc-editor.org/rfc/rfc3986"
  validation {
    condition     = can(regex("^([a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9])$", var.name))
    error_message = "Research group name must start with a letter or number, and can contain letters, numbers, hyphens, and underscores."
  }
}