# LLM Agent Instructions & Guidelines — Tycho k8s-iac

> **Audience**: AI Coding Agents & Human Pair Programming  
> **Platform**: Multi-Cloud Kubernetes (Kapsule, EKS, Bare-metal) + Terraform + Traefik v3 + ArgoCD  
> **Repository**: `tycho-ops/k8s-iac` | **License**: AGPL-v3

---

## 🧭 1. Base Guidelines & Primary Hierarchy

All AI coding agents interacting with this workspace **MUST** strictly load and adhere to the author's primary development rules, GitFlow protocol, and 3-tier forking architecture defined in:
👉 **[Author's Global AI Rules, Architecture Standards & GitFlow Protocol (AGENTS.md)](https://gist.github.com/crapougnax/47971b85aa73dd702f4372a89858111c)**

---

## 🏗️ 2. Project-Specific Architecture & Guidelines

### A. Multi-Cloud & Cloud-Agnostic IaC
- **Modular Terraform Structure:** All provider-specific code must reside under `terraform/modules/<provider>/` (e.g. `scaleway/`, `hetzner/`, `aws/`).
- **Zero Hardcoded Secrets:** Never commit real API keys, tokens, or tenant IDs. Always provide sanitized `terraform.tfvars.dist` and `.env.dist` templates.
- **Fail-Fast IaC:** Never rely on implicit code fallbacks. All infrastructure parameters must be declared explicitly in deployment files.

### B. Ingress, TLS & Routing Standards (Traefik v3 + Cert-Manager)
- **Native IngressClass:** Always use `IngressClass: traefik` and declare it on `ClusterIssuer` HTTP-01 solvers.
- **HTTP-01 ACME Pass-Through:** Do not configure unconditional HTTP-to-HTTPS redirect on port 80 at the CLI level, as it breaks ACME challenge self-checks. Use path routing or Traefik middlewares for HTTPS enforcement.
- **Isolated Domain Certificates:** Never combine multiple distinct domain names into overlapping `Certificate` resources to prevent concurrent ACME order collisions.

### C. CLI Orchestration (`tycho k8s`)
- **CLI Commands:** All cluster operations must be exposed via the unified `tycho k8s` CLI interface (`bin/tycho-k8s`):
  - `tycho k8s bootstrap`: 1-Click Ingress & TLS bootstrap.
  - `tycho k8s cert <domain> [ns] [secret]`: 1-Command Let's Encrypt SSL certificate issuer.
  - `tycho k8s deploy <stack>`: Deploy modular application stacks (`lorawan`, `studio`, etc.).
  - `tycho k8s status`: Cluster health and certificate status audit.

### D. Modular Workload Stacks
- Workload applications (e.g. LoRaWAN ChirpStack v4, Modaka Studio) must be placed in self-contained directories under `k8s/stacks/<stack-name>/`.
- Every stack must support independent lifecycle management (deploy / undeploy).

---

## 🛠️ 3. Essential Verification Commands

| Action | Command |
| :--- | :--- |
| **Validate Terraform Formatting** | `terraform fmt -check -recursive terraform/` |
| **Validate Kustomize Manifests** | `kubectl kustomize k8s/traefik/base > /dev/null` |
| **Check Cluster & Certificate Status** | `./bin/tycho-k8s status` |
