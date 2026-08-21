#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Seamless Ingress, Traefik & Cert-Manager TLS Bootstrap
# Cluster: eu1.paris.qtrn.io / Scaleway Kapsule
# ==============================================================================

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info "Starting seamless Ingress & TLS bootstrap on cluster: $(kubectl config current-context)..."

# 1. Namespaces & StorageClasses
log_info "Step 1/5: Applying common namespaces & Scaleway SBS StorageClasses..."
kubectl apply -k "${REPO_ROOT}/k8s/common"

# 2. Traefik Ingress Controller
log_info "Step 2/5: Deploying Traefik v3 with native IngressClass & HTTP-01 pass-through..."
kubectl apply -k "${REPO_ROOT}/k8s/traefik/base"
kubectl apply -f "${REPO_ROOT}/k8s/traefik/base/traefik-ingressclass.yml"
kubectl apply -f "${REPO_ROOT}/k8s/traefik/base/traefik-redirect-middleware.yml"
kubectl rollout status -n traefik deployment/traefik --timeout=120s
log_success "Traefik Ingress Controller is Ready!"

# 3. Cert-Manager
log_info "Step 3/5: Deploying Cert-Manager v1.16 & Webhook..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
kubectl rollout status -n cert-manager deployment/cert-manager-webhook --timeout=120s
kubectl rollout status -n cert-manager deployment/cert-manager --timeout=120s

# 4. ClusterIssuer
log_info "Step 4/5: Applying Let's Encrypt Production ClusterIssuer..."
kubectl apply -f "${REPO_ROOT}/k8s/cert-manager/base/cluster-issuer-http01.yml"
log_success "ClusterIssuer (letsencrypt-prod) configured!"

# 5. Core Certificates Request & Validation
log_info "Step 5/5: Issuing production SSL certificates..."
kubectl apply -f "${REPO_ROOT}/k8s/lorawan/base/lorawan-certificate.yml"
kubectl apply -f "${REPO_ROOT}/k8s/argocd/argocd-certificate.yml"

log_info "Waiting for Let's Encrypt certificate validation (up to 120s)..."
if kubectl wait --for=condition=Ready certificate/lorawan-tls-cert -n lorawan --timeout=120s 2>/dev/null; then
    log_success "Certificate 'lorawan-tls-cert' is Ready and valid!"
else
    log_warn "Certificate 'lorawan-tls-cert' is still in validation process."
fi

log_success "🎉 Ingress & TLS Bootstrap completed seamlessly!"
