# 🛒 ShopFast – Production-Ready E-Commerce API on AWS EKS

![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=logo=fastapi)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/Amazon_AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F52BA?style=for-the-badge&logo=helm&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**A fully production-grade, auto-deployed FastAPI e-commerce backend running on real AWS EKS**  
Zero-downtime Helm upgrades · GitHub Actions OIDC (zero secrets) · ECR image registry · Public Load Balancer · Automatic on every push

- Zero-downtime rolling deployments  
- Non-root containers  
- Health checks, autoscaling, and basic resilience  
- GitHub → ECR → EKS deployment flow


## Runtime Endpoints (example)

After deploying the Helm chart with `service.type: LoadBalancer`, Kubernetes provisions an AWS ELB.

```bash
kubectl get svc shopfast -n production
# NAME      TYPE           CLUSTER-IP     EXTERNAL-IP                         PORT(S)   AGE
# shopfast  LoadBalancer   172.20.xx.xx  a1b2c3d4e5f6g7h8-123456789.ap-south-1.elb.amazonaws.com   80:xxxxx/TCP   ...


**Live API URL (public on the internet right now!)**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/

**Swagger UI**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/docs

**ReDoc UI**  
🔗 http://a212bc82bcf314e47ba7790ae1bc4113-170866025.ap-south-1.elb.amazonaws.com/redoc

**Root endpoint response**  
```json
{"message":"ShopFast API is LIVE on AWS EKS! Built by coolhead "}
```

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
```
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

```
### GitHub → (OIDC) GitHub Actions → Build & Push Docker Image → ECR → Helm Upgrade → EKS Pods → LoadBalancer Service → Public Internet

### Screenshots
![Live API Root](attachment:live-root-public.png)
![Swagger UI Live](attachment:swagger-public.png)


### Tech Stack

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

#### Run the API locally:
Create virtualenv (optional)
python3 -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

Then open:

http://localhost:8000/ – root

http://localhost:8000/healthz – health check

http://localhost:8000/docs – Swagger UI

http://localhost:8000/redoc – ReDoc

## Deploying to EKS (Summary)

Assuming:

EKS cluster is up

kubectl is pointing to that cluster

ECR repo shopfast-api exists

1. Build & push image

```
IMAGE=234438862191.dkr.ecr.ap-south-1.amazonaws.com/shopfast-api
TAG=nonroot-$(date +%s)

# Build
docker build -t $IMAGE:$TAG .

# Login to ECR (SSO profile)
AWS_PROFILE=sso-tulasiram \
aws ecr get-login-password --region ap-south-1 \
  | docker login --username AWS --password-stdin 234438862191.dkr.ecr.ap-south-1.amazonaws.com

# Push
docker push $IMAGE:$TAG
```
2. Helm install/upgrade

```
helm upgrade --install shopfast ./helm-chart -n production \
  --create-namespace \
  --set image.repository=$IMAGE \
  --set image.tag=$TAG \
  --set image.pullPolicy=Always
```

Wait for rollout:
```
kubectl rollout status deploy/shopfast -n production
kubectl get pods -n production
```

Get ELB DNS:
```
kubectl get svc shopfast -n production
```

Autoscaling:
Once metrics-server is installed and HPA is enabled, you can generate load:
```
kubectl run -n production loadgen --image=rakyll/hey --restart=Never -- \
  -z 90s -c 50 "http://shopfast.production.svc.cluster.local/"

watch -n 5 kubectl get hpa -n production
watch -n 5 kubectl get deploy shopfast -n production
kubectl top pods -n production
```


## Repository Layout
```
shopfast/
├── app/
│   ├── main.py               # FastAPI app entrypoint
│   └── routers/
│       ├── users.py          # /api/v1/users
│       ├── items.py          # /api/v1/items
│       └── health.py         # /healthz, /readyz
├── helm-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml   # non-root pod, probes, resources, volume
│       ├── service.yaml      # LoadBalancer service
│       ├── ingress.yaml      # (ALB-ready, can be enabled later)
│       ├── hpa.yaml          # CPU-based HorizontalPodAutoscaler
│       └── pdb.yaml          # PodDisruptionBudget
├── terraform/                # EKS, nodegroups, networking (IaC)
├── Dockerfile                # multi-stage build for FastAPI
├── requirements.txt
└── README.md
```





#### Author: Raghavendra S 19NOV2025
