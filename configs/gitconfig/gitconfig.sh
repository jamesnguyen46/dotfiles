#!/usr/bin/env bash

source "$LOCAL_REPO_DIR/configs/utils.sh"

GITCONFIG_DIR="$LOCAL_REPO_DIR/configs/gitconfig"
GITCONFIG_FILE="$HOME/.gitconfig"

file_header() {
    cat <<- EOF >> $GITCONFIG_FILE
		# This gitconfig was generated via $GITCONFIG_DIR/gitconfig.sh.
		# Edit that file, not this one!

	EOF
}

file_footer() {
    cat <<- EOF >> $GITCONFIG_FILE
		# This is the end of generated gitconfig file.
		# ----------------

	EOF
}

section_ui() {
    cat <<- EOF >> $GITCONFIG_FILE
		[color]
		    ui = auto

	EOF
}

section_common() {
    local editor="vi"
    # Priority for vscode
    if command_exists code; then
        editor="code --wait"
    elif command_exists vim; then
        editor="vim"
    fi

    cat <<- EOF >> $GITCONFIG_FILE
		[commit]
		    template = $GITCONFIG_DIR/.gitmsg

		[pull]
		    rebase = true

		[core]
		    editor = $editor
		    excludesfile = $GITCONFIG_DIR/.gitignore
		    pager = less -FX

		[filter "lfs"]
		    clean = git-lfs clean -- %f
		    smudge = git-lfs smudge -- %f
		    process = git-lfs filter-process
		    required = true

	EOF
}

generate_gitconfig() {
    file_header
    section_ui
    section_common
    file_footer
}

generate_gitconfig
