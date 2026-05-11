#!/usr/bin/env sh
set -eu

MASTER_KEY_FILE="artifactory-var/etc/security/master.key"
JOIN_KEY_FILE="artifactory-var/etc/security/join.key"
SYSTEM_YAML_FILE="artifactory-var/etc/system.yaml"

mkdir -p "$(dirname "$MASTER_KEY_FILE")"

create_key() {
  key_file="$1"

  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 16 > "$key_file"
  else
    date "+%s%N" | shasum -a 256 | cut -c 1-32 > "$key_file"
  fi
  chmod 600 "$key_file"
}

if [ ! -f "$MASTER_KEY_FILE" ]; then
  create_key "$MASTER_KEY_FILE"
  printf "Created local Artifactory master key at %s\n" "$MASTER_KEY_FILE"
fi

if [ ! -f "$JOIN_KEY_FILE" ]; then
  create_key "$JOIN_KEY_FILE"
  printf "Created local Artifactory join key at %s\n" "$JOIN_KEY_FILE"
fi

cat > "$SYSTEM_YAML_FILE" <<'YAML'
shared:
  database:
    type: postgresql
    driver: org.postgresql.Driver
    url: jdbc:postgresql://postgres:5432/artifactory
    username: artifactory
    password: password
YAML

printf "Wrote local Artifactory database config to %s\n" "$SYSTEM_YAML_FILE"
