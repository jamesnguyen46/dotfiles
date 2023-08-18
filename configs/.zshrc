#!/usr/bin/env zsh

LOCAL_REPO_DIR="$HOME/.dotfiles"

source "$LOCAL_REPO_DIR/configs/.bashrc"

# ------- oh-my-zsh -------
# Just apply the below configuration for zsh shell
export ZSH="$HOME/.oh-my-zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh not found."
    return
fi

# Select powerlevel10k theme if it is installed
# shellcheck disable=SC2034
if [[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="robbyrussell"
fi

# Oh-my-zsh plugins
plugins=( 
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k
[[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]] && {
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
}
