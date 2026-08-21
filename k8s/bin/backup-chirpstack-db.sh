#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="chirpstack_$(date +%Y%m%d_%H%M%S).dump"
echo "📦 Backing up ChirpStack PostgreSQL database to ${BACKUP_FILE}..."

POD_NAME=$(kubectl get pod -n lorawan -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n lorawan "${POD_NAME}" -- pg_dump -U chirpstack -d chirpstack -F c -b -v -f /tmp/backup.dump
kubectl cp "lorawan/${POD_NAME}:/tmp/backup.dump" "./${BACKUP_FILE}"

echo "✅ Backup successfully saved to ./${BACKUP_FILE}"
