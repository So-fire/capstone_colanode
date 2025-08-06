#!/bin/bash

# Install tools
sudo apt update -y
sudo apt install -y awscli jq

# Define values
SECRET_NAME="colanode-shared-db-secret"  # Match your Terraform secret name
REGION="us-east-1"                       # Your AWS region
ENV_PATH="/home/ubuntu/colanode/.env"    # Path to save env file for your app

# Fetch the secret
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region "$REGION" \
  --secret-id "$SECRET_NAME" \
  --query SecretString \
  --output text)

# Parse and write to .env
DB_NAME=$(echo "$SECRET_JSON" | jq -r .db_name)
DB_USER=$(echo "$SECRET_JSON" | jq -r .db_username)
DB_PASS=$(echo "$SECRET_JSON" | jq -r .password)

cat <<EOF > "$ENV_PATH"
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
EOF

chown ubuntu:ubuntu "$ENV_PATH"
chmod 600 "$ENV_PATH"
