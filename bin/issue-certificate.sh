#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Automated One-Command Certificate Generator for Let's Encrypt on Traefik
# Usage: ./bin/issue-certificate.sh <domain> <namespace> [secret_name]
# Example: ./bin/issue-certificate.sh api.eu1.paris.qtrn.io backoffice api-tls
# ==============================================================================

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <domain> <namespace> [secret_name]"
    echo "Example: $0 api.eu1.paris.qtrn.io default api-tls"
    exit 1
fi

DOMAIN="$1"
NAMESPACE="$2"
SECRET_NAME="${3:-${DOMAIN//./-}-tls}"
CERT_NAME="${DOMAIN//./-}-cert"

echo -e "${BLUE}[INFO]${NC} Requesting Let's Encrypt certificate for ${DOMAIN} in namespace ${NAMESPACE}..."

kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${CERT_NAME}
  namespace: ${NAMESPACE}
spec:
  secretName: ${SECRET_NAME}
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: ${DOMAIN}
  dnsNames:
    - ${DOMAIN}
EOF

echo -e "${BLUE}[INFO]${NC} Waiting for Let's Encrypt validation..."
if kubectl wait --for=condition=Ready "certificate/${CERT_NAME}" -n "${NAMESPACE}" --timeout=120s; then
    echo -e "${GREEN}[SUCCESS]${NC} Certificate ${DOMAIN} is READY! Stored in secret '${SECRET_NAME}'."
else
    echo -e "${YELLOW}[WARN]${NC} Certificate request submitted. Check status with: kubectl describe certificate ${CERT_NAME} -n ${NAMESPACE}"
fi
