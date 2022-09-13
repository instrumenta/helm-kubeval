#! /bin/bash -e

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
            --strict|--exit-on-error|--insecure-skip-tls-verify|--openshift|--quiet|--force-color|--ignore-missing-schemas)
                kubeval_options+=("$1")
                shift
                ;;
            --kubernetes-version|--kube-version)
                kubeval_options+=(--kubernetes-version)
                kubeval_options+=("$2")
                helm_options+=(--kube-version)
                helm_options+=("$2")
                shift 2
                ;;
            --additional-schema-locations|--ignored-filename-patterns|-i|--output|-o|-v|--reject-kinds|--schema-location|-s|--skip-kinds)
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
