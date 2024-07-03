#!/bin/bash

# Function to list all apps matching the filter
list_apps() {
    local filter=$1
    argocd app list -l "$filter" --output=name
}

print_apps() {
    local filter=$1
    local apps=$2
    echo "============================================================"
    echo "List of applications for filter:"
    echo "$filter"
    echo "============================================================"
    for app in $apps; do
        echo "  - $app"
    done
}

# Function to display diff for each app
display_diff() {
    local app=$1
    argocd app diff "$app"
}

# Function to sync all apps matching the filter
sync_apps() {
    local filter=$1
    echo "Syncing apps matching filter: $filter"
    sleep 2 # Safety sleep to allow to interrupt
    argocd app sync -l "$filter"
}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filter>"
    echo "example: argocd-review-sync.sh environment=dev"
    exit 1
fi

filter=$1
apps=$(list_apps "$filter")

print_apps $filter "$apps"

if [ -z "$apps" ]; then
    echo "No apps found matching the filter: $filter"
    exit 0
fi


for app in $apps; do
    display_diff "$app"
done

echo "============================================================"
read -p "Do you want to apply the changes? (YES to proceed): " answer
echo "============================================================"

if [ "$answer" == "YES" ]; then
  sync_apps "$filter"
else
    echo "No changes applied."
    exit 0
fi