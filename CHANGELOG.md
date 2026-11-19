# Changelog

Each entry lists breaking changes first. Updates reach deployers as Railway "update available" notices when this repo's `main` changes.

## 1.0.0 (2026-11-19): Onyx v5.1.3

First release.

- Onyx v5.1.3: `onyxdotapp/onyx-backend`, `onyx-web-server` and `onyx-model-server` `v5.1.3`, pinned by digest.
- OpenSearch 3.6.0, SeaweedFS 4.47 and nginx 1.30.7-alpine, pinned by digest.
- Eleven services: nginx, web-server, api-server, background, mcp-server, inference-model-server, indexing-model-server, opensearch, object-store, plus Railway Postgres and Redis.
- Generated secrets for the auth secret, encryption key, OpenSearch admin, S3 keys and the read-only database role. No default passwords.
- Volumes on OpenSearch, SeaweedFS, both model caches and Postgres.
