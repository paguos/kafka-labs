# Kafka Labs

Experiments with [kafka](https://kafka.apache.org/) and the [kafka confluent platform](https://docs.confluent.io/current/platform.html).

## Requirements

- [asdf](https://github.com/asdf-vm/asdf) version manager
- [helm plugin](https://github.com/Antiarchitect/asdf-helm) for asdf
- [Docker](https://www.docker.com/) 
- [k3d](https://github.com/rancher/k3d) dockerized k3s helper

## Setup

To setup a local run the following command:

```sh
make start
```

Configure the kube-config in your terminal:

```sh
export KUBECONFIG=$(k3d get-kubeconfig --name=kafka-labs)
```

Once your done stop the cluster:

```sh
make stop
```
