#!/bin/bash

set -e

# ===== CONFIG =====
AWS_REGION="eu-west-1"
AWS_ACCOUNT_ID="236195543546"
ECR_REPO="carzone-django"
IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest"

EC2_USER="ubuntu"
EC2_IP="54.217.118.232"
PEM_FILE="./terraform/carzone-key-pair.pem"

# ===== BUILD IMAGE =====
echo "Building Docker image..."
docker build --no-cache -t $ECR_REPO:latest .

# ===== LOGIN TO ECR =====
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# ===== TAG IMAGE =====
echo "Tagging image..."
docker tag $ECR_REPO:latest $IMAGE_URI

# ===== PUSH IMAGE =====
echo "Pushing image to ECR..."
docker push $IMAGE_URI

# ===== DEPLOY ON EC2 =====
echo "Deploying on EC2..."
ssh -i "$PEM_FILE" "$EC2_USER@$EC2_IP" << EOF
set -e

echo "Logging in to ECR from EC2..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Pulling latest image..."
docker pull $IMAGE_URI

echo "Restarting containers..."
docker-compose down
docker-compose up -d

echo "Checking containers..."
docker ps

echo "Deployment completed successfully."
EOF

echo "App deployed successfully!"
echo "Open: http://$EC2_IP"