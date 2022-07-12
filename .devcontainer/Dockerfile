# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.217.1/containers/python-3/.devcontainer/base.Dockerfile

ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# [Choice] Node.js version: none, lts/*, 18, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [[ "${NODE_VERSION}" != "none" ]]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Setup the Docker repository
# https://docs.docker.com/engine/install/debian/
# hadolint ignore=DL3008
RUN mkdir -p /etc/apt/keyrings \
    # Docker
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    # hadolint ignore=DL3008
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin \
        sshpass \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER vscode

ARG POETRY_VERSION="1.2.0b2"

RUN curl -sSL https://install.python-poetry.org | POETRY_VERSION="${POETRY_VERSION}" python -

# Install prettier
RUN npm install -g prettier@2.7.1
