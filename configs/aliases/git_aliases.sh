#!/usr/bin/env bash

# Ensure that all aliases are only loaded when git-client has been installed.
if ! command_exists git; then
    return 0
fi

# Staged Changes
alias gia='git_add_pn_file_or_directory'

# Show the local branches.
alias gib='git branch --list'

# Show/search the remote branches.
# Input : the name of branch that you want to find. If no, show all remote branches.
alias gibr='show_remote_branches'

# Git commit
alias gic='git commit --message'

# Push a empty commit to retry CI pipeline
# https://dev.to/devsimc/how-to-push-an-empty-commit-28dd
alias gice='git commit --allow-empty --message "Empty commit to trigger pipeline"'

# Switch branch and pull lastest source code from remote.
# Input : the branch name.
alias gicb='checkout_branch'

alias gicl='git clone'

# Remove all local branches, except "develop", "dev", "main", "master" and the current branch.
alias giclr='clean_all_local_branches'

# Config git repository
alias gicf='config_git_repo_r1_name_r2_email'

alias gid='git diff'

# Fetch the remote branches.
alias gif='git fetch --prune'

# Pull the lastest source code.
alias gil='git pull'

# Show the log of current branch.
# Input : the log number. Default is 10.
alias gig='show_log'

# Git push
alias gip='git push'
alias gipf='git push -f'

# Reset the HEAD commit.
# Input : the number of HEAD commit
alias gir='reset_commit'

alias gis='git status'

# ------- FUNCTIONS -------

git_add_pn_file_or_directory() {
    if [[ $# -eq 0 ]]; then
        git add .
    else
        git add "$@"
    fi
}

reset_commit() {
    if [[ -n "$1" ]]; then
        git reset --soft HEAD~"$1"
    else
        git reset --soft HEAD^
    fi
}

config_git_repo_r1_name_r2_email() {
    git config user.name "$1"
    git config user.email "$2"
    git config core.pager "less -FX"
}

clean_all_local_branches() {
    keep_branch="$(git branch --show-current)\|develop\|dev\|main\|master"
    git branch | grep -v "$keep_branch" | xargs git branch -D
}

show_log() {
    [[ -n "$1" ]] && log_number=$1 || log_number=10
    git log -"$log_number" --pretty='%C(yellow)%h %C(cyan)%cd%C(auto)%d %C(reset)%s %C(blue)<%ae>' --graph --branches --date=format:'%Y-%m-%d %H:%M:%S' --date-order --abbrev-commit
}

show_remote_branches() {
    if [[ $# -eq 0 ]]; then
        git branch --remotes
    else
        git branch --remotes | grep "$1"
    fi
}

checkout_branch() {
    # Check if input parameter exists
    if [[ $# -eq 0 ]]; then
        echo "Usage : $0 <branch_name>"
        return
    fi

    branch_name="$1"
    current_branch=$(git branch --list "$branch_name")

    # Check if branch is local branch.
    # Then pull the lastest changes from remote repository
    if [[ "$branch_name" == "${current_branch:2}" ]]; then
        # Check if branch is current branch
        if [ "${current_branch:0:1}" != "*" ]; then
            git checkout "$branch_name"
        else
            echo "\"$branch_name\" is current branch."
        fi

        # Pull the lastest source code.
        git pull
        return
    fi

    # Checkout from remote branch
    if [[ $(git branch --remote --list "origin/$branch_name") ]]; then
        echo "\"$branch_name\" branch is checking out from remote."
        git checkout -b "$branch_name" --track "origin/$branch_name"
    else
        echo "Branch \"$branch_name\" does not exist."
        echo "Do you want to create new local branch with name \"$branch_name\" (Y/N)?"
        read -r response
        if [[ $response == "y" || $response == "Y" ]]; then
            git checkout -b "$branch_name"
        fi
    fi
}
