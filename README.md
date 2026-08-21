# Tycho Kubernetes IaC & GitOps Recipes (`k8s-iac`)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.34-326ce5.svg?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Traefik](https://img.shields.io/badge/Traefik-v3.1-24A1C1.svg?logo=traefik&logoColor=white)](https://traefik.io/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-orange.svg?logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-7B42BC.svg?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Arch: ARM64](https://img.shields.io/badge/Arch-ARM64%20%7C%20AMD64-success.svg)](#)

Production-grade, cloud-agnostic **Kubernetes Infrastructure as Code (IaC)** and **GitOps deployment recipes** by **[Tycho](https://github.com/tycho-ops)**.

Designed for high availability, zero-friction automated Let's Encrypt TLS issuance, cloud-native storage persistence, and modular application workload management.

---

## 🏗️ Architecture & Philosophy

```mermaid
graph TD
    subgraph "Layer 1: Multi-Cloud IaC (Terraform)"
        TF[Terraform CLI / CI] --> VPC[VPC & Isolated Private Network]
        TF --> K8s[Managed K8s Cluster (ARM64 / AMD64)]
        TF --> LB[Dual-Stack Load Balancer (IPv4 + IPv6)]
        TF --> DNS[Declarative DNS Management]
        TF --> Storage[Cloud Block Storage CSI]
    end

    subgraph "Layer 2: Core Cluster Ingress & GitOps"
        K8s --> ArgoCD[ArgoCD GitOps Engine]
        K8s --> Traefik[Traefik Ingress v3 + Dashboard]
        K8s --> CertManager[Cert-Manager: Automated Let's Encrypt TLS]
        K8s --> Reloader[Stakater Reloader]
    end

    subgraph "Layer 3: Modular Application Stacks (Options)"
        ArgoCD --> StackLora[LoRaWAN ChirpStack v4 Stack]
        ArgoCD --> StackStudio[Modaka Studio Engine]
        ArgoCD --> StackObs[Observability / Prometheus]
    end
```

---

## ✨ Key Capabilities

- 🚀 **1-Click Cluster Ingress & TLS Bootstrap**: Provision Traefik v3, native IngressClass, Cert-Manager v1.16, ClusterIssuer HTTP-01, and production certificates in a single non-blocking command.
- 🔒 **1-Command SSL Certificate Issuer**: Seamlessly generate valid Let's Encrypt certificates for any subdomain with `./bin/issue-certificate.sh`.
- 🌐 **Cloud-Agnostic Modules**: Reusable Terraform modules for Scaleway (Kapsule ARM64, SBS Block Storage, Flexible IPs) and extensible to Hetzner, AWS, and bare-metal.
- 🧩 **Modular Workload Stacks**: Enable or disable application suites (such as LoRaWAN ChirpStack v4 with PostgreSQL 16 persistence, Redis 7, Mosquitto MQTT, and LoRa Basics™ Station WSS) on demand.
- 🐙 **GitOps Driven (ArgoCD)**: Declarative drift detection, auto-healing, and App-of-Apps management pattern.

---

## ⚡ Quick Start

### 1. Provision Cloud Infrastructure (Scaleway Example)
```bash
cd terraform/environments/scaleway-production
cp terraform.tfvars.dist terraform.tfvars
# Edit terraform.tfvars with your project ID and domain
terraform init
terraform apply
```

### 2. Configure Kubeconfig
```bash
export KUBECONFIG=~/.kube/config-production.yaml
kubectl get nodes -o wide
```

### 3. Bootstrap Ingress, Traefik & TLS
```bash
bun run bootstrap:tls
# or ./bin/bootstrap-cluster-ingress-tls.sh
```

### 4. Deploy Optional Workload Stacks (LoRaWAN Example)
```bash
bun run deploy:lorawan
# or ./bin/deploy-lorawan.sh
```

---

## 📖 Comprehensive Documentation

For end-to-end tutorials, dashboard access credentials setup, certificate troubleshooting, and multi-cloud extension guides, see:
👉 **[HOWTO.md](HOWTO.md)**

---

## 📜 License

GNU Affero General Public License v3.0 (**AGPL-v3**). See [LICENSE](LICENSE) for details.
