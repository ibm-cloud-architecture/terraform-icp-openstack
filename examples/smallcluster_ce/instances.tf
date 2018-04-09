##################################
## Create Master VM
##################################
resource "openstack_compute_instance_v2" "icpmaster" {
    count       = "${var.master["nodes"]}"
    name        = "${format("${lower(var.instance_name)}-master%01d", count.index + 1) }"
    image_id    = "${var.image_id}"
    image_name  = "${var.image_name}"
    flavor_name = "${var.master["flavor_name"]}"
    key_pair    = "${var.keypair_name}"

    # In this template the Master performs both the functions of Bastion and ICP Boot.
    security_groups = ["default", "icpmaster", "icpbastion", "icpboot"]

    network {
        name = "${var.network_name}"
    }

    user_data = <<EOF
#cloud-config
users:
    - default
    - name: icpdeploy
      groups: [ wheel ]
      sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
      shell: /bin/bash
      ssh-authorized-keys:
        - ${tls_private_key.deploykey.public_key_openssh}
EOF
}

##################################
## Create Proxy VM
##################################
resource "openstack_compute_instance_v2" "icpproxy" {
    count       = "${var.master["nodes"]}"
    name        = "${format("${lower(var.instance_name)}-proxy%01d", count.index + 1) }"
    image_id    = "${var.image_id}"
    image_name  = "${var.image_name}"
    flavor_name = "${var.proxy["flavor_name"]}"
    key_pair    = "${var.keypair_name}"

    security_groups = ["default", "icpproxy", "icpprovisioning"]

    network {
        name = "${var.network_name}"
    }

    user_data = <<EOF
#cloud-config
users:
    - default
    - name: icpdeploy
      groups: [ wheel ]
      sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
      shell: /bin/bash
      ssh-authorized-keys:
        - ${tls_private_key.deploykey.public_key_openssh}
EOF
}


##################################
## Create Management VM
##################################
resource "openstack_compute_instance_v2" "icpmanagement" {
    count       = "${var.management["nodes"]}"
    name        = "${format("${lower(var.instance_name)}-management%01d", count.index + 1) }"
    image_id    = "${var.image_id}"
    image_name  = "${var.image_name}"
    flavor_name = "${var.management["flavor_name"]}"
    key_pair    = "${var.keypair_name}"

    security_groups = ["default", "icpmanagement", "icpprovisioning"]

    network {
        name = "${var.network_name}"
    }

    user_data = <<EOF
#cloud-config
users:
    - default
    - name: icpdeploy
      groups: [ wheel ]
      sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
      shell: /bin/bash
      ssh-authorized-keys:
        - ${tls_private_key.deploykey.public_key_openssh}
EOF
}

##################################
## Create Worker VM
##################################
resource "openstack_compute_instance_v2" "icpworker" {
    count       = "${var.worker["nodes"]}"
    name        = "${format("${lower(var.instance_name)}-worker%01d", count.index + 1) }"
    image_id    = "${var.image_id}"
    image_name  = "${var.image_name}"
    flavor_name = "${var.worker["flavor_name"]}"
    key_pair    = "${var.keypair_name}"

    security_groups = ["default", "icpworker", "icpprovisioning"]

    network {
        name = "${var.network_name}"
    }

    user_data = <<EOF
#cloud-config
users:
    - default
    - name: icpdeploy
      groups: [ wheel ]
      sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
      shell: /bin/bash
      ssh-authorized-keys:
        - ${tls_private_key.deploykey.public_key_openssh}
EOF
}
