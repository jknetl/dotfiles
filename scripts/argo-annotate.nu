#!/usr/bin/env -S nu --stdin

# Add ArgoCD tracking annotations to Kubernetes YAML resources
# Usage: cat <manifest.yaml> | argo-annotate.nu <app-name>


let default_namespace = kubectl config view --minify | from yaml | get contexts | first | get context.namespace

def main [
    app_name: string  # The ArgoCD application name
] {
    let annotated_docs = $in
        | split row "---\n"
        | where { |doc| not ($doc | str trim | is-empty) }
        | each { |doc| $doc | from yaml }
        | where { |doc| $doc != null }
        | each { |doc| annotate_document $doc $app_name }

    $annotated_docs | str join "---\n"
}

# Annotate a single YAML document
def annotate_document [
    resource: record
    app_name: string
] {
    # Extract resource metadata
    let kind = $resource.kind? | default ""
    let name = $resource.metadata?.name? | default ""
    let namespace = $resource.metadata?.namespace? | default $default_namespace

    # Determine the API group (for core resources like Service, it's empty)
    let api_version = $resource.apiVersion? | default ""
    let group = if ($api_version | str contains "/") {
        $api_version | split row "/" | first
    } else {
        ""
    }

    # Build the tracking ID
    let tracking_id = if ($group | is-empty) {
        $"($app_name):/($kind):($namespace)/($name)"
    } else {
        $"($app_name):($group)/($kind):($namespace)/($name)"
    }

    # Add or update the tracking annotation
    let updated_resource = if ($resource.metadata?.annotations? | is-empty) {
        $resource | upsert metadata.annotations {
            "argocd.argoproj.io/tracking-id": $tracking_id
        }
    } else {
        $resource | upsert metadata.annotations {
            $resource.metadata.annotations | insert "argocd.argoproj.io/tracking-id" $tracking_id
        }
    }

    # Convert back to YAML
    $updated_resource | to yaml
}
