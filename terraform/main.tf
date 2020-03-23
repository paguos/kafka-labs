provider "kafka-connect" {
  url = "http://localhost:8083"
}

# resource "kafka-connect_connector" "sqlite-sink" {
#   name = "sqlite-sink"

#   config = {
#     "name"            = "sqlite-sink"
#     "connector.class" = "io.confluent.connect.jdbc.JdbcSinkConnector"
#     "tasks.max"       = 1
#     "topics"          = "orders"
#     "connection.url"  = "jdbc:sqlite:test.db"
#     "auto.create"     = "true"
#     "connection.user" = "admin"
#   }

#   config_sensitive = {
#     "connection.password" = "this-should-never-appear-unmasked"
#   }
# }

resource "kafka-connect_connector" "debezium_connector" {
  name = "debezium-connector"
  config = {
    name                                       = "debezium-connector"
    "connector.class"                          = "io.debezium.connector.sqlserver.SqlServerConnector"
    "tasks.max"                                = 1
    "snapshot.isolation.mode"                  = "exclusive"
    "database.server.name"                     = "main"
    "database.hostname"                        = "mssql-mssql-linux.kafka"
    "database.port"                            = 1433
    "database.user"                            = "sa"
    "database.dbname"                          = "kafka"
    "database.history.kafka.bootstrap.servers" = "cp-cp-kafka.kafka:9092"
    "database.history.kafka.topic"             = "__debezium.dbhistory"
    "table.whitelist"                          = "dbo[.]ship,dbo[.]train"
  }

  config_sensitive = {
    "database.password" = "M6JzVLUBprPnbTT3Ph0M"
  }
}
