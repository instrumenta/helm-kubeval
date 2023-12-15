#!/bin/sh -e

helm_options=()
kubeval_options=()
eoo=0

while [[ $1 ]]
do
    if ! ((eoo)); then
        case "$1" in
            --version|--help)
                $HELM_PLUGIN_DIR/bin/kubeval $1
                exit
                ;;
            --strict|--exit-on-error|--openshift|--force-color|--ignore-missing-schemas)
                kubeval_options+=("$1")
                shift
                ;;
            --output|-o|--kubernetes-version|-v|--schema-location|-s|--skip-kinds)
                kubeval_options+=("$1")
                kubeval_options+=("$2")
                shift 2
                ;;
            *)
                helm_options+=("$1")
                shift
                ;;
        esac
    else
        helm_options+=("$1")
        shift
    fi
done

render=$(helm template "${helm_options[@]}")

echo "$render" | $HELM_PLUGIN_DIR/bin/kubeval "${kubeval_options[@]}"
