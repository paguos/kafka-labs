# Kafka Connect - Rest Api

Create and retrieve resources using the Kafka Connect - Rest Api.

## Connectors

Retrieve a list of the connectors:

```sh
curl localhost:8083/connectors
```

Create a connector:

```sh
curl --header "Content-Type: application/json" \
  --request POST \
  --data "@examples/rest-api/jdbc-connector.json" \
  localhost:8083/connectors
```

Delete a connector:

```sh
curl --request DELETE localhost:8083/connectors/jdbc-source
```
