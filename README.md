# CloudNative CarZone Platform

A production-style cloud-native Django application deployed on AWS using Docker, Terraform, CI/CD pipelines, and observability tooling.

## Project Overview

CloudNative CarZone Platform is a full-stack DevOps project designed to simulate real-world cloud deployment workflows. The application is containerized using Docker and deployed on AWS infrastructure provisioned with Terraform.

The platform demonstrates practical implementation of:

- Infrastructure as Code (Terraform)
- Docker containerization
- CI/CD automation
- AWS cloud deployment
- Monitoring and observability
- Reverse proxy architecture
- Production-style application deployment

---

# Architecture

## Core Components

- AWS EC2
- Amazon ECR
- Docker & Docker Compose
- Django + Gunicorn
- PostgreSQL
- Nginx Reverse Proxy
- Prometheus
- Grafana
- GitHub Actions / Jenkins
- Terraform

---

# AWS Infrastructure

Terraform provisions:

- VPC
- Public Subnet
- Internet Gateway
- Route Tables
- Security Groups
- EC2 Instance
- IAM Permissions
- Amazon ECR Repository

---

# Application Stack

The application stack runs using Docker Compose on an Ubuntu EC2 instance.

## Containers

| Container | Purpose |
|---|---|
| Nginx | Reverse proxy and request routing |
| Django + Gunicorn | Main web application |
| PostgreSQL | Database service |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboards |

---

# CI/CD Workflow

The CI/CD pipeline automates:

1. Code push to GitHub
2. Docker image build
3. Push image to Amazon ECR
4. SSH deployment to EC2
5. Pull latest Docker image
6. Restart Docker Compose services

---

# Monitoring & Observability

Prometheus collects infrastructure and application metrics.

Grafana visualizes:
- Container health
- CPU usage
- Memory utilization
- Request metrics
- Application uptime

---

# Technologies Used

## Cloud
- AWS EC2
- Amazon ECR
- IAM
- VPC

## DevOps
- Docker
- Docker Compose
- Terraform
- GitHub Actions
- Jenkins

## Backend
- Django
- Gunicorn
- PostgreSQL

## Monitoring
- Prometheus
- Grafana

---

# Project Goals

- Build a production-style cloud deployment
- Learn infrastructure automation
- Implement containerized workloads
- Understand observability practices
- Simulate real DevOps workflows
- Improve cloud engineering skills

---

# Future Improvements

- Kubernetes deployment (EKS/AKS)
- ArgoCD GitOps workflow
- HTTPS with ACM + Load Balancer
- Route53 custom domain
- Auto Scaling
- AWS RDS migration
- Centralized logging stack
- Terraform modules refactor

---

# Screenshots

- Architecture Diagram
- Grafana Dashboard
- CI/CD Pipeline
- Running Containers
- AWS Infrastructure

---

# Author

Vedant Chavan

MSc Cloud Computing  
Cloud & DevOps Enthusiast
