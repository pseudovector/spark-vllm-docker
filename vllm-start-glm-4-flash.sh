#!/bin/bash
# Start vLLM with GLM-4.7-Flash-AWQ recipe
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/vllm-glm-4-flash.log"
mkdir -p "$LOG_DIR"
cd "$SCRIPT_DIR"

nohup ./run-recipe.sh glm-4.7-flash-awq --solo -d --gpu-mem 0.6 >> "$LOG_FILE" 2>&1 &
sleep 2

if docker ps | grep -q vllm_node; then
    echo "✅ vLLM GLM-4.7-Flash started"
    echo "📝 Logs: $LOG_FILE"
    exit 0
else
    echo "❌ Failed to start GLM-4.7-Flash"
    echo "📝 Check logs: $LOG_FILE"
    exit 1
fi
