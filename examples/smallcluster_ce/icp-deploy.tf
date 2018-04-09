##################################
## Generate a random password
##################################
resource "random_string" "password" {
  length = 8
  special = false
}

locals {
  password = "${var.icppassword != "" ? var.icppassword : random_string.password.result }"
}

##################################
## Call the ICP Deployment module
##################################
module "icpprovision" {
    source = "github.com/hassenius/terraform-module-icp-deploy.git?ref=2.1.0"

    icp-master      = ["${openstack_compute_instance_v2.icpmaster.*.network.0.fixed_ip_v4}"]
    icp-worker      = ["${openstack_compute_instance_v2.icpworker.*.network.0.fixed_ip_v4}"]
    icp-proxy       = ["${openstack_compute_instance_v2.icpproxy.*.network.0.fixed_ip_v4}"]
    icp-management  = ["${openstack_compute_instance_v2.icpmanagement.*.network.0.fixed_ip_v4}"]
    bastion_host    = "${openstack_compute_floatingip_v2.master_vip.address}"

    icp-version = "2.1.0.2"

    # image_location = "${var.image_location}"

    /* Workaround for terraform issue #10857
       When this is fixed, we can work this out autmatically */
    cluster_size  = "${var.master["nodes"] + var.worker["nodes"] + var.proxy["nodes"] + var.management["nodes"]}"

    icp_configuration = {
      "network_cidr"                    = "172.17.0.0/16"
      "service_cluster_ip_range"        = "172.16.0.1/24"
      "default_admin_password"          = "${ local.password }"
      "cluster_lb_address"              = "${openstack_compute_floatingip_v2.master_vip.address}"
      "proxy_lb_address"                = "${openstack_compute_floatingip_v2.proxy_vip.address}"
    }

    # We will let terraform generate a new ssh keypair
    # for boot master to communicate with worker and proxy nodes
    # during ICP deployment
    generate_key = true

    # SSH user and key for terraform to connect to newly created OpenStack resources
    ssh_user  = "icpdeploy"
    ssh_key_base64   = "${base64encode(tls_private_key.deploykey.private_key_pem)}"
    ssh_agent = false

}
