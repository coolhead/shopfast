# 🛒 ShopFast – Production-Ready E-Commerce API on AWS EKS

![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=logo=fastapi)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F52BA?style=for-the-badge&logo=helm&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**A fully production-grade, auto-deployed FastAPI e-commerce backend running on real AWS EKS**  
Zero-downtime Helm upgrades · GitHub Actions OIDC (zero secrets) · ECR image registry · Public Load Balancer · Automatic on every push

**Live API URL (public on the internet right now!)**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/

**Swagger UI**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/docs

**ReDoc UI**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/redoc

**Root endpoint**  
```json
{"message":"ShopFast API is LIVE on AWS EKS! Built by coolhead "}


## Features

- Blazing-fast FastAPI backend with proper async support
- Modular router structure (/api/v1/users, /api/v1/items, health checks)
- Production-ready Uvicorn with --host 0.0.0.0 --workers 4
- Full Helm chart with liveness/readiness probes, resource limits, multi-replica deployment
= Zero-downtime upgrades (rolling update strategy)
- GitHub Actions OIDC → ECR → EKS automatic deployment on every push (no AWS keys stored!)
- ECR private registry with latest tag + imagePullPolicy: Always
- Public AWS Classic Load Balancer on standard port 80 (no :8000 needed)
- Proper Kubernetes labels/selectors fixed for service discovery
- Ready for HTTPS, PostgreSQL, Redis, JWT auth, monitoring, etc.

## Architecture Overview

GitHub Repo ──(push)──► GitHub Actions (OIDC)
                             │
                             ▼
                     ECR (Docker image)
                             │
                             ▼
             Helm upgrade → EKS Cluster (production namespace)
                             │
                             ▼
             Pods (2 replicas) ←── Service (LoadBalancer)
                             │
                             ▼
                    Public ELB (internet-facing on port 80)
                             │
                             ▼
                        Your browser / Postman / mobile app




### GitHub → (OIDC) GitHub Actions → Build & Push Docker Image → ECR → Helm Upgrade → EKS Pods → LoadBalancer Service → Public Internet

### Screenshots
![Live API Root](attachment:live-root-public.png)
![Swagger UI Live](attachment:swagger-public.png)


### Tech Stack
```
 __________________________________________________________________
| Layer          | Technology                                      |
|----------------|-------------------------------------------------|
| App            | FastAPI (Python 3.12)                           |
| Container      | Docker (multi-stage, slim image)                |
| Orchestration   | Kubernetes (EKS) + Helm 3                      |
| CI/CD          | GitHub Actions with OIDC (no secrets!)          |
| Registry       | Amazon ECR                                      |
| Infrastructure  | Terraform-provisioned EKS cluster + node group |
| Ingress/Load Balancer | AWS Classic Load Balancer (port 80)      |
| Monitoring     | Ready for Prometheus/Grafana (add later)        |
|__________________________________________________________________|

### Local Development
```bash
# Run locally (hot reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

#### Author: Raghavendra S 19NOV2025
