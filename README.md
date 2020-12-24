# Kubeval Helm plugin

A [Helm](https://helm.sh/) plugin for validating Helm charts against the Kubernetes schemas, using [kubeval](https://github.com/instrumenta/kubeval).


## Installation

Install the plugin using the built-in plugin manager.

```
helm plugin install https://github.com/instrumenta/helm-kubeval
```

### Windows

On Windows, you *must* use GitBash to install (since the install script is a ".sh" file)

## Usage

As an example of usage, here is `helm kubeval` running against one of the stable charts.

```console
$ git clone git@github.com:helm/charts.git
$ helm kubeval charts/stable/nginx-ingress
The file nginx-ingress/templates/serviceaccount.yaml contains a valid ServiceAccount
The file nginx-ingress/templates/clusterrole.yaml contains a valid ClusterRole
The file nginx-ingress/templates/clusterrolebinding.yaml contains a valid ClusterRoleBinding
The file nginx-ingress/templates/role.yaml contains a valid Role
The file nginx-ingress/templates/rolebinding.yaml contains a valid RoleBinding
The file nginx-ingress/templates/controller-service.yaml contains a valid Service
The file nginx-ingress/templates/default-backend-service.yaml contains a valid Service
The file nginx-ingress/templates/controller-deployment.yaml contains a valid Deployment
The file nginx-ingress/templates/default-backend-deployment.yaml contains a valid Deployment
The file nginx-ingress/templates/controller-configmap.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-daemonset.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-hpa.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-metrics-service.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-poddisruptionbudget.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-servicemonitor.yaml contains an empty YAML document
The file nginx-ingress/templates/controller-stats-service.yaml contains an empty YAML document
The file nginx-ingress/templates/default-backend-poddisruptionbudget.yaml contains an empty YAML document
The file nginx-ingress/templates/headers-configmap.yaml contains an empty YAML document
The file nginx-ingress/templates/podsecuritypolicy.yaml contains an empty YAML document
The file nginx-ingress/templates/tcp-configmap.yaml contains an empty YAML document
The file nginx-ingress/templates/udp-configmap.yaml contains an empty YAML documen
```

You can also specify a specific Kubernetes version to validate the chart against.

```
helm kubeval . -v 1.9.0
```

Kubeval has a number of flags which can alter it's behaviour, from ignoring specific resources to
exiting on the first error to disallowing properties not specified in the schema. Kubeval options
automatically passed to Kubeval, with any other options being passed to Helm in the same way as
`helm template`. This means you could set values before validating the chart. eg.

```
helm kubeval charts/stable/nginx-ingress --set controller.image.tag=latest
```


