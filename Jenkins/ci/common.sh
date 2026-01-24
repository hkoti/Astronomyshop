#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SERVICE_NAME:-}" ]]; then
  echo "❌ SERVICE_NAME is not set"
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
SERVICE_DIR="${REPO_ROOT}/src/${SERVICE_NAME}"

if [[ ! -d "${SERVICE_DIR}" ]]; then
  echo "❌ Service directory not found: ${SERVICE_DIR}"
  exit 1
fi

export SERVICE_DIR
echo "✅ Service selected: ${SERVICE_NAME}"
echo "📁 Service directory: ${SERVICE_DIR}"
