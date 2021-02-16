## Creating an Azure Service Principal

* Place your Azure Subscription Id into the .env file
* Navigate to the scripts folder
* Run `chmod +x create-az-sp-sh && ./create-az-sp.sh`
* After a while, this script will output a json containing an `appId`, `displayName`, `name`, `password` and `tenant`. Store this values somewhere safe, you will need these later on with the `terraform.tfvars` file to keep secrets.