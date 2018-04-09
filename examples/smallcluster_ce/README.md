# Terraform ICP OpenStack CE

This Terraform example configurations uses the [OpenStack provider](https://www.terraform.io/docs/providers/openstack/index.html) to provision virtual machines on OpenStack
and [TerraForm Module ICP Deploy](https://github.com/ibm-cloud-architecture/terraform-module-icp-deploy) to prepare VMs and deploy [IBM Cloud Private](https://www.ibm.com/cloud-computing/products/ibm-cloud-private/) on them.

This template provisions an cluster with ICP 2.1.0.2 community edition.

The templates creates the requested number of VMs.
A new user `icpdeploy` will be created on the newly created VMs and a corresponding SSH key will be created by terraform for the purpose of deployment.

### Pre-requisites

* Working copy of [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* An OpenStack project with a self-service network defined. The network must:
  * Internet access
  * Have access to 2 floating IPs. One for Admin and one for Proxy
  * The floating IP must be reachable from where the terraform template is launched
  * The template is tested on vm images from Ubuntu cloud-images latest [Ubuntu 16.04](http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img) build
* Flavors meeting the suggested sizing requirements must be available [ICP Sizing requirements](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_2.1.0/supported_system_config/hardware_reqs.html)

### Using the Terraform templates

1. git clone or download the templates

1. Create a `terraform.tfvars` file to reflect your environment.  Please see [variables.tf](variables.tf) for variable names and descriptions.  Here are some important ones:

| variable           | default       |required| description                            |
|--------------------|---------------|--------|----------------------------------------|
|openstack_auth_url  |               |Yes      |The endpoint URL used to connect to OpenStack|
|openstack_password  |               |Yes      |The password for the user               |
|openstack_project_name|               |Yes      |The name of the project (a.k.a. tenant) used|
|openstack_domain_name|Default        |Yes      |The domain to be used                   |
|openstack_user_name |               |Yes      |The user name used to connect to OpenStack|
|image_id            |               |No      |Specify either this or image name. This must be used if booting from volume|
|image_name          |               |No      |Specify either this or image id. This can not be used if booting from volume|
|master              |                |Yes      | Definition for number and size of Master VMs                                |
|proxy               |              |Yes     | Definition for number and size of Proxy VMs                                        |
|management          |              |Yes     | Definition for number and size of Management VMs                                       |
|worker              |                |Yes      | Definition for number and size of Proxy VMs                                       |
|network_name        |               |Yes     |The name of the network to deploy to    |
|floating_pool       |               |Yes     |Name of the floating address pool to assign floating addresses from|
|instance_name       |icp            |No      |Name of the deployment. Will be included in instance names|
|icppassword         |               |No      |Initial password for ICP Admin user. Leave blank to generate a random password |
|keypair_name        |               |No      |Name of keypair to add to instance for admin use. Optional as Terraform will generate it's own ssh key for deployment|


### Execute Terraform

1. Run `terraform init` to download depenencies (modules and plugins)

1. Run `cp example-terraform.tfvars terraform.tfvars`

1. Update `terraform.tfvars` with your own details. Inspect [variables.tf](variables.tf) for more information about options and variables.

1. Run `terraform plan` to investigate deployment plan

1. Run `terraform apply` to start deployment
