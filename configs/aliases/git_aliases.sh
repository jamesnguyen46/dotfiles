#!/usr/bin/env bash

# Ensure that all aliases are only loaded when git-client has been installed.
if ! command_exists git; then
    return 0
fi

# ------- Aliases -------

# !!! NOT USE ALIAS WITH PREFIX GC OF GCLOUD COMMANDS !!!

alias gia="git_stage_changes_n_file_or_directory"
alias gia~="git_unstage_changes_n_file_or_directory"

alias gib="git branch"
alias gibc="git_branch_checkout_r1_branchname"
alias gibd="git_branch_delete_o1_branchname"
alias gibd!="git_branch_remote_delete_o1_branchname"
alias gibl="git_branch_list_local_o1_branchname"
alias giblr="git_branch_list_remote_o1_branchname"
alias gibr="git_branch_rename_r1_old_r2_new"

alias gic="git_commit_o1_msg"
alias gicl="git clone"

alias gidc="git_discard_changes"
alias gid="git diff"
alias gids="git diff --staged"

alias gie="git fetch --prune"

alias gifl="git config --list"
alias gifu="git_config_user_info_r1_name_r2_email"

alias gig="git_logs_o1_number"

alias giha="git stash apply"
alias gihb="git stash branch"
alias gihc="git stash clear"
alias gihd="git stash drop"
alias gihl="git stash list"
alias gihp="git stash pop"
alias gihs="git stash save --include-untracked"
alias gihw="git stash show"

alias gii="git init"

alias gil="git pull"

alias gim="git merge"
alias gima="git merge --abort"
alias gimc="git merge --continue"
alias gimq="git merge --quit"

alias gip="git push"
alias gip!="git push --force"

alias girb="git rebase"
alias girba="git rebase --abort"
alias girbc="git rebase --continue"
alias girbq="git rebase --quit"

alias gire="git revert"
alias girs="git_reset_o1_commit_no_from_head"

alias gis="git status"

alias gist="git log --stat"

alias gitl="git_tag_list_o1_number"

alias giw="git show"

alias giy="git cherry-pick"
alias giya="git cherry-pick --abort"
alias giyc="git cherry-pick --continue"
alias giyq="git cherry-pick --quit"

# ------- FUNCTIONS -------

git_stage_changes_n_file_or_directory() {
    [[ $# -eq 0 ]] && git add --verbose --all || git add --verbose "$@"
}

git_unstage_changes_n_file_or_directory() {
    [[ $# -eq 0 ]] && git reset || git reset -- "$@"
}

git_branch_checkout_r1_branchname() {
    # Check if input parameter exists
    if [[ $# -eq 0 ]]; then
        return
    fi

    branch_name="$1"
    current_branch=$(git branch --list "$branch_name")

    # Check if branch is local branch.
    # Then pull the lastest changes from remote repository
    if [[ "$branch_name" == "${current_branch:2}" ]]; then
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

git_branch_list_local_o1_branchname() {
    [[ $# -eq 0 ]] && git branch --list || git branch --list | grep "$1"
}

git_branch_list_remote_o1_branchname() {
    [[ $# -eq 0 ]] && git branch --remotes || git branch --remotes | grep "$1"
}

git_branch_rename_r1_old_r2_new() {
    git branch -m "$1" "$2"
}

git_branch_delete_o1_branchname() {
    [[ $# -eq 0 ]] && {
        keep_branch="$(git branch --show-current)\|develop\|dev\|main\|master"
        git branch | grep -v "$keep_branch" | xargs git branch -D
    } || {
        git branch -D "$1"
    }
}

git_branch_remote_delete_o1_branchname() {
    [[ $(git_branch_list_remote_o1_branchname "$1") ]] && {
        git push origin -d "$1" &&
            git_branch_delete_o1_branchname "$1"
    } || {
        echo "Branch name \"$1\" not found."
    }
}

git_commit_o1_msg() {
    if [[ -n "$1" ]]; then
        git commit --message "$1"
        return
    fi

    # Commit an empty commit to retry CI pipeline
    echo "Do you want to commit an empty commit (Y/N)?"
    read -r response
    if [[ $response == "y" || $response == "Y" ]]; then
        git commit --allow-empty --message "Empty commit to trigger pipeline"
    fi
}

git_discard_changes() {
    git clean -df
    if [[ $(git status -suno) ]]; then
        git checkout -- .
    fi
}

git_config_user_info_r1_name_r2_email() {
    git config user.name "$1"
    git config user.email "$2"
}

git_logs_o1_number() {
    [[ -n "$1" ]] && log_number=$1 || log_number=10
    git log -"$log_number" \
        --branches \
        --pretty='%C(yellow)%h %C(cyan)%cd%C(auto)%d %C(reset)%s %C(green) by %aN <%ae>' \
        --graph \
        --date=format:'%Y-%m-%d %H:%M:%S' \
        --date-order \
        --abbrev-commit
}

git_reset_o1_commit_no_from_head() {
    [[ -n "$1" ]] && git reset --soft HEAD~"$1" || git reset --soft HEAD^
}

git_tag_list_o1_number() {
    [[ -n "$1" ]] && tag_count=$1 || tag_count=10
    git tag \
        --sort=-taggerdate \
        --format '%(committerdate:short)%09%(objectname:short)%09%(refname:short)%09 by %(committername) %(committeremail)' |
        head -n "$tag_count"
}
