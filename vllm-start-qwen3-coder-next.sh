#!/bin/bash
# Start vLLM with Qwen3-Coder-Next-FP8 recipe
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/vllm-qwen3-coder-next.log"
mkdir -p "$LOG_DIR"
cd "$SCRIPT_DIR"

nohup ./run-recipe.sh qwen3-coder-next-fp8 --solo -d --gpu-mem 0.8 >> "$LOG_FILE" 2>&1 &
sleep 2

if docker ps | grep -q vllm_node; then
    echo "✅ vLLM Qwen3-Coder-Next started"
    echo "📝 Logs: $LOG_FILE"
    exit 0
else
    echo "❌ Failed to start Qwen3-Coder-Next"
    echo "📝 Check logs: $LOG_FILE"
    exit 1
fi
