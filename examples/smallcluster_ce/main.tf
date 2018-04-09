##################################
## Configure the OpenStack Provider
##################################
provider "openstack" {
    user_name   = "${var.openstack_user_name}"
    password    = "${var.openstack_password}"
    tenant_name = "${var.openstack_project_name}"
    domain_name = "${var.openstack_domain_name}"
    auth_url    = "${var.openstack_auth_url}"
    insecure    = true
}

##################################
## Generate a new ssh key if this
## is required for deployment
##################################
resource "tls_private_key" "deploykey" {
  algorithm   = "RSA"
}
