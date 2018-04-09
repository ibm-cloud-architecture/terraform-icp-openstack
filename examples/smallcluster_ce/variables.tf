#########################################################################################


##################################
# Configure the OpenStack Provider
##################################
variable "openstack_user_name" {
    description = "The user name used to connect to OpenStack"
}

variable "openstack_password" {
    description = "The password for the user"
}

variable "openstack_project_name" {
    description = "The name of the project (a.k.a. tenant) used"
}

variable "openstack_domain_name" {
    description = "The domain to be used"
    default = "Default"
}

variable "openstack_auth_url" {
    description = "The endpoint URL used to connect to OpenStack"
}





##################################
# Configure the network details
##################################
variable "network_name" {
    description = "The name of the network to deploy to"
}

variable "floating_pool" {
  description = "Name of the floating address pool to assign floating addresses from"
}
variable "keypair_name" {
    description = "Name of keypair to add to instance for admin use. Optional as Terraform will generate it's own ssh key for deployment"
    default     = ""
}


#################################
##### ICP Instance details ######
#################################
variable "instance_name" {
  description = "Name of the deployment. Will be included in instance names"
  default     = "icp"
}

variable "icppassword" {
  description = "Initial password for ICP Admin user. Leave blank to generate a random one"
  default     = ""
}

variable "image_id" {
  description = "Specify either this or image name. This must be used if booting from volume"
  default     = ""
}

variable "image_name" {
  description = "Specify either this or image id. This can not be used if booting from volume"
  default     = ""
}

variable "master" {
  type = "map"

  default = {
    nodes       = "1"
    flavor_name = "m1.large"
  }
}

variable "proxy" {
  type = "map"

  default = {
    nodes       = "1"
    flavor_name = "m1.small"
  }
}

variable "management" {
  type = "map"

  default = {
    nodes       = "1"
    flavor_name = "m1.large"
  }
}

variable "worker" {
  type = "map"

  default = {
    nodes       = "2"
    flavor_name = "m1.medium"
  }
}
