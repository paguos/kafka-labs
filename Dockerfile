FROM confluentinc/cp-kafka-connect-base:5.4.1

RUN  confluent-hub install --no-prompt debezium/debezium-connector-sqlserver:1.0.0