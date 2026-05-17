#!/usr/bin/env bash
# Firebase Emulator + Flutter 開発環境起動スクリプト
# Usage: bash start_emulator.sh
set -e

export JAVA_HOME=/home/kojima/jdk/jdk-21.0.3+9-jre
export PATH="$JAVA_HOME/bin:/home/kojima/flutter_sdk/flutter/bin:$PATH"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "=== Meshilog Dev Environment ==="
echo "Flutter: $(flutter --version 2>&1 | head -1)"
echo "Java: $(java --version 2>&1 | head -1)"
echo "Firebase CLI: $(firebase --version)"

echo ""
echo "Starting Firebase Emulator Suite..."
cd "$PROJECT_ROOT"

# Start emulator in background
firebase emulators:start \
  --only auth,firestore,storage \
  --project meshilog-dev \
  --import ./emulator_data \
  --export-on-exit ./emulator_data &

EMULATOR_PID=$!
echo "Emulator PID: $EMULATOR_PID"

# Wait for emulator to be ready
echo "Waiting for emulator..."
timeout 30 bash -c 'until curl -s http://localhost:9099 >/dev/null 2>&1; do sleep 1; done' \
  && echo "Auth emulator ready." \
  || echo "Warning: Auth emulator may not be ready yet."

echo ""
echo "=== Emulator UI: http://localhost:4000 ==="
echo "=== Auth: localhost:9099, Firestore: localhost:8080 ==="
echo ""
echo "Run Flutter app with:"
echo "  cd meshilog && flutter run"
echo ""
echo "Press Ctrl+C to stop all services."
wait $EMULATOR_PID
