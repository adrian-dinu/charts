# Prometheus Server for Stackdriver

[Prometheus](https://prometheus.io) is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community.

[Stackdriver](https://cloud.google.com/monitoring/) Monitoring collects metrics, events, and metadata from Google Cloud Platform, Amazon Web Services (AWS), hosted uptime probes, application instrumentation, and a variety of common application components including Cassandra, Nginx, Apache Web Server, Elasticsearch and many others. Stackdriver ingests that data and generates insights via dashboards, charts, and alerts.

## TL;DR;

```bash
$ helm install --name prometheus stackdriver-prometheus \
  --set "prometheus.config.projectId=..." \
  --set "prometheus.config.clusterName=..." \
  --set "prometheus.config.clusterZone=..."
```

By default this chart install 1 pod with a Prometheus server that will be able to scrape metrics data from the annotated resources inside the GKE cluster and later on propagate this data to the configured Stackdriver account.

## Introduction

This chart bootstraps a [Prometheus](https://prometheus.io) server that interacts with all the resources, correctly configured for it, deployed in the GKE cluster capturing metrics on the Prometheus format, temporary store them and eventually send them to a configured Stackdriver project for monitoring and alerting purposes; all this in a [Kubernetes](http://kubernetes.io) cluster and using the Helm package manager.

## Prerequisites

- GKE cluster 1.10+ with Beta APIs enabled
- Having Stackdriver service enabled in the GCP project were the Prometheus servers is being configured

## Installing the Chart

To install the chart

```bash
$ helm install --name prometheus stackdriver-prometheus \
  --set "prometheus.config.projectId=..." \
  --set "prometheus.config.clusterName=..." \
  --set "prometheus.config.clusterZone=..."
```

The command deploys Prometheus on the Kubernetes cluster interacting with the Stackdriver service for the configured project. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the HAProxy-Redis chart and their default values.

| Parameter                        | Description                                                                                                                  | Default                                                   |
| -------------------------------- | -----------------------------------------------------                                                                        | --------------------------------------------------------- |
| `namespace`                      | Namespace for the chart      | `prometheus`    |
| `prometheus.debug`                          | Enables debug logging for the server | `false` |
| `prometheus.config.projectId`               | Project identifier to be used for the data propagation to Stackdriver (required)  | `""` |
| `prometheus.config.clusterName`             | Cluster name to be included when propagating data (required) | `""` |
| `prometheus.config.clusterZone`             | Zone where the cluster is running (required) | `""` |
| `prometheus.config.podLabels`               | Pod labels to be propagated to Stackdriver | `[{"action":"labelmap","regex":"__meta_kubernetes_pod_label_(app.*|release.*)"}]` |
| `prometheus.config.serviceLabels`           | Service Labels to be propagated to Stackdriver | `[{"action":"labelmap","regex":"__meta_kubernetes_service_label_(app.*|release.*)"}]` |
| `image.name`                          | Prometheus image  | `gcr.io/stackdriver-prometheus/stackdriver-prometheus` |
| `image.tag`                          | Prometheus image tag | `release-0.4.3` |
| `image.pullPolicy`                          | Prometheus image pull policy | `IfNotPresent` |
| `rbac.create`                | Indicates if the chart should create RBAC permissions        |`true`|
| `serviceAccount.create`                | Indicates if the chart should create a Service Account        | `true` |
| `serviceAccount.name`                | Service Account name, if empty will generate one        | `""` |
| `service.type`                | Type of the service to be created        | `ClusterIP`|
| `service.annotations`                | Annotations for the service        | `{}`|
| `services.masterIP`                | IP for the master service (will generate one if not provided)       | `""`|
| `services.slaveIP`                | IP for the slave service (will generate one if not provided)       | `""`|

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name prometheus stackdriver-prometheus \
  --set "prometheus.config.projectId=project1" \
  --set "prometheus.config.clusterName=test" \
  --set "prometheus.config.clusterZone=us-central1-a" \
  --set "namespace=default"
```

The above command sets the Prometheus server within `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name prometheus -f values.yaml stackdriver-prometheus
```

> **Tip**: You can use the default [values.yaml](values.yaml) and add required configuration to it.
