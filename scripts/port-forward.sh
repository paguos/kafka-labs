#!/usr/bin/env bash
set -eu -o pipefail

killall kubectl || true

info() {
    echo '[INFO] ' "$@"
}

info "kafka on http://localhost:9092"
kubectl -n kafka port-forward service/cp-cp-kafka 9092:9092 &

info "zookeeper on http://localhost:2181"
kubectl -n kafka port-forward service/cp-cp-zookeeper 2181:2181 &

info "kafka-connect on http://localhost:8083"
kubectl -n kafka port-forward service/cp-cp-kafka-connect 8083:8083 &

info "msqll on http://localhost:1433"
kubectl -n kafka port-forward service/mssql-mssql-linux 1433:1433 
