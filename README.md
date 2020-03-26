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

This will start the following components in a local k8s single node cluster:

- Kafka
- ZooKeeper
- Kafka-Connect
- MSSQL

To configure the kubeconfig in your terminal:

```sh
export KUBECONFIG=$(k3d get-kubeconfig --name=kafka-labs)
```

Once your done stop the cluster:

```sh
make stop
```

## Example

### Deploy Connectors

Make sure to forward the ports of the services:

```sh
make pf
```

In another terminal enter the following commands to install the debezium mssql plugin:

```sh
cd terraform
terraform apply
```

### Insert Data to the MSSQL Instance

Make sure to forward the ports of the services:

```sh
make pf
```

In another terminal enter the following command:

```sh
make producer
```

This will insert 3000 rows into the ship and train tables every second for the next hour.

### Listening to a kafka topic

Make sure to forward the ports of the services:

```sh
make pf
```

In another terminal enter the following command:

```sh
make listen TOPIC=main.dbo.ship
```

### Monitoring

To monitor the pod that runs kafka connect:

```sh
make monitoring
```
