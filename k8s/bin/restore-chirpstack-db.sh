#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path_to_backup.dump>"
  exit 1
fi

BACKUP_FILE="$1"
echo "🔄 Restoring ChirpStack database from ${BACKUP_FILE}..."

POD_NAME=$(kubectl get pod -n lorawan -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl cp "${BACKUP_FILE}" "lorawan/${POD_NAME}:/tmp/restore.dump"
kubectl exec -n lorawan "${POD_NAME}" -- pg_restore -U chirpstack -d chirpstack -v --clean /tmp/restore.dump
kubectl rollout restart deploy/chirpstack -n lorawan

echo "🎉 ChirpStack database successfully restored and service restarted!"
