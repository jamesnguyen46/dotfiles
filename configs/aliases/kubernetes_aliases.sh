#!/usr/bin/env bash

# Kubernetes cheat sheet : https://kubernetes.io/docs/reference/kubectl/cheatsheet/
if ! command_exists kubectl; then
    return
fi

# ------- Aliases -------

# Common
alias k="kubectl"

# Config - contexts
alias kfxa="kubectl_config_context_active_o1_contextname"
alias kfxd="kubectl_config_context_list_r1_name"
alias kfxl="kubectl_config_context_list_o1_name"
alias kfxn="kubectl_config_context_rename_r1_name_r2_newname"
alias kfxcl="kubectl_config_context_clear_all"

# Config - clusters
alias kfcs="kubectl config set-cluster"
alias kfcl="kubectl config get-clusters"
alias kfcd="kubectl config delete-cluster"

# Config - users
alias kfud="kubectl config delete-user"
alias kfug="kubectl config get-users"

# Config map and secret
alias kce="kubectl_edit_configmap_r1_namespace_r2_name"
alias kcg="kubectl_configmap_r1_namespace_r2_configname"
alias kse="kubectl_edit_secret_r1_namespace_r2_name"
alias ksg="kubectl_secret_r1_namespace_r2_secretname"
alias kcs="kubectl_configmap_secret_r1_namespace_r2_name"

# Namespace
alias kns="kubectl get namespaces"

# Deployment
alias kdl="kubectl_deployment_get_list_r1_namespace"
alias kdr="kubectl_deployment_restart_r1_namespace_o2_deployment"

# Pod
alias kpl="kubectl_pod_get_list_r1_namespace"
alias kpd="kubectl_pod_delete_r1_namespace_r2_pod_name"
alias kpe="kubectl_pod_exec_r1_namespace_r2_podname"

# ------- Functions -------

kubectl_config_context_active_o1_contextname() {
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

kubectl_config_context_list_r1_name() {
    kubectl config delete-context "$1"
}

kubectl_config_context_list_o1_name() {
    if [[ -z "$1" ]]; then
        kubectl config get-contexts
        return
    fi

    kubectl config get-contexts | grep "$1"
}

kubectl_config_context_clear_all() {
    kubectl config unset contexts
    kubectl config unset clusters
    kubectl config unset users
}

kubectl_config_context_rename_r1_name_r2_newname() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Context name is required."
        return
    fi

    kubectl config rename-context $1 $2
}

# shellcheck disable=SC2016
kubectl_configmap_r1_namespace_r2_configname() {
    kubectl get configmap "$2" \
        -n "$1" \
        -o go-template='{{range $k,$v := .data}}{{$k}}{{"="}}{{$v}}{{"\n"}}{{end}}'
}

# shellcheck disable=SC2016
kubectl_secret_r1_namespace_r2_secretname() {
    kubectl get secret "$2" \
        -n "$1" \
        -o go-template='{{range $k,$v := .data}}{{$k}}{{"="}}{{$v|base64decode}}{{"\n"}}{{end}}'
}

kubectl_configmap_secret_r1_namespace_r2_name() {
    {
        kubectl_configmap_r1_namespace_r2_configname "$1" "$2" &&
            kubectl_secret_r1_namespace_r2_secretname "$1" "$2"
    }
}

kubectl_edit_configmap_r1_namespace_r2_name() {
    kubectl edit configmap "$2" -n "$1"
}

kubectl_edit_secret_r1_namespace_r2_name() {
    kubectl edit secret "$2" -n "$1"
}

kubectl_pod_delete_r1_namespace_r2_pod_name() {
    kubectl delete pod "$2" -n "$1"
}

kubectl_pod_exec_r1_namespace_r2_podname() {
    kubectl -n "$1" exec -it "$2" sh
}

kubectl_deployment_get_list_r1_namespace() {
    kubectl get deployment -n "$1"
}

kubectl_pod_get_list_r1_namespace() {
    kubectl get pods -n "$1"
}

kubectl_deployment_restart_r1_namespace_o2_deployment() {
    if [[ -z "$2" ]]; then
        kubectl rollout restart deployment -n "$1"
        return
    fi

    kubectl rollout restart deployment "$2" -n "$1"
}
