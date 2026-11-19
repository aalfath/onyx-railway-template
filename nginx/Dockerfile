# nginx: the public entry point. Routes /api, /openapi.json, /scim and /auth/saml to the API server,
# /mcp to the MCP server and everything else to the web server (upstream Onyx's nginx routing).
FROM nginx:1.30.7-alpine@sha256:bef154735288bc38d99fac41ae63730684bcc661503673a04a0f9bc526ba8598
# The official entrypoint renders /etc/nginx/templates/*.template with envsubst (only the
# variables matching the filter) and exports the container's DNS resolvers.
ENV NGINX_ENVSUBST_FILTER="^(ONYX_|NGINX_|PORT$)" \
    NGINX_ENTRYPOINT_LOCAL_RESOLVERS=1 \
    PORT=8080 \
    NGINX_PROXY_CONNECT_TIMEOUT=300 \
    NGINX_PROXY_SEND_TIMEOUT=300 \
    NGINX_PROXY_READ_TIMEOUT=300
RUN rm /etc/nginx/conf.d/default.conf
COPY onyx.conf.template /etc/nginx/templates/onyx.conf.template
