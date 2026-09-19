#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_ROOT="${GE360_PROSPEX_ROOT:-/opt/ge360/prospex-engine}"
SRC_DIR="$INSTALL_ROOT/prospex"
ENV_FILE="${GE360_PROSPEX_CONFIG_DIR:-/etc/ge360}/prospex-engine.env"

[[ -d "$SRC_DIR" ]] || { echo "GE360 Prospex non risulta installato."; exit 1; }
[[ -f "$ENV_FILE" ]] || { echo "Configurazione mancante: $ENV_FILE"; exit 1; }

set -a
source "$ENV_FILE"
set +a

docker compose --env-file "$ENV_FILE" -f "$SRC_DIR/docker-compose.prod.yml" ps

echo
echo "Health:"
if command -v curl >/dev/null 2>&1; then
  curl -fsS "http://127.0.0.1:${HTTP_PORT:-8788}/api/health" && echo
else
  echo "curl non installato; health HTTP non verificato."
fi
