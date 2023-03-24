#!/usr/bin/env bash

# ------- Common -------
export SDK_HOME="$HOME/SDK"

# ------- Homebrew (for MacOSX) -------
# https://docs.brew.sh/FAQ#why-should-i-install-homebrew-in-the-default-location
if is_macosx; then
    if [[ $(uname -m) == 'arm64' ]]; then
        # For macOS on Apple Silicon/ARM
        export HOME_BREW_PATH="/opt/homebrew/bin/brew"
    else
        # For macOS on intel
        export HOME_BREW_PATH="/usr/local/bin/brew"
    fi
fi

# ------- Android -------
ANDROID_SDK="$SDK_HOME/android"
ANDROID_NDK="$ANDROID_SDK/ndk/20.1.5948944"
ANDROID_EMULATOR="$ANDROID_SDK/emulator"
ANDROID_TOOLS="$ANDROID_SDK/tools"
ANDROID_BUNDLE_TOOL="$ANDROID_SDK/bundle-tool"
ANDROID_PLATF_TOOLS="$ANDROID_SDK/platform-tools"
export ANDROID_PATH="$ANDROID_NDK:$ANDROID_EMULATOR:$ANDROID_TOOLS:$ANDROID_BUNDLE_TOOL:$ANDROID_PLATF_TOOLS"

# ------- Flutter -------
export FLUTTER_SDK="$SDK_HOME/flutter/bin"

# ------- Python -------
# Just install pyenv to manage multiple python version.
# No need to set path for each python version.
if command_exists pyenv; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
# Poetry
POETRY="$HOME/.poetry"

export PYTHON_PATH="$POETRY/bin"

# ------- Golang -------
export GO111MODULE="on"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOLANG_PATH="$GOPATH/bin:$GOROOT/bin"

# ------- mysql-client -------
# For compilers to find mysql-client
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
export MYSQL_PATH="/usr/local/opt/mysql-client/bin"

# ------- gcloud -------
GCLOUD_SDK_PATH="$SDK_HOME/google-cloud-sdk"

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
PATH="$PATH:$HOME/bin:/usr/local/bin"
export PATH="$PATH:$ANDROID_PATH:$FLUTTER_SDK:$PYTHON_PATH:$GOLANG_PATH:$MYSQL_PATH"
