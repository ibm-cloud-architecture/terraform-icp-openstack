# Terraform ICP OpenStack

This Terraform example configurations uses the [OpenStack provider](https://www.terraform.io/docs/providers/openstack/index.html) to provision virtual machines on OpenStack
and [TerraForm Module ICP Deploy](https://github.com/ibm-cloud-architecture/terraform-module-icp-deploy) to prepare VMs and deploy [IBM Cloud Private](https://www.ibm.com/cloud-computing/products/ibm-cloud-private/) on them.

There is currently only a single template example located in the [examples/smallcluster_ce](examples/smallcluster_ce) directory, but more will be populated over time.

### Pre-requisits

* Working copy of [Terraform](https://www.terraform.io/intro/getting-started/install.html)

### Using the recipes

1. git clone or download the recipe
1. Update the `variables.tf` or `terraform.tfvars` file to reflect your environment
1. Run `terraform init` to download depenencies (modules and plugins)
1. Run `terraform plan` to investigate deployment plan
1. Run `terraform apply` to start deployment
