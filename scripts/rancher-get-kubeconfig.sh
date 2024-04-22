#!/bin/bash
#

# Check if cluster name is provided as an argument
if [ $# -ne 2 ]; then
  echo "Usage: $0 <cluster_name> <output_file>"
  exit 1
fi


read -r cluster_id cluster_name <<< $(rancher cluster ls --format  '{{.Cluster.ID}} {{.Cluster.Name}}' | grep $1)

rancher clusters kubeconfig $cluster_id $cluster_name > $2

