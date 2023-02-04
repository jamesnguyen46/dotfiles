#!/usr/bin/env bash

LOCAL_REPO_DIR="$HOME/.dotfiles"
ALIASES_DIR="$LOCAL_REPO_DIR/configs/aliases"
ENV_DIR="$LOCAL_REPO_DIR/configs/environtments"

source "$LOCAL_REPO_DIR/configs/utils.sh"

# Load all envs
if [[ -d "$ENV_DIR" ]]; then
    for file in "$ENV_DIR"/**/*.sh; do
        source "$file"
    done
fi

# Load all aliases
if [[ -d "$ALIASES_DIR" ]]; then
    for file in "$ALIASES_DIR"/**/*.sh; do
        source "$file"
    done
fi
