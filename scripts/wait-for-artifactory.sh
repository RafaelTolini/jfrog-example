#!/usr/bin/env sh
set -eu

ARTIFACTORY_URL="${ARTIFACTORY_URL:-http://localhost:8082}"

printf "Waiting for Artifactory at %s" "$ARTIFACTORY_URL"

until curl -fsS "$ARTIFACTORY_URL/artifactory/api/system/ping" >/dev/null 2>&1; do
  printf "."
  sleep 5
done

printf "\nArtifactory is ready.\n"
