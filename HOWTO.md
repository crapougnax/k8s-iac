# Tycho Kubernetes IaC — Complete Installation & Operations Guide

This guide describes the complete, step-by-step procedure to provision, bootstrap, operate, and maintain production Kubernetes clusters and workloads with **Tycho `k8s-iac`**.

---

## 📑 Table of Contents
1. [Prerequisites](#1-prerequisites)
2. [Step 1: Terraform Cloud Infrastructure Provisioning](#2-step-1-terraform-cloud-infrastructure-provisioning)
3. [Step 2: Kubernetes Access Configuration](#3-step-2-kubernetes-access-configuration)
4. [Step 3: 1-Click Ingress & SSL TLS Bootstrap](#4-step-3-1-click-ingress--ssl-tls-bootstrap)
5. [Step 4: Accessing Production Dashboards](#5-step-4-accessing-production-dashboards)
6. [Step 5: Modular Workload Stacks Management](#6-step-5-modular-workload-stacks-management)
7. [Step 6: SSL Certificate Management (1-Command Issuer)](#7-step-6-ssl-certificate-management-1-command-issuer)
8. [Troubleshooting & Recovery](#8-troubleshooting--recovery)

---

## 1. Prerequisites

Ensure you have the following CLI tools installed:
- **Terraform** `>= 1.5.0`
- **kubectl** `>= 1.30`
- **bun** `>= 1.1` (or node/npm)
- Target cloud CLI (e.g. `scw` for Scaleway)

---

## 2. Step 1: Terraform Cloud Infrastructure Provisioning

Navigate to the target environment directory (e.g. `scaleway-production`):

```bash
cd terraform/environments/scaleway-production
cp terraform.tfvars.dist terraform.tfvars
# Edit terraform.tfvars with your credentials and domain
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Resources provisioned:
- **VPC & Private Network**: Dedicated subnets for worker nodes.
- **Flexible Load Balancer IPs**: IPv4 and IPv6 dual-stack.
- **Managed K8s Cluster**: High-performance node pool (e.g. Scaleway Ampere Altra ARM64 `STANDARD2-A2C-8G`).
- **DNS Zone Records**: A-records for root (`@`), wildcards (`*`), and subdomains.

---

## 3. Step 2: Kubernetes Access Configuration

Download or export your Kubeconfig:

```bash
# Example for Scaleway Kapsule:
scw k8s kubeconfig get <cluster-id> region=fr-par > ~/.kube/config-k8s.yaml
export KUBECONFIG=~/.kube/config-k8s.yaml

# Verify nodes
kubectl get nodes -o wide
```

---

## 4. Step 3: 1-Click Ingress & SSL TLS Bootstrap

To install Traefik v3, Cert-Manager v1.16, native IngressClass, ClusterIssuer, and issue the initial production SSL certificates seamlessly:

```bash
tycho k8s bootstrap
# or ./bin/tycho-k8s bootstrap
```

---

## 5. Step 4: Accessing Production Dashboards

### 🧭 A. Traefik Dashboard (v3)
- **Protected URL**: `https://traefik.<your-domain>/dashboard/` *(slash `/` final obligatoire)*
- **Authentication**: BasicAuth middleware configured via Kubernetes Secret `traefik/traefik-dashboard-auth-secret`.
- **Local Port-Forward Alternative**:
  ```bash
  kubectl port-forward -n traefik deployment/traefik 9000:8080
  # Open: http://localhost:9000/dashboard/
  ```

### 🐙 B. ArgoCD GitOps
- **URL**: `https://argocd.<your-domain>`
- **Username**: `admin`
- **Initial Password Retrieval**:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
  ```

---

## 6. Step 5: Modular Workload Stacks Management

Application workloads are decoupled into self-contained modular stacks:

### 📡 LoRaWAN ChirpStack v4 Stack
Includes ChirpStack v4, LoRa Basics™ Station WSS gateway bridge, Eclipse Mosquitto MQTT, PostgreSQL 16 on 20Gi CSI Block Storage, and Redis 7.

```bash
# Deploy:
tycho k8s deploy lorawan
# or ./bin/tycho-k8s deploy lorawan

# Undeploy:
tycho k8s undeploy lorawan
# or ./bin/tycho-k8s undeploy lorawan
```

---

## 7. Step 6: SSL Certificate Management (1-Command Issuer)

To issue a valid Let's Encrypt production SSL certificate for any new domain or subdomain in 1 command:

```bash
tycho k8s cert <domain> <namespace> [secret_name]
```

**Examples:**
```bash
tycho k8s cert argocd.example.com argocd argocd-server-tls
tycho k8s cert eu1.lorawan.example.com lorawan lorawan-tls
tycho k8s cert api.example.com default api-tls
```

---

## 8. Troubleshooting & Recovery

### In-Cluster ACME Challenges
```bash
kubectl get challenge -A
kubectl describe challenge -n <namespace>
```

### Certificate Status Audit
```bash
kubectl get cert -A
```
