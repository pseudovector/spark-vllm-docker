#!/bin/bash
# Start vLLM with Qwen3-Next-80B-A3B-Instruct-FP8 recipe
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/vllm-qwen3-next.log"
mkdir -p "$LOG_DIR"
cd "$SCRIPT_DIR"

nohup ./run-recipe.sh qwen3-next-80b-a3b-instruct-fp8 --solo -d --gpu-mem 0.7 >> "$LOG_FILE" 2>&1 &
sleep 2

if docker ps | grep -q vllm_node; then
    echo "✅ vLLM Qwen3-Next-80B-A3B-Instruct started"
    echo "📝 Logs: $LOG_FILE"
    exit 0
else
    echo "❌ Failed to start Qwen3-Next-80B-A3B-Instruct"
    echo "📝 Check logs: $LOG_FILE"
    exit 1
fi
