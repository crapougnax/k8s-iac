#!/usr/bin/env bash
set -euo pipefail

YELLOW="\033[1;33m"
GREEN="\033[0;32m"
NC="\033[0m"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${YELLOW}[WARN]${NC} Undeploying LoRaWAN ChirpStack v4 Stack from namespace 'lorawan'..."
kubectl delete -k "${REPO_ROOT}/k8s/stacks/lorawan/base" --ignore-not-found=true
echo -e "${GREEN}[SUCCESS]${NC} LoRaWAN stack removed."
