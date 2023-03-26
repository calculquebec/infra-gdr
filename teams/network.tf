resource "openstack_networking_secgroup_v2" "apps" {
  name        = "apps-${var.name}"
  description = "Allow HTTP(S) traffic from any host and interfaces"
}

resource "openstack_networking_secgroup_rule_v2" "gitlab" {
  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "tcp"
  port_range_min = 3000
  port_range_max = 3000
  remote_ip_prefix = var.gateway.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_rule_v2" "mattermost" {
  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "tcp"
  port_range_min = 4000
  port_range_max = 4000
  remote_ip_prefix = var.gateway.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_rule_v2" "nextcloud" {
  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "tcp"
  port_range_min = 5000
  port_range_max = 5000
  remote_ip_prefix = var.gateway.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_v2" "postgresql" {
  name        = "psql-${var.name}"
  description = "Security group for PostgreSQL database server"
}

resource "openstack_networking_secgroup_rule_v2" "postgresql" {
  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "tcp"
  port_range_min = 5432
  port_range_max = 5432
  remote_ip_prefix = openstack_compute_instance_v2.apps.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.postgresql.id
}
