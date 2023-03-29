resource "openstack_blockstorage_volume_v2" "nextcloud" {
  description = "Nextcloud data volume (${var.name})"
  volume_type = "volumes-ec"
  size        = 50
}

resource "openstack_compute_volume_attach_v2" "nextcloud" {
  instance_id = "${openstack_compute_instance_v2.apps.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.nextcloud.id}"
}
