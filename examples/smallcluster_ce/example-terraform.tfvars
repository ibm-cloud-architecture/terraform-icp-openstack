############################################################
############################################################
###
### Example terraform.tfvars file
##
##  To use this template, copy this file to terraform.tfvars
##  and update with your own values
##
############################################################
############################################################


##############################
## OpenStack configuration
##############################
# The endpoint URL used to connect to OpenStack
openstack_auth_url      = ""

# The openstack username to authenticate as
openstack_user_name     = ""

# The password for the user specified above
openstack_password      = ""

# The openstack project aka tenant to authenticate and deploy to
openstack_project_name  = ""

# Uncomment this line if your domain is different from "Default"
# openstack_domain_name = ""


############################
## Network configuration
############################
# The pool to allocate floating ip addresses for admin and proxy access
floating_pool = ""

# The name of the network. It is assumed this exists and is a self-service network
network_name  = ""

############################
## VM Configuration
############################
# The name of the image to provision VMs from. Tested on Ubuntu 16.04, but RHEL and others should also work.
image_name    = ""

# The template generates it's own user and ssh key for deployment.
# If you want to be able to SSH to the instance, provide an existing key pair name here
keypair_name  = ""

# Update each node type to correspond with your own available flavor_name
master = {
  flavor_name = "m1.large"
}
