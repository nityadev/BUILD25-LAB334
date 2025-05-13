#!/bin/bash
echo "--- ✅ | SEARCH SERVICE: Update RBAC permissions---"

# Exit shell immediately if command exits with non-zero status
set -e
# Load variables from .env file in parent directory into your shell
if [ -f .env ]; then
    source .env
else
    echo ".env file not found!"
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

echo "--- ✅ | POST-PROVISIONING: RBAC permissions updated---"
