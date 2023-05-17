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

# ------- Android -------
ANDROID_SDK="$HOME/Library/Android/sdk"
ANDROID_EMULATOR="$ANDROID_SDK/emulator"
ANDROID_TOOLS="$ANDROID_SDK/tools"
ANDROID_BUNDLE_TOOL="$ANDROID_SDK/bundle-tool"
ANDROID_PLATF_TOOLS="$ANDROID_SDK/platform-tools"
export ANDROID_PATH="$ANDROID_EMULATOR:$ANDROID_TOOLS:$ANDROID_BUNDLE_TOOL:$ANDROID_PLATF_TOOLS"

# ------- Java -------
JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME

# ------- Maven -------
export MAVEN_PATH="$HOME/Library/apache-maven/bin"

# ------- Flutter -------
export FLUTTER_SDK="$HOME/Library/flutter/bin"

# ------- Python -------
# Just install pyenv to manage multiple python version.
# No need to set path for each python version.
if command_exists pyenv; then
    PYENV_SHIMS="$(pyenv root)/shims"
fi
# Poetry
POETRY="$HOME/.poetry"

export PYTHON_PATH="$PYENV_SHIMS:$POETRY/bin"

# ------- Golang -------
export GO111MODULE="on"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/Library/go"
export GOLANG_PATH="$GOPATH/bin:$GOROOT/bin"

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
PATH="$PATH:$HOME/bin:/usr/local/bin:$HOME_BREW_PATH"
export PATH="$PATH:$ANDROID_PATH:$JAVA_HOME:$MAVEN_PATH:$FLUTTER_SDK:$PYTHON_PATH:$GOLANG_PATH:$MYSQL_PATH"
