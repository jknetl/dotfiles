#!/usr/bin/env nu

# Define the path for the final merged kubeconfig file
let rancher_config_file = $env.RANCHER_CONFIG_FILE? | default $"($env.HOME)/.kube/rancher-clusters.yaml"

# Get the list of clusters from rancher, and parse it into a table
let clusters = (rancher cluster ls --format '{{.Cluster.Name}}/{{.Cluster.ID}}' | lines | split column "/" | rename name id | where {|c| $c.name != "local" })

print $"Found ($clusters | length) clusters in rancher."

print "Fetching kubeconfigs for all clusters..."
sleep 0.5sec
# Fetch kubeconfigs in parallel
let kubeconfigs = ($clusters | par-each -t 10 { |cluster|
    print $"Fetching kubeconfig for cluster: ($cluster.name)"
    rancher clusters kubeconfig ($cluster.id) ($cluster.name) | from yaml
})

print "All kubeconfigs downloaded. Merging them to single file"
# Initialize the structure for the merged kubeconfig
let kubeconfig = {
    apiVersion: "v1",
    kind: "Config",
    preferences: {},
    clusters: [],
    users: [],
    contexts: [],
    "current-context": ""
}

# Set the current-context from the first kubeconfig
let kubeconfig = $kubeconfig | upsert "current-context" ($kubeconfigs.0."current-context")

# Merge clusters, users, and contexts from all kubeconfigs
let kubeconfig = $kubeconfig | upsert "clusters" ($kubeconfigs | get clusters | flatten)
let kubeconfig = $kubeconfig | upsert "users" ($kubeconfigs | get users | flatten)
let kubeconfig = $kubeconfig | upsert "contexts" ($kubeconfigs | get contexts | flatten)

# Save the merged kubeconfig to the file
$kubeconfig | to yaml | save -f $rancher_config_file

print $"Successfully merged all kubeconfigs to ($rancher_config_file)"
