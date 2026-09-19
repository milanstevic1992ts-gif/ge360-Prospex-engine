#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_ROOT="${GE360_PROSPEX_ROOT:-/opt/ge360/prospex-engine}"
SRC_DIR="$INSTALL_ROOT/prospex"
ENV_FILE="${GE360_PROSPEX_CONFIG_DIR:-/etc/ge360}/prospex-engine.env"
PURGE="${1:-}"

[[ "${EUID}" -eq 0 ]] || { echo "Esegui con sudo/root" >&2; exit 1; }

if [[ -f "$SRC_DIR/docker-compose.prod.yml" && -f "$ENV_FILE" ]]; then
  if [[ "$PURGE" == "--purge" ]]; then
    docker compose --env-file "$ENV_FILE" -f "$SRC_DIR/docker-compose.prod.yml" down -v
  else
    docker compose --env-file "$ENV_FILE" -f "$SRC_DIR/docker-compose.prod.yml" down
  fi
fi

rm -rf "$INSTALL_ROOT"

if [[ "$PURGE" == "--purge" ]]; then
  rm -f "$ENV_FILE"
  echo "GE360 Prospex rimosso completamente, inclusi volumi e configurazione."
else
  echo "GE360 Prospex rimosso. Configurazione conservata in $ENV_FILE."
  echo "Per eliminare anche dati/configurazione usa: $0 --purge"
fi
