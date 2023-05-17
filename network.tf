resource "openstack_networking_secgroup_v2" "cluster" {
  name        = "${var.cluster_name}-cluster"
  description = "Security group for the `${var.cluster_name}` cluster"
}

resource "openstack_networking_secgroup_rule_v2" "ingress_tcp_same_netsec" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = openstack_networking_secgroup_v2.cluster.id
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "ingress_udp_same_netsec" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_group_id   = openstack_networking_secgroup_v2.cluster.id
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "ingress_ssh_gateway" {
  description       = "Allow ingress SSH from gateway"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${data.openstack_compute_instance_v2.gateway.access_ip_v4}/32"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "ingress_http_gateway" {
  description       = "Allow ingress HTTP from gateway"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "${data.openstack_compute_instance_v2.gateway.access_ip_v4}/32"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}

resource "openstack_networking_secgroup_rule_v2" "ingress_https_gateway" {
  description       = "Allow ingress HTTPS from gateway"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "${data.openstack_compute_instance_v2.gateway.access_ip_v4}/32"
  security_group_id = openstack_networking_secgroup_v2.cluster.id
}
