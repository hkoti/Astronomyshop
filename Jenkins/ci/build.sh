#!/usr/bin/env bash
set -euo pipefail
source ci/common.sh

cd "${SERVICE_DIR}"

if [[ -f "go.mod" ]]; then
  echo "🟦 Go build"
  go build ./...
elif [[ -f "package.json" ]]; then
  echo "🟨 Node build"
  npm install
  npm run build || true
elif [[ -f "pom.xml" ]]; then
  echo "🟥 Maven build"
  mvn clean package -DskipTests
elif [[ -f "build.gradle" || -f "build.gradle.kts" ]]; then
  echo "🟥 Gradle build"
  ./gradlew build -x test
else
  echo "ℹ️ No build step detected, skipping"
fi
