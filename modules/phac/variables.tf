variable "cluster_name" {
  type        = string
  description = "The name of the PostgreSQL Highly Available Cluster (PHAC)"
}

variable "cluster_secgroup" {
  type        = any
  description = "An instance of an openstack_networking_secgroup_v2 resource"
}

variable "key_pair" {
  type = string
}
