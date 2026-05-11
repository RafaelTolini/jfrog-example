#!/usr/bin/env sh
set -eu

ARTIFACTORY_URL="${ARTIFACTORY_URL:-http://localhost:8082}"
ARTIFACTORY_USER="${ARTIFACTORY_USER:-admin}"
ARTIFACTORY_PASSWORD="${ARTIFACTORY_PASSWORD:-password}"
REPO_NAME="${REPO_NAME:-example-repo-local}"
BUILD_NAME="${BUILD_NAME:-jfrog-example}"
BUILD_NUMBER="${BUILD_NUMBER:-local-1}"
PACKAGE_FILE="dist/jfrog-example.tar.gz"

if [ ! -f "$PACKAGE_FILE" ]; then
  ./scripts/package-app.sh
fi

./scripts/wait-for-artifactory.sh

printf "Uploading %s...\n" "$PACKAGE_FILE"
curl -fsS \
  -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" \
  -T "$PACKAGE_FILE" \
  "$ARTIFACTORY_URL/artifactory/$REPO_NAME/jfrog-example/$BUILD_NUMBER/jfrog-example.tar.gz;build.name=$BUILD_NAME;build.number=$BUILD_NUMBER" \
  >/dev/null

printf "\nPublished successfully.\n"
printf "Artifact: %s/artifactory/%s/jfrog-example/%s/jfrog-example.tar.gz\n" "$ARTIFACTORY_URL" "$REPO_NAME" "$BUILD_NUMBER"
printf "UI:       %s/ui/repos/tree/General/%s/jfrog-example/%s\n" "$ARTIFACTORY_URL" "$REPO_NAME" "$BUILD_NUMBER"
