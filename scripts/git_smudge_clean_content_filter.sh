#!/usr/bin/env bash

regex_patterns=(email.* name.* sshCommand.*)
replacements=("email = \\\"\\\"" "name = \\\"\\\"" "sshCommand = \\\"\\\"")

sedcmd="sed -e"
if [[ "$1" == "clean" || "$1" == "smudge" ]]; then
    for i in "${!regex_patterns[@]}"; do
        regex="s/${regex_patterns[$i]}/${replacements[$i]}/g"
        mutil_regex+="$regex;"
    done
else
    echo "Use smudge/clean as the first argument"
    exit 1
fi

sedcmd+=" \"$mutil_regex\""
eval $sedcmd
