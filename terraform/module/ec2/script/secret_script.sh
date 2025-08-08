#!/bin/bash

# Update and install required tools (Amazon Linux uses yum)
sudo yum update -y
sudo yum install -y aws-cli jq

# Create app directory
mkdir -p /home/ec2-user/colanode

# Set values (Replace these via Terraform interpolation)
SECRET_NAME="${SECRET_NAME}"  # Passed from Terraform for rds
REGION="us-east-1"
ENV_PATH="/home/ec2-user/colanode/.env"

# Fetch secret from Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region "$REGION" \
  --secret-id "$SECRET_NAME" \
  --query SecretString \
  --output text)

# Parse secret using jq
DB_NAME=$(echo "$SECRET_JSON" | jq -r .db_name)
DB_USER=$(echo "$SECRET_JSON" | jq -r .db_username)
DB_PASS=$(echo "$SECRET_JSON" | jq -r .password)

# These should be passed in by Terraform using template interpolation
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"

# === Fetch Valkey secret ===
VALKEY_SECRET_NAME= "${VALKEY_SECRET_NAME}"  # Valkey secret

VALKEY_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$VALKEY_SECRET_NAME" \
  --region "$REGION" \
  --query 'SecretString' \
  --output text)

REDIS_PASSWORD=$(echo $VALKEY_SECRET | jq -r .password)


# Write to .env file
cat <<EOF > "$ENV_PATH"
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT

REDIS_PASSWORD=$REDIS_PASSWORD

EOF

# Set permissions
chown ec2-user:ec2-user "$ENV_PATH"
chmod 600 "$ENV_PATH"
