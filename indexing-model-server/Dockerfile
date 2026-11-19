# Onyx indexing model server: document embeddings for the background indexing workers, port 9000.
# Runs as root so it can write the Railway volume mounted on /app/.cache/huggingface.
FROM onyxdotapp/onyx-model-server:v5.1.3@sha256:3db4f73e776fdebc7c83544f77a255e6ae4fb1084fdf2c463df49099db9eb0ab
USER root
ENV INDEXING_ONLY=True
CMD ["python", "-m", "model_server"]
