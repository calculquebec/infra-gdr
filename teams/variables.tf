variable "name" {
  type = string
  description = "The name of the team"
}

variable "number" {
  type = number
  description = "The number of the team"
}

variable "gateway" {
  type = any
  description = "The gateway resource"
}

variable "mattermost_domain" {
  type = string
  description = "The domain name for the mattermost instance"
  default = "chat.cirst.ca"
}

variable "nextcloud_domain" {
  type = string
  description = "The domain name for the nextcloud instance"
  default = "cloud.cirst.ca"
}