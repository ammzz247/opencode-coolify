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

# Start OpenCode server
CMD ["opencode", "serve", "--port", "4096", "--hostname", "127.0.0.1"]
