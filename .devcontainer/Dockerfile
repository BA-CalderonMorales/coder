FROM ubuntu:22.04

# Install essential development tools for bash scripting and Coder server testing
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    git-lfs \
    ca-certificates \
    sudo \
    jq \
    tar \
    gzip \
    unzip \
    shellcheck \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create codespace user for GitHub Codespaces compatibility
RUN groupadd --gid 1000 codespace \
    && useradd --uid 1000 --gid codespace --shell /bin/bash --create-home codespace \
    && echo 'codespace ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER codespace
WORKDIR /workspaces/coder-starter-scripts