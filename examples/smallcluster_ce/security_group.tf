##################################
## Create the Security Groups
##################################
resource "openstack_networking_secgroup_v2" "icpmaster" {
  name        = "icpmaster"
  description = "Security Group for ICP Masters"
}

resource "openstack_networking_secgroup_v2" "icpworker" {
  name        = "icpworker"
  description = "Security Group for ICP Workers"
}

resource "openstack_networking_secgroup_v2" "icpproxy" {
  name        = "icpproxy"
  description = "Security Group for ICP Proxies"
}

resource "openstack_networking_secgroup_v2" "icpmanagement" {
  name        = "icpmanagement"
  description = "Security Group for ICP Managers"
}

resource "openstack_networking_secgroup_v2" "icpbastion" {
  name        = "icpbastion"
  description = "Security Group for ICP Bastion host for deployment"
}

resource "openstack_networking_secgroup_v2" "icpboot" {
  name        = "icpboot"
  description = "Security Group for ICP Boot node"
}

resource "openstack_networking_secgroup_v2" "icpprovisioning" {
  name        = "icpprovisioning"
  description = "Security Group needed for ICP provisioning"
}

##########################################
#### Create the Security Group Rules #####
##########################################


##################################
## Rules for needed for provisioning
##################################
#
# Bastion is used to proxy ssh connections when terraform cannot SSH all VMs directly.
# Allow external (terraform client) to connect to bastion host, and bastion to connect to all other hosts
# Also the ICP Boot node uses SSH and Ansible to provision ICP Resources

resource "openstack_networking_secgroup_rule_v2" "sshtobastion" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpbastion.id}"
}

resource "openstack_networking_secgroup_rule_v2" "sshfrombastion" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = "${openstack_networking_secgroup_v2.icpbastion.id}"
  security_group_id = "${openstack_networking_secgroup_v2.icpprovisioning.id}"
}

resource "openstack_networking_secgroup_rule_v2" "sshfromicpboot" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = "${openstack_networking_secgroup_v2.icpboot.id}"
  security_group_id = "${openstack_networking_secgroup_v2.icpprovisioning.id}"
}


##################################
## Rules for Master nodes
##################################

resource "openstack_networking_secgroup_rule_v2" "icpconsole" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8443
  port_range_max    = 8443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpmaster.id}"
}

###### You can change this rule if you only want workers and some other nodes to access the private repo.
resource "openstack_networking_secgroup_rule_v2" "imagerepo" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8500
  port_range_max    = 8500
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpmaster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "k8ssecure" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8001
  port_range_max    = 8001
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpmaster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "k8sauth" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9443
  port_range_max    = 9443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpmaster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "allmaster" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = "${openstack_networking_secgroup_v2.icpmaster.id}"
  security_group_id = "${openstack_networking_secgroup_v2.icpmaster.id}"
}


##################################
## Rules for Worker nodes
##################################
resource "openstack_networking_secgroup_rule_v2" "allworker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = "${openstack_networking_secgroup_v2.icpworker.id}"
  security_group_id = "${openstack_networking_secgroup_v2.icpworker.id}"
}


resource "openstack_networking_secgroup_rule_v2" "allproxy" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = "${openstack_networking_secgroup_v2.icpproxy.id}"
  security_group_id = "${openstack_networking_secgroup_v2.icpworker.id}"
}


##################################
## Rules for Proxy nodes
##################################
resource "openstack_networking_secgroup_rule_v2" "allowalltcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.icpworker.id}"
}
