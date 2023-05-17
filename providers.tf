terraform {
  # backend "http" {}
  required_providers {
    ansible = {
      version = "~> 1.0.0"
      source  = "ansible/ansible"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    gitlab = {
      version = "~> 15.11.0"
      source = "gitlabhq/gitlab"
    }
  }
}

provider "openstack" {}

provider "gitlab" {
  token = var.gitlab_token
  base_url = "https://${var.gitlab_host}/api/v4"
}

resource "gitlab_group" "main" {
  name                   = var.cluster_name
  path                   = var.cluster_name
  parent_id              = var.gitlab_group_parent_id != null ? var.gitlab_group_parent_id : null
  description            = "This group provides members with access to services from the \"${var.cluster_name}\" cluster"
  request_access_enabled = false
}

data "gitlab_user" "main" {
  username = var.gitlab_group_admin
}

resource "gitlab_group_membership" "main" {
 group_id     = gitlab_group.main.id
 user_id      = data.gitlab_user.main.user_id
 access_level = "owner"
}

output "gitlab_group_applications" {
  value = <<-GROUP_APPLICATIONS
    You might want to head to `https://${var.gitlab_host}/groups/gdr/${var.cluster_name}/-/settings/applications` 
    to create group applications for allowing services access to group members:

      - name: mattermost
        redirect_uris:
          https://${var.cluster_name}.chat.cirst.ca/login/gitlab/complete
          https://${var.cluster_name}.chat.cirst.ca/signup/gitlab/complete
        scopes:
          read_api

      - name: nextcloud
        redirect_uris:
          https://${var.cluster_name}.cloud.cirst.ca/index.php/apps/sociallogin/custom_oidc/gitlab
        scopes:
          openid
  GROUP_APPLICATIONS
}
