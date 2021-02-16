# Terraform Examples

This repo is a collection of Terraform scripts for study purposes.

## Azure App Service for Containers w/ Blue-Green Deployments

This boilerplate creates a Web App for Containers w/ a Staging Slot for Blue-Green Deployments.

### Creating an Azure Service Principal

This is required for interacting with an Azure Subscription through the ARM provider.

* Place your Azure Subscription Id into the .env file (there is a .env.example copy).
* Navigate to the scripts folder.
* Run `chmod +x create-az-sp-sh && ./create-az-sp.sh`.
* After a while, this script will output a json containing an `appId`, `displayName`, `name`, `password` and `tenant`. Store this values under the `src/tf-az-blue-green/terraform.tfvars` file to keep secrets. This file is git ignored and contains sensitive values.

### Setting up

* Navigate to the `src/tf-az-blue-green` folder.
* Under the `terraform.tfvars` file place the `container_image` variable with an image of your choice, like `nginx:latest` for instance.
* Run `tf plan` to check the configuration that will be created and if everythings is right.
    * On this step, the `sku_size` var will be required to be prompted, if not setted on the `terraform.tfvars` file.
* Create your App Service for Containers with `tf apply`.
    * On this step, the `sku_size` var will be required to be prompted, if not setted on the `terraform.tfvars` file.