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
    # TBD
    # --cluster-name (-n): string, # Optional: Alternative name for the cluster (if it doesn't contain context name)
    # --user-name (-n): string, # Optional: Alternative name for the user (if it doesn't contain context name)
] {
    let kubeconfig_path = if not ($config | is-empty) {
        $config | path expand
    } else if not ($env.KUBECONFIG | is-empty) {
        $env.KUBECONFIG | split row : | first
    } else {
        $"($env.HOME)/.kube/config"
    }

    print $"Using kubeconfig file at: '($kubeconfig_path)'"
    if not ($kubeconfig_path | path exists) {
        error make { msg: $"Error: Kubeconfig file not found at '($kubeconfig_path)'" }
    }

    # Open the YAML file. Nushell automatically parses it into a structured table.
    let kubeconfig = cat $kubeconfig_path | from yaml

    # ---  Check for Existence of Entries ---
    # Verify that the context, cluster, and user we want to remove actually exist.
    # We use `get -o` to safely access keys that might not exist, preventing the script from crashing.
    # If any entry is missing, we throw a specific error and stop execution.
    if ($kubeconfig | get -o contexts | where name == $clustername | is-empty) {
        error make { msg: $"Error: context '($clustername)' not found in '($kubeconfig_path)'" }
    }
    if ($kubeconfig | get -o clusters | where name =~ $clustername | is-empty) {
        error make { msg: $"Error: cluster '($clustername)' not found in '($kubeconfig_path)'" }
    }
    if ($kubeconfig | get -o users | where name =~ $clustername | is-empty) {
        error make { msg: $"Error: user '($clustername)' not found in '($kubeconfig_path)'" }
    }


    # ---  Remove Entries from the Data Structure ---
    let new_contexts = $kubeconfig | get -o contexts | where name != $clustername
    let new_clusters = $kubeconfig | get -o clusters | where {|row| not ($row.name | str contains $clustername) }
    let new_users = $kubeconfig | get -o users  | where {|row| not ($row.name | str contains $clustername) }

    # Now, build the new kubeconfig record by inserting the filtered lists.
    # The `insert` command will overwrite the existing keys with the new values.
    let modified_kubeconfig = $kubeconfig
        | update contexts $new_contexts
        | update clusters $new_clusters
        | update users $new_users

    # As a safety measure, if the context being removed was the active one,
    # clear the 'current-context' field to avoid an invalid configuration file.
    let modified_kubeconfig = if ($modified_kubeconfig."current-context" == $clustername) {
        $modified_kubeconfig | update "current-context" ""
    } else {
        $modified_kubeconfig
    }

    # --- Save Modified Kubeconfig ---
    # Save the modified data structure back to the original file path, overwriting it.
    $modified_kubeconfig | to yaml | save -f $kubeconfig_path
}

