# databases
resource "openstack_networking_secgroup_v2" "databases" {
  name        = "${var.secgroup_name}"
  description = "Security group for PostgreSQL Highly Available Cluster (PHAC)"
}

resource "openstack_networking_secgroup_rule_v2" "psql_ingress_client" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "${var.client_ip_v4}/32"
  security_group_id = openstack_networking_secgroup_v2.databases.id
}

resource "openstack_networking_secgroup_rule_v2" "psql_ingress_replication" {
  count             = length(openstack_compute_instance_v2.databases)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "${openstack_compute_instance_v2.databases[count.index].access_ip_v4}/32"  
  security_group_id = openstack_networking_secgroup_v2.databases.id
}