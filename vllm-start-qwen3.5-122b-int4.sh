#!/bin/bash
# Start vLLM with Qwen3.5-122B-Int4-AutoRound recipe
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/vllm-qwen3.5-122b-int4.log"
mkdir -p "$LOG_DIR"
cd "$SCRIPT_DIR"

nohup ./run-recipe.sh qwen3.5-122b-int4-autoround --solo --gpu-mem 0.85 --container vllm-node-tf5 >> "$LOG_FILE" 2>&1 &
sleep 2

if docker ps | grep -q vllm-node-tf5; then
    echo "✅ vLLM Qwen3.5-122B-Int4 started"
    echo "📝 Logs: $LOG_FILE"
    exit 0
else
    echo "❌ Failed to start Qwen3.5-122B-Int4"
    echo "📝 Check logs: $LOG_FILE"
    exit 1
fi
