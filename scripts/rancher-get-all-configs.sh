#!/bin/bash

RANCHER_CONFIG_FILE="${RANCHER_CONFIG_FILE:-$HOME/.kube/rancher-clusters.yaml}"
FETCHED_CONFIG_FILES=$(mktemp -t rancher-kubeconfig-list)
PARALLELISM_LIMIT=10

clusters=$(rancher cluster ls --format '{{.Cluster.Name}}/{{.Cluster.ID}}')

touch $RANCHER_CONFIG_FILE


function get_config_from_rancher() {
    TEMPFILE=$(mktemp -t rancher-kubeconfig)
    rancher clusters kubeconfig $cluster_id $cluster_name > $TEMPFILE
    echo $TEMPFILE
}

for cluster in $clusters; do
  cluster_name=$(echo $cluster | cut -d'/' -f1)
  cluster_id=$(echo $cluster | cut -d'/' -f2)

    {
      echo "Getting kubeconfig for cluster: $cluster ($cluster_id)"
      config_file=$(get_config_from_rancher $cluster_name $cluster_id)
      echo $config_file >> $FETCHED_CONFIG_FILES
    } &
    ((counter++))
    if [ $counter -ge $PARALLELISM_LIMIT ]; then
      wait
      counter=0
    else
      sleep 0.2 # In order not to create whole batch almost at once
    fi
done
wait

while IFS= read -r line; do
  config_files+=("$line")
done < $FETCHED_CONFIG_FILES
rm $FETCHED_CONFIG_FILES

echo "Merging to kubeconfig file..."
for config_file in "${config_files[@]}"; do
  KUBE_MERGE_PATH="$RANCHER_CONFIG_FILE" kubeconfig-merge.sh -f $config_file > /dev/null
done
