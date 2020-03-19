# Kafka Labs

Experiments with [kafka](https://kafka.apache.org/) and the [kafka confluent platform](https://docs.confluent.io/current/platform.html) running on top of kubernetes.

## Requirements

- [asdf](https://github.com/asdf-vm/asdf) version manager
- [helm](https://github.com/Antiarchitect/asdf-helm) and [terraform](https://github.com/Banno/asdf-hashicorp) plugins for asdf
- [Docker](https://www.docker.com/)
- [k3d](https://github.com/rancher/k3d) dockerized k3s helper

Before beginning with the setup run the following command:

```sh
asdf install
```

## Setup

To setup a local run the following command:

```sh
make start
```

To configure the kube-config in your terminal:

```sh
export KUBECONFIG=$(k3d get-kubeconfig --name=kafka-labs)
```

Once your done stop the cluster:

```sh
make stop
```

## Examples

Before you start make sure to forward the ports of the services:

```sh
make pf
```

Continue with one of the following examples:

- [Rest Api](examples/rest-api/README.md)
- [Terraform](examples/terraform/README.md)