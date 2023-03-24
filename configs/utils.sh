#!/usr/bin/env bash

# Check whether command is existed or not
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# Check whether OS is MacOSX or not
is_macosx() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Check whether OS is Linux or not
is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

show_error() {
    printf "[ERROR] %s\n" "$*"
}
