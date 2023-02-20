#!/usr/bin/env bash

# Check whether command is existed or not
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

show_error() {
    printf "[ERROR] %s\n" "$*"
}
