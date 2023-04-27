output "endpoints" {
  description = "Endpoints for the research group"
  value = {
    mattermost = "${var.name}.chat.cirst.ca"
    nextcloud  = "${var.name}.cloud.cirst.ca"
  }
}