#!/usr/bin/env bash
set -euo pipefail

echo "========================================================"
echo "🚀 Scaleway LoRaWAN & Quatrain Account Cutover Assistant"
echo "========================================================"

echo "Step 1: Export DB from source account"
./k8s/bin/backup-chirpstack-db.sh

echo "Step 2: Apply Terraform on target Scaleway account"
echo "Run: cd terraform/environments/production && terraform apply"

echo "Step 3: Switch kubectl context to target Kapsule cluster"
echo "Run: scw k8s kubeconfig get <cluster_id> > ~/.kube/config"

echo "Step 4: Restore DB on target account"
# ./k8s/bin/restore-chirpstack-db.sh <backup_file>

echo "Step 5: Cutover DNS to new Load Balancer Public IP"
echo "========================================================"
