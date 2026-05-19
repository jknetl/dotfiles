#!/usr/bin/env -S nu --stdin

# Add ArgoCD tracking annotations to Kubernetes YAML resources
# Usage: cat <manifest.yaml> | argo-annotate.nu <app-name>

def main [
    app_name: string  # The ArgoCD application name
] {
    let default_namespace = kubectl config view --minify | from yaml | get contexts | first | get context.namespace
    APP_NAME=$app_name DEFAULT_NS=$default_namespace yq '
      select(has("kind")) |= .metadata.annotations["argocd.argoproj.io/tracking-id"] = (
        env(APP_NAME) + ":" +
        (((.apiVersion // "") | select(test("/")) | capture("(?P<group>[^/]+)/.*") | .group + "/") // "/") +
        .kind + ":" +
        (.metadata.namespace // env(DEFAULT_NS)) + "/" +
        (.metadata.name // "")
      )
    '
}
