FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    openssh-client \
    sudo \
    wget \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash opencode && \
    echo "opencode serve ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/opencode && \
    chmod 0440 /etc/sudoers.d/opencode

USER opencode
WORKDIR /home/opencode

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash

# Add OpenCode to PATH
ENV PATH=/home/opencode/.opencode/bin:$PATH

# Expose server port
EXPOSE 4096

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:4096/global/health || exit 1

# Start OpenCode server
CMD ["opencode", "serve", "--port", "4096", "--hostname", "127.0.0.1"]
