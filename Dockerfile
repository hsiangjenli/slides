FROM docker.io/node:22-alpine

WORKDIR /workspace

# Ensure /usr/local/bin is in PATH and PNPM_HOME is set so pnpm places global bins in a shared location
ENV PNPM_HOME=/usr/local
ENV PATH=$PNPM_HOME/bin:$PATH

# Install git, openssh, and other utilities
RUN apk add --no-cache git openssh

# Install global tools (as root), clean caches, then create a non-root user
RUN npm set progress=false && \
	npm install -g pnpm@10 @slidev/cli @slidev/theme-default @slidev/theme-seriph && \
	pnpm config set global-bin-dir /usr/local/bin && \
	pnpm add -g slidev-workspace && \
	npm cache clean --force && \
	rm -rf /root/.npm /root/.cache

# Create a non-root user for runtime and give ownership of the workspace
RUN addgroup -S slide && adduser -S slide -G slide -s /bin/sh && chown -R slide:slide /workspace

# Make /usr/local writable by slide user so Vite can cache dependencies
RUN chown -R slide:slide /usr/local/lib/node_modules /usr/local/bin 2>/dev/null || true

USER slide
ENV SLIDEV_HOST=0.0.0.0
EXPOSE 3030

