#!/usr/bin/env bash
set -euo pipefail

missing=()

required_dirs=(
  backend
  backend/microservices
  backend/shared
  backend/api-gateway
  frontend
  ml-models
  infrastructure
  docs
  scripts
  tests
)

required_files=(
  README.md
  .gitignore
  .env.example
  docker-compose.yml
  overview
  backend/pom.xml
  frontend/package.json
  ml-models/requirements.txt
  docs/roadmap.md
  docs/branching.md
  backend/microservices/services.md
  scripts/execute-smartcity.sh
)

for dir in "${required_dirs[@]}"; do
  if [[ ! -d "${dir}" ]]; then
    missing+=("dir:${dir}")
  fi
done

for file in "${required_files[@]}"; do
  if [[ ! -f "${file}" ]]; then
    missing+=("file:${file}")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing required items:"
  printf ' - %s\n' "${missing[@]}"
  exit 1
fi

echo "Repository structure validation passed."
