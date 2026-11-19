# OpenSearch: Onyx's document index (keyword + vector search). Single node, data on a Railway volume.
FROM opensearchproject/opensearch:3.6.0@sha256:b5dd1512af2a99748c942cfbbd7f32162623336b210667d0fc6333c6321f171d
# Start as root only to hand the root-owned Railway volume to the opensearch user (uid 1000),
# then drop to that user (OpenSearch refuses to run as root).
USER root
COPY --chmod=755 start.sh /railway/start.sh
CMD ["/railway/start.sh"]
