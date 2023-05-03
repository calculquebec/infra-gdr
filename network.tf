# gateway
resource "openstack_networking_secgroup_v2" "apps" {
  name        = "${var.ENVIRONMENT_NAME}-apps"
  description = "Allow HTTP(S) traffic from any host and interfaces"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_ingress_from_gateway" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${var.INTERNAL_GATEWAY_IPV4}/32"
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "${var.INTERNAL_GATEWAY_IPV4}/32"
  security_group_id = openstack_networking_secgroup_v2.apps.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "${var.INTERNAL_GATEWAY_IPV4}/32"
  security_group_id = openstack_networking_secgroup_v2.apps.id
}
