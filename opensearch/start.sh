#!/bin/bash
# OpenSearch start script for Railway: single node, no memory lock or mmap
# (Railway can't set ulimits or vm.max_map_count), listening on IPv4 and IPv6.
set -e
DATA=/usr/share/opensearch/data
mkdir -p "$DATA"
chown -R 1000:1000 "$DATA"
export OPENSEARCH_JAVA_OPTS="${OPENSEARCH_JAVA_OPTS:--Xms1g -Xmx1g}"
export DISABLE_PERFORMANCE_ANALYZER_AGENT_CLI="${DISABLE_PERFORMANCE_ANALYZER_AGENT_CLI:-true}"
export HOME=/usr/share/opensearch
cd /usr/share/opensearch
exec chroot --userspec=1000:1000 / /usr/share/opensearch/opensearch-docker-entrypoint.sh opensearch \
  -Ediscovery.type=single-node \
  -Ebootstrap.memory_lock=false \
  -Enode.store.allow_mmap=false \
  -Enetwork.host=::
