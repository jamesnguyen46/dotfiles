#!/usr/bin/env bash

if ! is_macosx; then
    return
fi

# ------- Homebrew -------
# https://docs.brew.sh/FAQ#why-should-i-install-homebrew-in-the-default-location
if [[ $(uname -m) == 'arm64' ]]; then
    # For macOS on Apple Silicon/ARM
    export HOME_BREW_PATH="/opt/homebrew/bin"
else
    # For macOS on intel
    export HOME_BREW_PATH="/usr/local/bin"
fi

# Need to this first to use `brew`` command for the below paths
export PATH="$HOME_BREW_PATH:$PATH"

# ------- Android -------
ANDROID_SDK="$HOME/Library/Android/sdk"
ANDROID_EMULATOR="$ANDROID_SDK/emulator"
ANDROID_TOOLS="$ANDROID_SDK/tools"
ANDROID_BUNDLE_TOOL="$ANDROID_SDK/bundle-tool"
ANDROID_PLATF_TOOLS="$ANDROID_SDK/platform-tools"
export ANDROID_PATH="$ANDROID_EMULATOR:$ANDROID_TOOLS:$ANDROID_BUNDLE_TOOL:$ANDROID_PLATF_TOOLS"

# ------- Using SDKMAN to manage the Java, Maven, Kotlin, ... version -------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ------- Flutter -------
export FLUTTER_SDK="$HOME/Library/flutter/bin"

# ------- Python -------
# Just install pyenv to manage multiple python version.
# No need to set path for each python version.
# Poetry
POETRY="$HOME/.poetry"

export PYTHON_PATH="$POETRY/bin"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ------- Golang -------
# Installation by Homebrew
GOLANG_PATH="$(brew --prefix golang)"
if [[ -z "$GOLANG_PATH" ]] || [[ ! -d "$GOLANG_PATH" ]]; then
    # Manual install
    GOLANG_PATH="/usr/local/go"
fi
export GOROOT="$GOLANG_PATH"
export GOPATH="$HOME/golang"
export GOBIN_PATH="$GOPATH/bin:$GOROOT/bin"

# ------- mysql-client -------
# For compilers to find mysql-client
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
export MYSQL_PATH="/usr/local/opt/mysql-client/bin"

# ------- gcloud -------
GCLOUD_SDK_PATH="$HOME/Library/google-cloud-sdk"

# Updates PATH for the Google Cloud SDK.
if [[ -f "$GCLOUD_SDK_PATH/path.zsh.inc" ]]; then
    # shellcheck source=/dev/null
    source "$GCLOUD_SDK_PATH/path.zsh.inc"
fi

# Enables shell command completion for gcloud.
if [[ -f "$GCLOUD_SDK_PATH/completion.zsh.inc" ]]; then
    # shellcheck source=/dev/null
    source "$GCLOUD_SDK_PATH/completion.zsh.inc"
fi

# ------- Set to path environments -------
# Define JAVA_HOME and MAVEN_PATH if not already set
export JAVA_HOME="${JAVA_HOME:-/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home}"
export MAVEN_PATH="${MAVEN_PATH:-$HOME/apache-maven/bin}"

# Added by LM Studio CLI (lms)
export NOTEBOOKLM_PATH="$HOME/.lmstudio/bin"

export PATH="$PATH:$ANDROID_PATH:$JAVA_HOME/bin:$MAVEN_PATH:$FLUTTER_SDK:$PYTHON_PATH:$GOBIN_PATH:$MYSQL_PATH:$NOTEBOOKLM_PATH"