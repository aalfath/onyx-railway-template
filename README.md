[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/onyx-1?utm_medium=integration&utm_source=button&utm_campaign=onyx)

# Deploy and Host Onyx on Railway

Onyx is an open-source AI platform for teams: a chat assistant and enterprise search that answers from your own documents. It connects to 40+ sources such as Slack, Google Drive, Confluence, GitHub and Notion, indexes them with permissions, and works with any LLM you bring: OpenAI, Anthropic, Gemini, Azure or a self-hosted model.

## About Hosting Onyx

Onyx is not a single container. Its upstream Docker Compose stack runs a FastAPI API server, a Next.js web app, Celery background workers, an MCP server, two model servers for embeddings, OpenSearch for the document index, an S3-compatible object store, PostgreSQL, Redis and an nginx router. This template deploys Onyx v5.1.3 as eleven Railway services wired over the private network. Secrets are generated at deploy time, every stateful service has its own volume and nginx is the only public service. The first deploy takes about five minutes while the images build, the database migrates and the embedding model loads.

## Common Use Cases

* A private ChatGPT-style assistant for your team, using your own LLM API keys
* Search and question answering across company wikis, drives, tickets and chat history
* Custom agents and an MCP endpoint that give AI tools grounded access to internal knowledge

## Dependencies for Onyx Hosting

* An API key for at least one LLM provider (OpenAI, Anthropic, Google, Azure or an OpenAI-compatible server), added in the admin panel after the first login
* Enough memory for the stack: OpenSearch takes a 2 GB heap and each model server about 1.5 GB

### Deployment Dependencies

* [Onyx on GitHub](https://github.com/onyx-dot-app/onyx) and its [v5.1.3 release](https://github.com/onyx-dot-app/onyx/releases/tag/v5.1.3)
* [Onyx documentation](https://docs.onyx.app) and [Docker Compose deployment guide](https://docs.onyx.app/deployment/local/docker)
* [OpenSearch](https://opensearch.org/), [SeaweedFS](https://github.com/seaweedfs/seaweedfs), [nginx](https://nginx.org/)
* This template's source: [aalfath/onyx-railway-template](https://github.com/aalfath/onyx-railway-template)

### Implementation Details

Services (all but Postgres and Redis build from this template's GitHub repo, each pinned to an official image by version and digest):

| Service | What it does | Volume |
|---|---|---|
| `nginx` | Public entry point: `/api` to the API server, `/mcp` to the MCP server, everything else to the web app | none |
| `web-server` | Onyx web app (Next.js) | none |
| `api-server` | Onyx API; runs the database migrations before it starts | none |
| `background` | Celery workers and scheduler: connectors, indexing, pruning, file processing | none |
| `mcp-server` | MCP endpoint at `https://YOUR-DOMAIN/mcp` for Claude, Cursor and other MCP clients | none |
| `inference-model-server` | Embeds search queries | model cache |
| `indexing-model-server` | Embeds documents while they are indexed | model cache |
| `opensearch` | Document index (keyword and vector search), OpenSearch 3.6 | index data |
| `object-store` | SeaweedFS S3 store for uploaded files | file data |
| `Postgres` | Railway PostgreSQL: users, settings, chat history, connector state | database |
| `Redis` | Railway Redis: Celery queue and cache | Railway default |

The services start in dependency order on their own: the API server waits for Postgres, Redis, OpenSearch and both model servers, runs `alembic upgrade head`, and the workers wait for the API's health check.

**After deploy**

1. Open the `nginx` service's public URL and create your account. **The first account becomes the admin**, so do this right away.
2. In the admin panel, add an LLM provider and its API key.
3. Lock sign-ups: turn on invite-only (Admin panel, Users) or set `VALID_EMAIL_DOMAINS` (for example `example.com`) on `api-server`, otherwise anyone with the URL can register.
4. Add connectors, or upload files in a chat, and start asking questions.

**Optional settings** (add them as variables on `api-server` and `background`): SMTP for invites and password resets (`SMTP_SERVER`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `EMAIL_FROM`), `VALID_EMAIL_DOMAINS`, and `REQUIRE_EMAIL_VERIFICATION=true`. For a custom domain, add it to `nginx` and change `WEB_DOMAIN` on `api-server`, `background`, `mcp-server` and `web-server` to `https://YOUR-DOMAIN`. Single sign-on (Google, OIDC, SAML) is set up in the admin panel.

**Left out on purpose:** upstream's code-interpreter service (the Python tool) mounts the Docker socket, which Railway does not offer, so it is not deployed. The legacy MinIO store and its copy job only matter for upgrades from Onyx v4 installs.

**Updates:** this template builds from [aalfath/onyx-railway-template](https://github.com/aalfath/onyx-railway-template). When we move it to a new Onyx release, Railway shows an "update available" notice in your project, and you choose when to apply it. Read [CHANGELOG.md](https://github.com/aalfath/onyx-railway-template/blob/main/CHANGELOG.md) first. Database migrations run on their own when the API server starts.

## Why Deploy Onyx on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Onyx on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
