#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$REPO_ROOT/UPSTREAM.lock"

INSTALL_ROOT="${GE360_PROSPEX_ROOT:-/opt/ge360/prospex-engine}"
SRC_DIR="$INSTALL_ROOT/prospex"
ENV_FILE="${GE360_PROSPEX_CONFIG_DIR:-/etc/ge360}/prospex-engine.env"

[[ "${EUID}" -eq 0 ]] || { echo "Esegui con sudo/root" >&2; exit 1; }
[[ -d "$SRC_DIR/.git" ]] || { echo "Prospex non installato: esegui scripts/install.sh" >&2; exit 1; }
[[ -f "$ENV_FILE" ]] || { echo "Configurazione mancante: $ENV_FILE" >&2; exit 1; }

git -C "$SRC_DIR" fetch --tags origin
git -C "$SRC_DIR" reset --hard
git -C "$SRC_DIR" clean -fd
git -C "$SRC_DIR" checkout --detach "$UPSTREAM_COMMIT"

if grep -q 'ENV NEXT_PUBLIC_API_URL=http://api:3001/api' "$SRC_DIR/apps/web/Dockerfile"; then
  sed -i 's|ENV NEXT_PUBLIC_API_URL=http://api:3001/api|ENV NEXT_PUBLIC_API_URL=/api|' "$SRC_DIR/apps/web/Dockerfile"
fi

cp "$REPO_ROOT/config/nginx-ge360.conf" "$SRC_DIR/nginx.conf"
ln -sfn "$ENV_FILE" "$SRC_DIR/.env"

docker compose --env-file "$ENV_FILE" -f "$SRC_DIR/docker-compose.prod.yml" up -d --build
echo "GE360 Prospex aggiornato al commit $UPSTREAM_COMMIT"
