FROM node:22-bookworm-slim

# Install build tools required for native modules (better-sqlite3)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install qmd globally
RUN npm install -g @tobilu/qmd

# Pre-download all three GGUF models into the image:
#   embeddinggemma-300M-Q8_0   (~300 MB) — vector embeddings
#   qwen3-reranker-0.6b-q8_0  (~640 MB) — re-ranking
#   qmd-query-expansion-1.7B  (~1.1 GB) — query expansion
#
# Note: node-llama-cpp resolves models to ~/. cache/qmd/models/ regardless
# of XDG_CACHE_HOME, so models are baked in at /root/.cache/qmd/models/.
RUN qmd pull

# Point the SQLite index at the mounted knowledge-base volume.
# INDEX_PATH is respected by qmd ahead of XDG_CACHE_HOME so this is
# the canonical way to relocate only the database without moving the models.
ENV INDEX_PATH=/data/index.sqlite

WORKDIR /data

# MCP HTTP server port (qmd mcp --http)
EXPOSE 8181

# Run container with the knowledge-base mounted to /data, e.g.:
#   docker run -v /home/tim/git/knowledge-base:/data -p 8181:8181 qmd
CMD ["qmd", "mcp", "--http"]
