##################################
## Create the floating IP
##################################
resource "openstack_compute_floatingip_v2" "master_vip" {
  pool = "${var.floating_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "master_vip" {
  floating_ip = "${openstack_compute_floatingip_v2.master_vip.address}"
  instance_id = "${openstack_compute_instance_v2.icpmaster.0.id}"
}

resource "openstack_compute_floatingip_v2" "proxy_vip" {
  pool = "${var.floating_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "proxy_vip" {
  floating_ip = "${openstack_compute_floatingip_v2.proxy_vip.address}"
  instance_id = "${openstack_compute_instance_v2.icpproxy.0.id}"
}
