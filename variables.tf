variable "INTERNAL_GATEWAY_IPV4" {
  type        = string
  description = "The internal gateway for HTTP(S) traffic"
}

variable "ENVIRONMENT_NAME" {
  type        = string
  description = "The name that identifies the cluster.\nMust start with a letter or number, and can contain letters, numbers, hyphens, and underscores.\nRead more at https://www.rfc-editor.org/rfc/rfc3986"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9]$", var.ENVIRONMENT_NAME))
    error_message = "The cluster name must start with a letter or number, and can contain letters, numbers, hyphens, and underscores."
  }
}
