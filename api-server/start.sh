#!/bin/sh
# Onyx API server start script for Railway.
# Waits for Postgres, Redis and OpenSearch, runs the Alembic migrations (upstream does
# the same in its compose command), then serves on port 8080.
set -e

# Fixed settings (upstream compose defaults). Override any of them with a service variable.
export FILE_STORE_BACKEND="${FILE_STORE_BACKEND:-s3}"
export S3_FILE_STORE_BUCKET_NAME="${S3_FILE_STORE_BUCKET_NAME:-onyx-file-store-bucket}"
export AWS_REGION_NAME="${AWS_REGION_NAME:-us-east-1}"
export LOG_LEVEL="${LOG_LEVEL:-info}"
# The code interpreter needs the Docker socket, which Railway does not offer: keep the Python tool off.
export CODE_INTERPRETER_BASE_URL="${CODE_INTERPRETER_BASE_URL-}"

wait_tcp() { # name host port
  python3 - "$@" <<'PY'
import socket, sys, time
name, host, port = sys.argv[1], sys.argv[2], int(sys.argv[3])
deadline = time.time() + 900
while True:
    try:
        socket.create_connection((host, port), timeout=5).close()
        print(f"railway: {name} is reachable at {host}:{port}", flush=True)
        break
    except OSError as e:
        if time.time() > deadline:
            sys.exit(f"railway: gave up waiting for {name} at {host}:{port}: {e}")
        print(f"railway: waiting for {name} at {host}:{port} ({e})", flush=True)
        time.sleep(5)
PY
}

wait_tcp Postgres "${POSTGRES_HOST:-127.0.0.1}" "${POSTGRES_PORT:-5432}"
wait_tcp Redis "${REDIS_HOST:-localhost}" "${REDIS_PORT:-6379}"
wait_tcp OpenSearch "${OPENSEARCH_HOST:-localhost}" "${OPENSEARCH_REST_API_PORT:-9200}"

cd /app
echo "railway: running database migrations (alembic upgrade head)"
alembic upgrade head
echo "railway: starting Onyx API server on port 8080"
exec uvicorn onyx.main:app --host 0.0.0.0 --port 8080
