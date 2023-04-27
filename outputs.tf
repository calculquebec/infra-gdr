output "endpoints" {
  value = {
    mattermost = "${var.name}.chat.cirst.ca"
    nextcloud  = "${var.name}.cloud.cirst.ca"
  }
}