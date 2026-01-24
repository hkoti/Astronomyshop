#!/usr/bin/env bash
set -euo pipefail

source ci/common.sh

if [[ -z "${SONAR_PROJECT_KEY:-}" ]]; then
  echo "❌ SONAR_PROJECT_KEY not set"
  exit 1
fi

if [[ -z "${SONAR_ORG:-}" ]]; then
  echo "❌ SONAR_ORG not set"
  exit 1
fi

echo "🔍 Running SonarCloud scan for ${SERVICE_NAME}"

sonar-scanner \
  -Dsonar.projectKey="${SONAR_PROJECT_KEY}" \
  -Dsonar.organization="${SONAR_ORG}" \
  -Dsonar.projectBaseDir="${SERVICE_DIR}" \
  -Dsonar.sources="." \
  -Dsonar.host.url="https://sonarcloud.io" \
  -Dsonar.login="${SONAR_TOKEN}"
