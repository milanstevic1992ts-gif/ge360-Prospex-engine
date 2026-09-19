#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$REPO_ROOT/UPSTREAM.lock"

INSTALL_ROOT="${GE360_PROSPEX_ROOT:-/opt/ge360/prospex-engine}"
SRC_DIR="$INSTALL_ROOT/prospex"
CONFIG_DIR="${GE360_PROSPEX_CONFIG_DIR:-/etc/ge360}"
ENV_FILE="$CONFIG_DIR/prospex-engine.env"

fail() { echo "[GE360 Prospex] ERRORE: $*" >&2; exit 1; }
info() { echo "[GE360 Prospex] $*"; }

[[ "${EUID}" -eq 0 ]] || fail "esegui con sudo/root"

for cmd in git docker openssl; do
  command -v "$cmd" >/dev/null 2>&1 || fail "manca il comando: $cmd"
done

docker compose version >/dev/null 2>&1 || fail "Docker Compose plugin non disponibile"

mkdir -p "$INSTALL_ROOT" "$CONFIG_DIR"

if [[ ! -d "$SRC_DIR/.git" ]]; then
  info "Clono Prospex upstream..."
  git clone "$UPSTREAM_REPO" "$SRC_DIR"
else
  info "Prospex già presente, aggiorno i riferimenti upstream..."
  git -C "$SRC_DIR" fetch --tags origin
fi

git -C "$SRC_DIR" reset --hard >/dev/null
git -C "$SRC_DIR" clean -fd >/dev/null
git -C "$SRC_DIR" checkout --detach "$UPSTREAM_COMMIT"

# Patch GE360: il frontend deve chiamare /api tramite il reverse proxy,
# non l'hostname Docker interno "api".
if grep -q 'ENV NEXT_PUBLIC_API_URL=http://api:3001/api' "$SRC_DIR/apps/web/Dockerfile"; then
  sed -i 's|ENV NEXT_PUBLIC_API_URL=http://api:3001/api|ENV NEXT_PUBLIC_API_URL=/api|' "$SRC_DIR/apps/web/Dockerfile"
fi

cp "$REPO_ROOT/config/nginx-ge360.conf" "$SRC_DIR/nginx.conf"

if [[ ! -f "$ENV_FILE" ]]; then
  info "Genero configurazione e segreti locali..."
  POSTGRES_PASSWORD="$(openssl rand -hex 24)"
  REDIS_PASSWORD="$(openssl rand -hex 24)"
  JWT_SECRET="$(openssl rand -base64 48 | tr -d '\n')"
  ENCRYPTION_KEY="$(openssl rand -base64 32 | tr -d '\n')"

  umask 077
  cat > "$ENV_FILE" <<EOF
POSTGRES_USER=prospex
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=prospex
REDIS_PASSWORD=$REDIS_PASSWORD
JWT_SECRET=$JWT_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY
OPENAI_API_KEY=
OPENAI_MODEL=gpt-4o-mini
OPENAI_BASE_URL=
APP_URL=http://localhost:8788
API_URL=/api
HTTP_PORT=8788
HTTPS_PORT=8790
EOF
fi

ln -sfn "$ENV_FILE" "$SRC_DIR/.env"

info "Costruisco e avvio Prospex..."
docker compose   --env-file "$ENV_FILE"   -f "$SRC_DIR/docker-compose.prod.yml"   up -d --build

info "Installazione completata."
info "Dashboard: http://localhost:8788"
info "API docs:  http://localhost:8788/api/docs"
