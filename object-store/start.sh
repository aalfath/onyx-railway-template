#!/bin/sh
# SeaweedFS start script for Railway, following upstream Onyx's compose command:
# one `weed server` (master + volume + filer) with the S3 gateway on port 8333,
# admin credentials from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY, data on /data,
# and fsync turned on for the bucket paths before it reports healthy.
export WEED_FILER_OPTIONS_MAX_FILE_NAME_LENGTH="${WEED_FILER_OPTIONS_MAX_FILE_NAME_LENGTH:-1024}"
export WEED_MASTER_VOLUME_GROWTH_COPY_1="${WEED_MASTER_VOLUME_GROWTH_COPY_1:-1}"
/entrypoint.sh server -s3 -ip=127.0.0.1 -ip.bind=127.0.0.1 -s3.ip.bind=:: -s3.port=8333 &
pid=$!
trap 'kill -TERM $pid; wait $pid' TERM INT
until echo 'fs.configure -locationPrefix=/buckets/ -fsync -apply' | weed shell -master=127.0.0.1:9333 >/dev/null 2>&1; do
  kill -0 $pid 2>/dev/null || exit 1
  sleep 1
done
echo "railway: SeaweedFS is up, fsync configured for /buckets/"
wait $pid
