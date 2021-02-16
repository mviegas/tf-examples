AZ_SUBSCRIPTION_ID=$(grep AZ_SUBSCRIPTION_ID .env | cut -d '=' -f2)

az login
az ad sp create-for-rbac -n 'terraform' --role='Contributor' --scopes="/subscriptions/${AZ_SUBSCRIPTION_ID}"