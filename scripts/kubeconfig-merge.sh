#!/bin/bash

# Initialize variables
FORCE=0

# Function to show usage information
usage() {
    echo "Usage: $0 [-f] <path_to_config1> [path_to_config2] ..."
    exit 1
}

# Parse options
while getopts ":f" opt; do
  case ${opt} in
    f )
      FORCE=1
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Minimum one configuration file must be provided as a parameter
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path_to_config1> [path_to_config2] ..."
    exit 1
fi

# Define the kubeconfig and backup paths
KUBE_MERGE_PATH="${KUBE_MERGE_PATH:-$HOME/.kube/config}"

# Create a backup of the current kubeconfig
cp "$KUBE_MERGE_PATH" "$BACKUP_PATH"
echo "Backup of current kubeconfig created at $BACKUP_PATH"

# Build the KUBECONFIG variable with absolute paths
KUBECONFIG="$KUBE_MERGE_PATH"
for config in "$@"; do
    ABS_PATH=$(realpath "$config")  # Convert to absolute path
    KUBECONFIG="$ABS_PATH:$KUBECONFIG"
done

export KUBECONFIG

if [[ $FORCE != 1 ]]; then
  echo "Do you want to see the output and confirm the change before overwriting the current config?"
  echo "WARNING: it would show whole content of kubeconfig file INCLUDING SECRETS!"
  read -p "Do you want check output (secrets included)? (y/n) " -n 1 -r
  echo    # move to a new line

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "KUBECONFIG path: $KUBECONFIG"
    echo '==============================='
    kubectl config view --flatten
    echo '==============================='


    echo "This will merge the specified configurations into your kubeconfig and backup the current config. Check the output above"
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo    # move to a new line

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Operation cancelled."
      exit 1
    fi

  fi
fi

# Merge the configuration files with the current kubeconfig
kubectl config view --flatten > /tmp/kubeconfig_merged

# Move the merged configuration back to the original kubeconfig path
mv /tmp/kubeconfig_merged "$KUBE_MERGE_PATH"
chmod 600 "$KUBE_MERGE_PATH"
echo "Merged config saved to $KUBE_MERGE_PATH"
