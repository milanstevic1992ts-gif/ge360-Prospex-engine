#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"
PKG="ge360-prospex-engine"
BUILD_DIR="$ROOT_DIR/build/deb"
PKG_ROOT="$BUILD_DIR/root"
OUT_DIR="$ROOT_DIR/dist"
LIB_DIR="$PKG_ROOT/usr/lib/ge360-prospex-engine"
BIN_DIR="$PKG_ROOT/usr/bin"

rm -rf "$BUILD_DIR"
mkdir -p "$PKG_ROOT/DEBIAN" "$LIB_DIR/scripts" "$LIB_DIR/config" "$BIN_DIR" "$OUT_DIR"

cp "$ROOT_DIR/UPSTREAM.lock" "$LIB_DIR/"
cp "$ROOT_DIR/THIRD_PARTY_NOTICES.md" "$LIB_DIR/"
cp "$ROOT_DIR/config/"* "$LIB_DIR/config/"
cp "$ROOT_DIR/scripts/"*.sh "$LIB_DIR/scripts/"
chmod 0755 "$LIB_DIR/scripts/"*.sh

cat > "$PKG_ROOT/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Maintainer: GE360
Depends: bash, git, openssl, ca-certificates
Suggests: docker.io
Description: GE360 wrapper and lifecycle manager for Prospex
 Installs a lightweight GE360 integration layer for the upstream Prospex
 lead-generation platform. Prospex itself is fetched from its MIT-licensed
 upstream repository at a pinned commit during engine installation.
EOF

cat > "$PKG_ROOT/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
echo "GE360 Prospex Engine installato."
echo "Per installare e avviare Prospex: sudo ge360-prospex-install"
exit 0
EOF
chmod 0755 "$PKG_ROOT/DEBIAN/postinst"

make_wrapper() {
  local name="$1"
  local script="$2"
  cat > "$BIN_DIR/$name" <<EOF
#!/usr/bin/env bash
exec bash /usr/lib/ge360-prospex-engine/scripts/$script "\$@"
EOF
  chmod 0755 "$BIN_DIR/$name"
}

make_wrapper ge360-prospex-install install.sh
make_wrapper ge360-prospex-update update.sh
make_wrapper ge360-prospex-status status.sh
make_wrapper ge360-prospex-uninstall uninstall.sh

dpkg-deb --root-owner-group --build "$PKG_ROOT" "$OUT_DIR/${PKG}_${VERSION}_all.deb"
echo "Creato: $OUT_DIR/${PKG}_${VERSION}_all.deb"
