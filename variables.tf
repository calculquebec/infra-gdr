variable "cluster_name" {
  type        = string
  description = "The name that identifies the cluster.\nMust start and end with a letter or number, and can contain letters, numbers, hyphens, and underscores.\nRead more at https://www.rfc-editor.org/rfc/rfc3986"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9]$", var.cluster_name))
    error_message = "The cluster name must start and end with a letter or number, and can contain letters, numbers, hyphens, and underscores."
  }
}

variable "gateway_instance_id" {
  type      = string
  default   = "c4014c5b-04ed-41f1-ae0c-7364c4e1e26e"
  sensitive = true
}

variable "gitlab_token" {
  type      = string
  sensitive = true
}

variable "gitlab_host" {
  type = string
}

variable "gitlab_group_parent_id" {
  type      = number
  default   = null
  sensitive = true
}

variable "key_pair" {
  type        = string
  description = "The name of the ssh key pair registered on openstack"
}

variable "ssh_proxy_port" {
  type      = string
  sensitive = true
}

locals {
  mattermost_rtc_port = var.ssh_proxy_port + 100
}

variable "apps" {
  type = map(any)
  default = {
    nextcloud = {
      volume_size = 100
    }
    mattermost = {
      volume_size = 50
    }
  }
}