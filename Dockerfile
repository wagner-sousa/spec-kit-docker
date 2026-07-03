FROM mcr.microsoft.com/devcontainers/python:3.13-trixie

USER root

RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        wget \
        sudo \
        build-essential \
        zsh \
    && rm -rf /var/lib/apt/lists/*

USER vscode

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/home/vscode/.local/bin:${PATH}"

RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

WORKDIR /workspace

ENTRYPOINT ["specify"]
