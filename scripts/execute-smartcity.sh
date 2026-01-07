#!/usr/bin/env bash
set -euo pipefail

PHASES=(
  "phase0-setup"
  "phase1-month1-week1-kubernetes"
  "phase1-month1-week2-databases"
  "phase1-month1-week3-messaging"
  "phase1-month1-week4-monitoring"
  "phase1-month2-week1-gateway-user"
  "phase1-month2-week2-iot-notification"
  "phase1-month2-week3-frontend-basic"
  "phase1-month2-week4-integration-testing"
  "phase2-month3-week1-traffic-service"
  "phase2-month3-week2-parking-service"
  "phase2-month3-week3-transit-service"
  "phase2-month3-week4-mobile-apps"
)

for phase in "${PHASES[@]}"; do
  echo "================================================"
  echo "Executing: ${phase}"
  echo "================================================"

  script="./scripts/phases/${phase}.sh"
  if [[ ! -x "${script}" ]]; then
    echo "Missing or non-executable phase script: ${script}"
    exit 1
  fi

  "${script}"
  echo "OK: ${phase} completed"
  echo ""
done

echo "All listed phases completed"
