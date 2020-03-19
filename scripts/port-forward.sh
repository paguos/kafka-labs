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

info "schema-registry on http://localhost:8081"
kubectl -n kafka port-forward service/cp-cp-schema-registry 8081:8081 &

info "kafka-rest on http://localhost:8082"
kubectl -n kafka port-forward service/cp-cp-kafka-rest 8082:8082 &

info "kafka-connect on http://localhost:8083"
kubectl -n kafka port-forward service/cp-cp-kafka-connect 8083:8083 &

info "ksql-server on http://localhost:8088"
kubectl -n kafka port-forward service/cp-cp-ksql-server 8088:8088 &

info "control-center on http://localhost:9091"
kubectl -n kafka port-forward service/cp-cp-control-center 9021:9021