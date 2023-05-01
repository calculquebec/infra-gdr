# gateway
resource "openstack_networking_secgroup_v2" "apps" {
  name        = "${var.ENVIRONMENT_NAME}-apps"
  description = "Allow HTTP(S) traffic from any host and interfaces"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = var.INTERNAL_GATEWAY_IPV4
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.INTERNAL_GATEWAY_IPV4
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

# databases
resource "openstack_networking_secgroup_v2" "databases" {
  name        = "${var.ENVIRONMENT_NAME}-databases"
  description = "Security group for PostgreSQL Highly Available Cluster (PHAC)"
}

resource "openstack_networking_secgroup_rule_v2" "databases_psql_ingress_from_apps" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = openstack_compute_instance_v2.apps.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.databases.id
}

resource "openstack_networking_secgroup_rule_v2" "databases_psql_ingress_from_standby" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = openstack_compute_instance_v2.standby_db.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.databases.id
}

resource "openstack_networking_secgroup_rule_v2" "databases_psql_ingress_from_primary" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = openstack_compute_instance_v2.primary_db.access_ip_v4
  security_group_id = openstack_networking_secgroup_v2.databases.id
}