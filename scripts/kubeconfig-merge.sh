#!/bin/bash

# Minimum one configuration file must be provided as a parameter
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path_to_config1> [path_to_config2] ..."
    exit 1
fi

# Define the kubeconfig and backup paths
KUBECONFIG_PATH="$HOME/.kube/config"
BACKUP_PATH="${KUBECONFIG_PATH}.$(date +%Y-%m-%d_%H-%M-%S).bak"

# Create a backup of the current kubeconfig
cp $KUBECONFIG_PATH $BACKUP_PATH
echo "Backup of current kubeconfig created at $BACKUP_PATH"

# Build the KUBECONFIG variable with absolute paths
KUBECONFIG="$KUBECONFIG_PATH"
for config in "$@"; do
    ABS_PATH=$(realpath "$config")  # Convert to absolute path
    KUBECONFIG="$KUBECONFIG:$ABS_PATH"
done

export KUBECONFIG

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

# Merge the configuration files with the current kubeconfig
kubectl config view --flatten > /tmp/kubeconfig_merged

# Move the merged configuration back to the original kubeconfig path
mv /tmp/kubeconfig_merged $KUBECONFIG_PATH
chmod 600 $KUBECONFIG_PATH
echo "Merged config saved to $KUBECONFIG_PATH"
