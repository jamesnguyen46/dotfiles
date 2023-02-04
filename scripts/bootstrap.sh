#!/usr/bin/env bash

(command -v git > /dev/null 2>&1) || {
    printf "[ERR] %s\n" "Cannot work without Git."
    exit 1
}

ACTION_CMD_LIST=("install" "uninstall")
if [[ ! "${ACTION_CMD_LIST[*]}" =~ $1 ]]; then
    printf "[ERR] %s\n" "Unknown command."
    exit 1
fi

# ------- Constants --------

# Local repo path
LOCAL_REPO_DIR="$HOME/.dotfiles"
LOCAL_RC_FILE="$LOCAL_REPO_DIR/configs/.$(basename "$SHELL")rc"
BACKUP_SUFFIX="dotfilesbackup"

# System file path
RC_FILE="$HOME/.$(basename "$SHELL")rc"

# Github repository
REPO_NAME="jamesnguyen46/dotfiles"
BRANCH="main"
REMOTE="https://github.com/$REPO_NAME.git"

# ------- Main --------

# Global variable for install command
is_local=false

# Global variable for uninstall command
show_promt=true

main() {
    parse_args "$@"
    case $1 in
        install)
            run_install
            ;;
        uninstall)
            run_uninstall
            ;;
    esac
}

parse_args() {
    while [[ "$2" =~ ^- && ! "$2" == "--" ]]; do
        case $2 in
            -l | --local)
                is_local=true
                ;;
            -q | --quite)
                show_promt=false
                ;;
        esac
        shift
    done
}

# ------- Installation --------

run_install() {
    setup_dotfiles_repo
    create_symlinks
}

setup_dotfiles_repo() {
    show_step "Setup \"$REPO_NAME\" repository."

    if [[ -d $LOCAL_REPO_DIR ]]; then
        show_skipped "$LOCAL_REPO_DIR is existed."
        return
    fi

    # For local debug
    if $is_local; then
        local current_dev_dir
        current_dev_dir=$(pwd | grep 'dotfiles')
        if ! pwd | grep 'dotfiles'; then
            # The script is running from an unknown place, not under dotfiles directory
            show_error "Unknown dir"
            show_msg "If you use --local flag when running this script from remote, please remove it."
            exit 1
        fi

        cp -R "$current_dev_dir" "$LOCAL_REPO_DIR"
        show_done "Copied \"$current_dev_dir\" to \"$LOCAL_REPO_DIR\"."
        return
    fi

    # Manual clone dotfile repo
    git init --quiet "$LOCAL_REPO_DIR" && cd "$LOCAL_REPO_DIR" &&
        git remote add origin "$REMOTE" &&
        git fetch --depth=1 origin &&
        git checkout -b "$BRANCH" "origin/$BRANCH" || {
        [[ ! -d "$LOCAL_REPO_DIR" ]] || {
            rm -rf "$LOCAL_REPO_DIR" 2> /dev/null
        }
        show_failed "Cannot clone \"$REPO_NAME\" repo."
        exit 1
    }

    show_done "Fetched \"$REPO_NAME\" repository to \"$LOCAL_REPO_DIR\"."
}

create_symlinks() {
    show_step "Symlinks."

    if [[ -L "$RC_FILE" ]] && [[ "$(realpath $RC_FILE 2> /dev/null)" == "$LOCAL_RC_FILE" ]]; then
        show_skipped "\"$RC_FILE\" symlink has been created."
        return
    fi

    # Back up the current rc file
    backup_file "$RC_FILE"

    # Force to create new symlink
    ln -sf "$LOCAL_RC_FILE" "$RC_FILE"
    show_done "Created $RC_FILE symlink."
}

# ------- Uninstalling --------

run_uninstall() {
    if $show_promt; then
        read -r -p "Are you sure you want to remove .dotfiles? [y/N] " confirm
        if [[ "$confirm" != y ]] && [[ "$confirm" != Y ]]; then
            show_msg "Uninstall cancelled."
            exit
        fi
    fi

    remove_dotfile_folder
    restore_origin_rc_file
}

remove_dotfile_folder() {
    show_step "Remove \"$LOCAL_REPO_DIR\" repository."

    if [[ -d $LOCAL_REPO_DIR ]]; then
        rm -rf "$LOCAL_REPO_DIR"
        show_done "\"$LOCAL_REPO_DIR\" has been removed."
    else
        show_skipped "No $LOCAL_REPO_DIR folder found."
    fi
}

restore_origin_rc_file() {
    show_step "Restore \"$RC_FILE\"."
    restore_file "$RC_FILE"
}

# ------- Utilities --------

declare -i count

show_step() {
    count+=1
    printf "\n%d. %s" "$count" "$*"
    printf "\n%s\n" "--------------"
}

show_msg() {
    printf "%s\n" "$*"
}

show_error() {
    printf "[ERR] %s\n" "$*"
}

show_skipped() {
    show_msg "$*"
    show_msg "SKIPPED"
}

show_done() {
    show_msg "$*"
    show_msg "DONE"
}

show_failed() {
    show_error "$*"
    show_msg "FAILED"
}

backup_file() {
    local file_path="$1"

    if [[ -f $file_path ]] || [[ -L $file_path ]]; then
        now=$(date +"%Y%m%d%H%M%S")
        backup_file_path="${file_path}_${BACKUP_SUFFIX}_$now"
        mv "$file_path" "$backup_file_path"
        show_msg "Found \"$file_path\" -> back up to \"$backup_file_path\"."
    fi
}

restore_file() {
    local file_path="$1"
    dir_name="$(dirname "$file_path")"

    cd "$dir_name" || {
        show_msg "\"$file_path\" is not existed or invalid."
        return
    }

    # Get the name of recent backup file
    backup_file_path=$(ls "${file_path}_${BACKUP_SUFFIX}_"* 2> /dev/null | sort -r | head -1)
    if [[ -z "$backup_file_path" ]]; then
        show_skipped "No backup of \"$file_path\" file found."
        return
    fi

    show_msg "Found \"$backup_file_path\" --> restore to \"$file_path\"."
    mv "$backup_file_path" "$file_path"
    show_done "Your original \"$file_path\" file was restored."
}

# ------- Execution starts --------
main "$@"
