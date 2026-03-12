#!/usr/bin/env python3
"""
Tools API Server - Runs on host, exposes tools via HTTP
Allows containerized apps to execute tools on the host safely
"""

from flask import Flask, request, jsonify
import subprocess
import os

app = Flask(__name__)

# Configure allowed commands (whitelist for security)
ALLOWED_COMMANDS = {
    "ls", "pwd", "whoami", "date", "df", "free", "uptime",
    "cat", "head", "tail", "grep", "find", "ps"
}

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/execute', methods=['POST'])
def execute():
    """Execute a shell command on the host"""
    data = request.json
    command = data.get('command', '')

    # Security: Check if command is allowed
    cmd_parts = command.split()
    if not cmd_parts or cmd_parts[0] not in ALLOWED_COMMANDS:
        return jsonify({
            "error": f"Command not allowed. Allowed: {', '.join(ALLOWED_COMMANDS)}"
        }), 403

    try:
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            timeout=10,
            cwd=os.path.expanduser('~')
        )

        return jsonify({
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode
        })
    except subprocess.TimeoutExpired:
        return jsonify({"error": "Command timeout"}), 408
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/read_file', methods=['POST'])
def read_file():
    """Read a file from the host"""
    data = request.json
    file_path = data.get('path', '')

    # Security: Restrict to home directory
    abs_path = os.path.abspath(os.path.expanduser(file_path))
    home = os.path.expanduser('~')

    if not abs_path.startswith(home):
        return jsonify({"error": "Access denied"}), 403

    try:
        with open(abs_path, 'r') as f:
            content = f.read()
        return jsonify({"content": content})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/write_file', methods=['POST'])
def write_file():
    """Write a file on the host"""
    data = request.json
    file_path = data.get('path', '')
    content = data.get('content', '')

    # Security: Restrict to home directory
    abs_path = os.path.abspath(os.path.expanduser(file_path))
    home = os.path.expanduser('~')

    if not abs_path.startswith(home):
        return jsonify({"error": "Access denied"}), 403

    try:
        with open(abs_path, 'w') as f:
            f.write(content)
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("🔧 Tools API Server starting...")
    print("📍 Listening on http://0.0.0.0:5555")
    print("⚠️  Security: Only whitelisted commands allowed")
    print(f"✅ Allowed commands: {', '.join(ALLOWED_COMMANDS)}")
    app.run(host='0.0.0.0', port=5555, debug=False)
