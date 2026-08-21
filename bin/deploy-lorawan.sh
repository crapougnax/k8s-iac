#!/usr/bin/env bash
set -euo pipefail

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info "================================================================="
log_info "Deploying Optional Workload: LoRaWAN ChirpStack v4 Stack"
log_info "Cluster: $(kubectl config current-context) | Namespace: lorawan"
log_info "================================================================="

# 1. Apply manifests
log_info "Applying Kubernetes manifests (Postgres, Redis, Mosquitto, Gateway Bridge, ChirpStack)..."
kubectl apply -k "${REPO_ROOT}/k8s/stacks/lorawan/base"

# 2. Wait for rollouts
log_info "Waiting for PostgreSQL 16 (on Scaleway SBS 20Gi PVC)..."
kubectl rollout status -n lorawan deployment/postgres --timeout=180s

log_info "Waiting for Redis 7 & Mosquitto MQTT..."
kubectl rollout status -n lorawan deployment/redis --timeout=120s
kubectl rollout status -n lorawan deployment/mosquitto --timeout=120s

log_info "Waiting for ChirpStack Gateway Bridge (LoRa Basics Station WSS)..."
kubectl rollout status -n lorawan deployment/gateway-bridge --timeout=120s

log_info "Waiting for ChirpStack v4 Application & Network Server..."
kubectl rollout status -n lorawan deployment/chirpstack --timeout=120s

log_success "🎉 LoRaWAN ChirpStack v4 Stack is 100% RUNNING and Healthy!"
log_info "-----------------------------------------------------------------"
log_info "🌐 ChirpStack Web UI: https://eu1.lorawan.qtrn.io"
log_info "📡 Basics Station WSS: wss://eu1.lorawan.qtrn.io/traffic"
log_info "📡 MQTT Broker:        tcp://mosquitto.lorawan.svc.cluster.local:1883"
log_info "🐘 PostgreSQL Storage: postgres://chirpstack:chirpstack@postgres.lorawan.svc.cluster.local:5432/chirpstack"
log_info "-----------------------------------------------------------------"
