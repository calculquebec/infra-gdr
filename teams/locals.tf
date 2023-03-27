locals {
  nextcloud_server_name = "${var.name}.${var.nextcloud_domain}"
  mattermost_server_name = "${var.name}.${var.mattermost_domain}"
}