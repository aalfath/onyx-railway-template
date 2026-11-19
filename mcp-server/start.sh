#!/bin/sh
# Onyx MCP server start script for Railway.
set -e
export MCP_SERVER_ENABLED="${MCP_SERVER_ENABLED:-true}"
export MCP_SERVER_PORT="${MCP_SERVER_PORT:-8090}"
export API_SERVER_PROTOCOL="${API_SERVER_PROTOCOL:-http}"
export LOG_LEVEL="${LOG_LEVEL:-info}"
# The code interpreter needs the Docker socket, which Railway does not offer: keep the Python tool off.
export CODE_INTERPRETER_BASE_URL="${CODE_INTERPRETER_BASE_URL-}"
cd /app
if [ "$MCP_SERVER_ENABLED" != "true" ] && [ "$MCP_SERVER_ENABLED" != "True" ]; then
  echo "railway: MCP server is disabled (MCP_SERVER_ENABLED=$MCP_SERVER_ENABLED), idling"
  exec sleep infinity
fi
echo "railway: starting Onyx MCP server on port $MCP_SERVER_PORT"
exec python -m onyx.mcp_server_main
