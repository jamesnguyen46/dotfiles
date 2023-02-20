#!/usr/bin/env bash

if ! command_exists gcloud; then
    return
fi

# ------- Aliases -------

# Common
alias gc="gcloud"
alias gci="gcloud init"
alias gcv="gcloud version"
alias gcao="gcloud auth login"
alias gcal="gcloud auth list"

# Components
alias gcpi="gcloud components install"
alias gcjl="gcloud components list"
alias gcpr="gcloud components remove"
alias gcpu="gcloud components update"

# Configurations
alias gcfa="gcloud_configuration_activate_r1_configname"
alias gcfc="gcloud_configuration_create_r1_configname_r2_account_r3_project_o4_zone_o5_region"
alias gcfd="gcloud_configuration_delete_r1_configname"
alias gcfg="gcloud_configuration_get_o1_configname_o2_propertyname"
alias gcfr="gcloud_configuration_rename_r1_configname_r2_confignewname"
alias gcfs="gcloud_configuration_set_r1_configname_r2_propertyname_r3_value"

# Projects
alias gcjc="gcloud projects create"
alias gcjd="gcloud projects delete"
alias gcjl="gcloud_project_list_with_format_and_sort_create_time"
alias gcjr="gcloud projects describe"
alias gcju="gcloud projects update"

# Clusters
alias gccl="gcloud_cluster_list_o1_configname"
alias gccre="gcloud_cluster_get_credential_r1_configname_r2_clustername_o3_kubnecontextname"

# Virtual Machines & Compute Engine
alias gcuzl="gcloud compute zones list"
alias gcush="gcloud compute ssh"
alias gcbas="gcloud_access_private_cluster_via_bastion_r1_instancename_o2_configname"

# ------- Functions -------

gcloud_configuration_activate_r1_configname() {
    if ! _gcloud_configuration_existed_r1_configname "$1"; then
        show_error "Configuration name is not existed."
        return
    fi

    gcloud config configurations activate $1
}

gcloud_configuration_create_r1_configname_r2_account_r3_project_o4_zone_o5_region() {
    if _gcloud_configuration_existed_r1_configname "$1"; then
        show_error "Configuration name has already existed."
        return
    fi

    gcloud config configurations create $1 --no-activate &&
        gcloud config set disable_prompts true --configuration $1 &&
        gcloud config set account $2 --configuration $1 &&
        gcloud config set project $3 --configuration $1 &&
        gcloud config set compute/zone $4 --configuration $1 &&
        gcloud config set compute/region $5 --configuration $1
}

gcloud_configuration_delete_r1_configname() {
    if ! _gcloud_configuration_existed_r1_configname "$1"; then
        show_error "Configuration name is not existed."
        return
    fi

    gcloud config configurations delete $1
}

gcloud_configuration_get_o1_configname_o2_propertyname() {
    case "$#" in
        0)
            gcloud config configurations list
            ;;
        1)
            gcloud config list --configuration "$1"
            ;;
        *)
            gcloud config get "$2" --configuration "$1"
            ;;
    esac
}

gcloud_configuration_rename_r1_configname_r2_confignewname() {
    if ! _gcloud_configuration_existed_r1_configname "$1"; then
        show_error "Configuration name is not existed."
        return
    fi

    gcloud config configurations rename "$1" --new-name="$2"
}

gcloud_configuration_set_r1_configname_r2_propertyname_r3_value() {
    if ! _gcloud_configuration_existed_r1_configname "$1"; then
        show_error "Configuration name is not existed."
        return
    fi

    gcloud config set "$2" "$3" --configuration="$1"
}

gcloud_project_list_with_format_and_sort_create_time() {
    gcloud projects list \
        --format="table(projectNumber,projectId,name,createTime.date(tz=LOCAL))" \
        --sort-by=createTime
}

gcloud_cluster_list_o1_configname() {
    gcloud container clusters list --configuration="$1"
}

gcloud_cluster_get_credential_r1_configname_r2_clustername_o3_kubnecontextname() {
    if [[ -z "$1" ]]; then
        gcloud container clusters get-credentials "$2" \
            --internal-ip \
            --region="$(gcloud_configuration_get_o1_configname_o2_propertyname "" compute/region)"
        return
    fi

    gcloud container clusters get-credentials "$2" \
        --internal-ip \
        --configuration="$1" \
        --region="$(gcloud_configuration_get_o1_configname_o2_propertyname $1 compute/region)"

    if [[ -z "$3" ]] || ! command_exists kubectl; then
        return
    fi

    # Change context name for easy usage
    current_context_name=$(kubectl config current-context)
    kubectl config rename-context $current_context_name $3

    # Config proxy for cluster
    current_cluster_name=$(kubectl config get-contexts | awk '$1 == "*" {print $3}')
    kubectl config set-cluster "$current_cluster_name" --proxy-url=http://localhost:8888
}

gcloud_access_private_cluster_via_bastion_r1_instancename_o2_configname() {
    if [[ $# -eq 0 ]]; then
        show_error "Instance name is missing."
        return
    fi

    local ssh_flag="-L 8888:127.0.0.1:8888"

    if [[ -z "$2" ]]; then
        gcush "$1" \
            --tunnel-through-iap \
            --zone="$(gcloud_configuration_get_o1_configname_o2_propertyname "" compute/zone)" \
            --ssh-flag="$ssh_flag"
        return
    fi

    gcush "$1" \
        --tunnel-through-iap \
        --zone="$(gcloud_configuration_get_o1_configname_o2_propertyname $2 compute/zone)" \
        --configuration="$2" \
        --ssh-flag="$ssh_flag"
}

_gcloud_configuration_existed_r1_configname() {
    gcloud config configurations list | awk '{print $1}' | grep "^$1$" > /dev/null 2>&1
}
