FROM docker.io/node:22-alpine

WORKDIR /workspace

# Ensure /usr/local/bin is in PATH and PNPM_HOME is set so pnpm places global bins in a shared location
ENV PNPM_HOME=/usr/local
ENV PATH=$PNPM_HOME/bin:$PATH
ENV NODE_PATH=/usr/local/lib/node_modules

# Install git, openssh, and other utilities
RUN apk add --no-cache git openssh

# Install global tools (as root), clean caches, then create a non-root user
RUN npm set progress=false && \
	npm install -g pnpm@10 @slidev/cli @slidev/theme-default @slidev/theme-seriph slidev-theme-neversink typescript ts-node && \
	npm cache clean --force && \
	rm -rf /root/.npm /root/.cache

# Create a non-root user for runtime and give ownership of the workspace
RUN addgroup -S slide && adduser -S slide -G slide -s /bin/sh && chown -R slide:slide /workspace

RUN chown -R slide:slide /usr/local

USER slide
ENV SLIDEV_HOST=0.0.0.0
EXPOSE 3030