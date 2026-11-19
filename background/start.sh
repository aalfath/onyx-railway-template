#!/bin/sh
# Onyx background workers start script for Railway.
# Waits until the API server answers /health (so the database migrations have run),
# then starts supervisord with all Celery workers and the beat scheduler.
set -e

export FILE_STORE_BACKEND="${FILE_STORE_BACKEND:-s3}"
export S3_FILE_STORE_BUCKET_NAME="${S3_FILE_STORE_BUCKET_NAME:-onyx-file-store-bucket}"
export AWS_REGION_NAME="${AWS_REGION_NAME:-us-east-1}"
export API_SERVER_PROTOCOL="${API_SERVER_PROTOCOL:-http}"
export LOG_LEVEL="${LOG_LEVEL:-info}"
# The code interpreter needs the Docker socket, which Railway does not offer: keep the Python tool off.
export CODE_INTERPRETER_BASE_URL="${CODE_INTERPRETER_BASE_URL-}"

python3 - <<'PY'
import os, sys, time, urllib.request
url = f"{os.environ.get('API_SERVER_PROTOCOL', 'http')}://{os.environ.get('API_SERVER_HOST', '127.0.0.1')}:8080/health"
deadline = time.time() + 1800
while True:
    try:
        urllib.request.urlopen(url, timeout=5)
        print(f"railway: API server is healthy at {url}", flush=True)
        break
    except Exception as e:
        if time.time() > deadline:
            sys.exit(f"railway: gave up waiting for the API server at {url}: {e}")
        print(f"railway: waiting for the API server at {url} ({e})", flush=True)
        time.sleep(10)
PY

if [ -f /etc/ssl/certs/custom-ca.crt ]; then update-ca-certificates; fi
echo "railway: starting Onyx background workers"
exec /app/scripts/supervisord_entrypoint.sh
