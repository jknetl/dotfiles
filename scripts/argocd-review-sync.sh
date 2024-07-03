#!/bin/bash

if [ -z "$KUBECTL_EXTERNAL_DIFF" ]; then
  export KUBECTL_EXTERNAL_DIFF="git --no-pager diff -U1 --word-diff --word-diff-regex=."
fi

ARGOCD_OPTS="--grpc-web"
# Function to list all apps matching the filter
list_apps() {
    local filter="$1"
    argocd $ARGOCD_OPTS app list -l "$filter" --output=json | jq -r '.[] | select(.status.sync.status!="Synced") | .metadata.name'
}

print_apps() {
    local filter="$1"
    local apps="$2"
    echo "============================================================"
    echo "List of not synced applications for filter:"
    echo "$filter"
    echo "============================================================"
    for app in $apps; do
        echo "  - $app"
    done
}

# Function to display diff for each app
display_diff() {
    local app="$1"
    argocd $ARGOCD_OPTS app diff "$app"
}

# Function to sync all apps matching the filter
sync_apps() {
    local filter="$1"
    local apps="$2"

    sleep 2 # Safety sleep to allow to interrupt
    echo "Syncing out of sync apps matching filter: $filter"

    for app in $apps; do
      argocd $ARGOCD_OPTS app sync "$app"
    done

}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filter>"
    echo "example: argocd-review-sync.sh environment=dev"
    exit 1
fi

filter="$1"
apps=$(list_apps "$filter")

print_apps "$filter" "$apps"

if [ -z "$apps" ]; then
    echo "No out of sync apps found matching the filter: $filter"
    exit 0
fi


for app in $apps; do
    display_diff "$app"
done

echo "============================================================"
read -p "Do you want to apply the changes? (YES to proceed): " answer
echo "============================================================"

if [ "$answer" == "YES" ]; then
  sync_apps "$filter" "$apps"
else
    echo "No changes applied."
    exit 0
fi