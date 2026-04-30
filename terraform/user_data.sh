#!/bin/bash

set -e

AWS_REGION="${aws_region}"
AWS_ACCOUNT_ID="${aws_account_id}"
ECR_REPO_NAME="${ecr_repo_name}"
SECRET_KEY="${secret_key}"
DB_PASSWORD="${db_password}"

APP_DIR="/home/ubuntu/carzone-prod"
IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:latest"

apt-get update -y

apt-get install -y \
  docker.io \
  docker-compose-plugin \
  awscli

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

mkdir -p $APP_DIR/nginx
cd $APP_DIR

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

cat > docker-compose.yml <<EOF
services:
  web:
    image: $IMAGE_URI
    container_name: carzone_web
    restart: always
    expose:
      - "8000"
    environment:
      DEBUG: "False"
      SECRET_KEY: "$SECRET_KEY"
      ALLOWED_HOSTS: "*"
      DB_NAME: "carzone_db"
      DB_USER: "postgres"
      DB_PASSWORD: "$DB_PASSWORD"
      DB_HOST: "db"
      DB_PORT: "5432"
    depends_on:
      - db

  db:
    image: postgres:15
    container_name: carzone_db
    restart: always
    environment:
      POSTGRES_DB: "carzone_db"
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "$DB_PASSWORD"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  nginx:
    image: nginx:latest
    container_name: carzone_nginx
    restart: always
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - web

volumes:
  postgres_data:
EOF

cat > nginx/default.conf <<EOF
server {
    listen 80;
    server_name _;

    location /static/ {
        proxy_pass http://web:8000/static/;
    }

    location /media/ {
        proxy_pass http://web:8000/media/;
    }

    location / {
        proxy_pass http://web:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

docker compose pull
docker compose up -d