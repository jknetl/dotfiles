#!/bin/bash

clusters=$(rancher cluster ls --format '{{.Cluster.Name}}/{{.Cluster.ID}}')

RANCHER_KUBECONFIG_FILE="${RANCHER_KUBECONFIG_FILE:=~/.kube/rancher-clusters.yaml}"

#echo "Clearing the currrent contnent of the kubeconfig file: $RANCHER_KUBECONFIG_FILE"
#echo "" > $RANCHER_KUBECONFIG_FILE

config_files=()

function get_config_from_rancher() {
    TEMPFILE=$(mktemp -t rancher-kubeconfig)
    rancher clusters kubeconfig $cluster_id $cluster_name > $TEMPFILE
    echo $TEMPFILE
}

for cluster in $clusters; do
  cluster_name=$(echo $cluster | cut -d'/' -f1)
  cluster_id=$(echo $cluster | cut -d'/' -f2)
  echo "Getting kubeconfig for cluster: $cluster ($cluster_id)"
  config_file=$(get_config_from_rancher $cluster_name $cluster_id)
  config_files+=($config_file)
done

for config_file in "${config_files[@]}"; do
  echo "Merging kubeconfig file: $config_file"
  kubeconfig-merge.sh -f $config_file
done