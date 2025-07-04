#!/usr/bin/env nu
# A Nushell script to remove a context, cluster, and user from a kubeconfig file.
#
# The script takes one required argument, which is the name of the entries to remove.
# It assumes the context, cluster, and user all share the same name.

# Usage:
#   nu remove-kube-context.nu <cluster-name>
#
# With a specific config file:
#   nu remove-kube-context.nu <cluster-name> -c /path/to/your/kube/config

def main [
    clustername: string,          # The name of the context, cluster, and user to remove
    --config (-c): string,        # Optional: Path to the kubeconfig file to modify
] {
    let kubeconfig_path = if not ($config | is-empty) {
        $config
    } else if not ($env.KUBECONFIG | is-empty) {
        $env.KUBECONFIG | split row (char path-sep) | first
    } else {
        $"($env.HOME)/.kube/config"
    }

    if not ($kubeconfig_path | path exists) {
        error make { msg: $"Error: Kubeconfig file not found at '($kubeconfig_path)'" }
    }

    # Open the YAML file. Nushell automatically parses it into a structured table.
    let kubeconfig = open $kubeconfig_path

    # ---  Check for Existence of Entries ---
    # Verify that the context, cluster, and user we want to remove actually exist.
    # We use `get -i` to safely access keys that might not exist, preventing the script from crashing.
    # If any entry is missing, we throw a specific error and stop execution.
    if ($kubeconfig | get -i contexts | where name == $clustername | is-empty) {
        error make { msg: $"Error: context '($clustername)' not found in '($kubeconfig_path)'" }
    }
    if ($kubeconfig | get -i clusters | where name == $clustername | is-empty) {
        error make { msg: $"Error: cluster '($clustername)' not found in '($kubeconfig_path)'" }
    }
    if ($kubeconfig | get -i users | where name == $clustername | is-empty) {
        error make { msg: $"Error: user '($clustername)' not found in '($kubeconfig_path)'" }
    }

    # ---  Remove Entries from the Data Structure ---
    # Use the `update` command to replace the `contexts`, `clusters`, and `users` lists
    # with new versions that have the specified entries filtered out.
    let modified_kubeconfig = $kubeconfig
        | update contexts {|contexts_table| $contexts_table | where name != $clustername }
        | update clusters {|clusters_table| $clusters_table | where name != $clustername }
        | update users   {|users_table|    $users_table    | where name != $clustername }

    # As a safety measure, if the context being removed was the active one,
    # clear the 'current-context' field to avoid an invalid configuration file.
    let modified_kubeconfig = if ($modified_kubeconfig."current-context" == $clustername) {
        $modified_kubeconfig | update "current-context" ""
    } else {
        $modified_kubeconfig
    }

    # --- Save Modified Kubeconfig ---
    # Save the modified data structure back to the original file path, overwriting it.
    $modified_kubeconfig | save -f $kubeconfig_path
}

