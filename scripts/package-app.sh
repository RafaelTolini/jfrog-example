#!/usr/bin/env sh
set -eu

mkdir -p dist

tar \
  --exclude="./dist" \
  --exclude="./node_modules" \
  --exclude="./.git" \
  -czf dist/jfrog-example.tar.gz \
  package.json package-lock.json src test Dockerfile README.md

printf "Created dist/jfrog-example.tar.gz\n"
