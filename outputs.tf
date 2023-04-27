output "endpoints" {
  description = "Endpoints for the research group"
  value = {
    mattermost = "${local.workspace}.chat.cirst.ca"
    nextcloud  = "${local.workspace}.cloud.cirst.ca"
  }
}