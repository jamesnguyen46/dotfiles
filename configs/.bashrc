#!/usr/bin/env bash

LOCAL_REPO_DIR="$HOME/.dotfiles"
ALIASES_DIR="$LOCAL_REPO_DIR/configs/aliases"
ENV_DIR="$LOCAL_REPO_DIR/configs/envs"

source "$LOCAL_REPO_DIR/configs/utils.sh"

# Load all envs
if [[ -d "$ENV_DIR" ]]; then
    while IFS= read -r -d '' file; do
        source "$file"
    done < <(find $ENV_DIR -name '*.sh' -print0)
fi

# Load all aliases
if [[ -d "$ALIASES_DIR" ]]; then
    while IFS= read -r -d '' file; do
        source "$file"
    done < <(find $ALIASES_DIR -name '*.sh' -print0)
fi
