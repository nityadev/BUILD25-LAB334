#!/bin/bash
echo "--- ✅ | POST-PROVISIONING: Update RBAC permissions---"
# Use this when pre-provisioning with azd
#   - Refresh env: azd env refresh -e AITOUR
#   - Run this script: bash docs/workshop/0-setup/azd-update-roles.sh
#   - Then run hooks: azd hooks run postprovision
#   - Should update database, index and deploy app

# Exit shell immediately if command exits with non-zero status
set -e
# Load variables from .env file in parent directory into your shell
if [ -f ../.env ]; then
    source ../.env
else
    echo "../.env file not found!"
    exit 1
fi

# -- Get Resource Group
# Parse AZURE_AI_CONNECTION_STRING from .env
if [ -z "$AZURE_AI_CONNECTION_STRING" ]; then
    echo "AZURE_AI_CONNECTION_STRING not set in .env!"
    exit 1
fi

IFS=';' read -r REGION SUBSCRIPTION_ID RESOURCE_GROUP AI_PROJECT <<< "$AZURE_AI_CONNECTION_STRING"
echo "REGION: $REGION"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "RESOURCE_GROUP: $RESOURCE_GROUP"
echo "AI_PROJECT: $AI_PROJECT"



# -------------- Create any additional RBAC roles required -------------------------

# --- See Azure Built-in Roles first for CONTROL plane
# https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

# Get principal id from authenticated account
PRINCIPAL_ID=$(az ad signed-in-user show --query id -o tsv)
echo "PRINCIPAL_ID: $PRINCIPAL_ID"
# Search Index Data Contributor
# Grants full access to Azure Cognitive Search index data.
az role assignment create \
        --role "8ebe5a00-799e-43f5-93ac-243d3dce84a7" \
        --assignee-object-id "${PRINCIPAL_ID}" \
        --scope /subscriptions/"${SUBSCRIPTION_ID}"/resourceGroups/"${RESOURCE_GROUP}" \
        --assignee-principal-type 'User'

# Search Index Data Reader
# Grants read access to Azure Cognitive Search index data.
az role assignment create \
        --role "1407120a-92aa-4202-b7e9-c0e197c71c8f" \
        --assignee-object-id "${PRINCIPAL_ID}" \
        --scope /subscriptions/"${SUBSCRIPTION_ID}"/resourceGroups/"${RESOURCE_GROUP}" \
        --assignee-principal-type 'User'

# Cognitive Services OpenAI User
# Read access to view files, models, deployments. The ability to create completion and embedding calls.
az role assignment create \
        --role "5e0bd9bd-7b93-4f28-af87-19fc36ad61bd" \
        --assignee-object-id "${PRINCIPAL_ID}" \
        --scope /subscriptions/"${SUBSCRIPTION_ID}"/resourceGroups/"${RESOURCE_GROUP}" \
        --assignee-principal-type 'User'


# ------ See CosmosDB built-in roles for DATA plane
# https://aka.ms/cosmos-native-rbac
# Note: Azure CosmosDB data plane roles are distinct from built-in Azure control plane roles
# See: https://learn.microsoft.com/en-us/azure/data-explorer/ingest-data-cosmos-db-connection?tabs=arm#step-2-create-a-cosmos-db-data-connection
# See: infra/core/security/role-cosmos.bicep to understand what we need to set

# Gets account name
COSMOSDB_NAME=$(az cosmosdb list --resource-group ${RESOURCE_GROUP} --query "[0].name" -o tsv)

# Cosmos DB Built-in Data Contributor - grant access to specific db
az cosmosdb sql role assignment create \
        --account-name "${COSMOSDB_NAME}" \
        --resource-group "${RESOURCE_GROUP}" \
        --role-definition-name "Cosmos DB Built-in Data Contributor" \
        --scope "/dbs/contoso-outdoor/colls/customers" \
        --principal-id "${PRINCIPAL_ID}"


# Try this instead recommended by docs --- Data Plane
az cosmosdb sql role assignment create \
        --account-name "${COSMOSDB_NAME}" \
        --resource-group "${RESOURCE_GROUP}" \
        --role-definition-id 00000000-0000-0000-0000-000000000001 \
        --scope "/" \
        --principal-id "${PRINCIPAL_ID}"

echo "--- ✅ | POST-PROVISIONING: RBAC permissions updated---"
