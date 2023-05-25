locals {
  databases = [
    for i in range(length(module.phac.databases)) : {
      name         = module.phac.databases[i].name,
      access_ip_v4 = module.phac.databases[i].access_ip_v4
    }
  ]
  volumes = [
    for app, attachment in openstack_compute_volume_attach_v2.attachments : {
      name   = app
      device = attachment.device
    }
  ]
}

resource "ansible_group" "all" {
  name = "all"
  variables = {
    remote_tmp   = "/tmp/ansible"
    cluster_name = var.cluster_name
    public_ip    = data.openstack_networking_floatingip_v2.gateway.address
    volumes      = "{{ '${jsonencode(local.volumes)}' | from_json }}"
    databases    = "{{ '${jsonencode(local.databases)}' | from_json }}"
    primary      = "{{ '${jsonencode(local.databases[0])}' | from_json }}"
  }

}

##

resource "ansible_host" "apps" {
  name   = openstack_compute_instance_v2.apps.name
  groups = ["apps"]
  variables = {
    ansible_user            = "ubuntu",
    ansible_host            = openstack_compute_instance_v2.apps.access_ip_v4,
    ansible_ssh_common_args = "-J {{ ansible_user }}@{{ public_ip }}:${var.ssh_proxy_port} -o StrictHostKeyChecking=no"
  }
}

##

resource "ansible_host" "databases" {
  count  = length(module.phac.databases)
  name   = module.phac.databases[count.index].name
  groups = ["databases"]
  variables = {
    ansible_user            = "ubuntu",
    ansible_host            = module.phac.databases[count.index].access_ip_v4,
    ansible_ssh_common_args = "-J {{ ansible_user }}@{{ public_ip }}:${var.ssh_proxy_port} -o StrictHostKeyChecking=no"
    repmgr_node_id          = "${count.index + 1}"
    repmgr_node_name        = "node{{ repmgr_node_id }}"
  }
}
