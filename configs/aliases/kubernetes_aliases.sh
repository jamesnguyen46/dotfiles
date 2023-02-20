#!/usr/bin/env bash

# Kubernetes cheat sheet : https://kubernetes.io/docs/reference/kubectl/cheatsheet/
if ! command_exists kubectl; then
    return 0
fi

# ------- Aliases -------

alias k='kubectl'

# Config
alias kfc='kb_config_clean'
alias kfx='kubectl config get-contexts'
alias kfxr='kb_config_context_rename_r1_name_r2_newname'
alias kfxa='kb_config_context_active_o1_contextname'
alias kfcs="kubectl config set-cluster"
alias kfcg="kubectl config get-clusters"

# Config map and secret
alias kce='kb_edit_configmap_p1_namespace_p2_name'
alias kcg='kb_configmap_p1_namespace_p2_configname'
alias kse='kb_edit_secret_p1_namespace_p2_name'
alias ksg='kb_secret_p1_namespace_p2_secretname'
alias kcs='kb_configmap_secret_p1_namespace_p2_name'

# Namespace
alias kns='kubectl get namespaces'

# Deployment
alias kdl='kb_deployment_get_list_r1_namespace'
alias kdr='kb_deployment_restart_r1_namespace_o2_deployment'

# Pod
alias kpl='kb_pod_get_list_r1_namespace'
alias kpd='kb_pod_delete_r1_namespace_r2_pod_name'
alias kpe='kb_pod_exec_p1_namespace_p2_podname'

# ------- Functions -------

kb_config_clean() {
    kubectl config unset contexts
    kubectl config unset clusters
}

kb_config_context_rename_r1_name_r2_newname() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Context name is required."
        return 1
    fi

    kubectl config rename-context $1 $2
}

kb_config_context_active_o1_contextname() {
    selected_context=$1
    if [[ -z $selected_context ]]; then
        selected_context=$(kubectl config current-context)
    fi

    if [[ -z $(kubectl config get-contexts | grep $selected_context) ]]; then
        echo "Name is not existed."
        return
    fi

    kubectl config use-context $selected_context
}

# shellcheck disable=SC2016
kb_configmap_p1_namespace_p2_configname() {
    kubectl get configmap "$2" -n "$1" -o go-template='{{range $k,$v := .data}}{{$k}}{{"="}}{{$v}}{{"\n"}}{{end}}'
}

# shellcheck disable=SC2016
kb_secret_p1_namespace_p2_secretname() {
    kubectl get secret "$2" -n "$1" -o go-template='{{range $k,$v := .data}}{{$k}}{{"="}}{{$v|base64decode}}{{"\n"}}{{end}}'
}

kb_configmap_secret_p1_namespace_p2_name() {
    {
        kb_configmap_p1_namespace_p2_configname "$1" "$2" && kb_secret_p1_namespace_p2_secretname "$1" "$2"
    }
}

kb_edit_configmap_p1_namespace_p2_name() {
    kubectl edit configmap "$2" -n "$1"
}

kb_edit_secret_p1_namespace_p2_name() {
    kubectl edit secret "$2" -n "$1"
}

kb_pod_delete_r1_namespace_r2_pod_name() {
    kubectl delete pod "$2" -n "$1"
}

kb_pod_exec_p1_namespace_p2_podname() {
    kubectl -n "$1" exec -it "$2" sh
}

kb_deployment_get_list_r1_namespace() {
    kubectl get deployment -n "$1"
}

kb_pod_get_list_r1_namespace() {
    kubectl get pods -n "$1"
}

kb_deployment_restart_r1_namespace_o2_deployment() {
    if [[ -z "$2" ]]; then
        kubectl rollout restart deployment -n "$1"
    else
        kubectl rollout restart deployment "$2" -n "$1"
    fi
}
