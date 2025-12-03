#!/usr/bin/env nu

# Add ArgoCD tracking annotations to Kubernetes YAML resources
# Usage: argo-annotate.nu <app-name> <input-file>

def main [
    app_name: string  # The ArgoCD application name
    input_file: string  # Path to the Kubernetes YAML file
    --in-place (-i)  # Edit file in-place (overwrite input file)
] {
    # Read the input file
    let content = open $input_file

    # Split the file by YAML document separator (---)
    let documents = $content

    # Process each document
    let annotated_docs = $documents | each { |doc|
        if ($doc | str trim | is-empty) {
            $doc
        } else {
            annotate_document $doc $app_name
        }
    }

    # Join documents back with separator
    let result = $annotated_docs | str join "---\n"

    # Write to file if in-place flag is set, otherwise print to stdout
    if $in_place {
        $result | save -f $input_file
    } else {
        $result
    }
}

# Annotate a single YAML document
def annotate_document [
    resource: record
    app_name: string
] {
    # Extract resource metadata
    let kind = $resource.kind? | default ""
    let name = $resource.metadata?.name? | default ""
    let namespace = $resource.metadata?.namespace? | default "default"

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
