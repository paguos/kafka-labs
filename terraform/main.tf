provider "kafkaconnect" {
  url = "http://localhost:8083"
}

# resource "kafkaconnect_connector" "file_stream_source" {
#   name          = "jdbc-source"
#   class         = "io.confluent.connect.jdbc.JdbcSourceConnector"
#   maximum_tasks = "1"

#   configuration = {
#     "connection.url"           = "jdbc:sqlite:test.db",
#     mode                       = "incrementing",
#     "incrementing.column.name" = "id",
#     "topic.prefix"             = "test-sqlite-jdbc-",
#     name                       = "jdbc-source"
#   }
# }

resource "kafkaconnect_connector" "debezium_connector" {
  name          = "debezium-connector"
  class         = "io.debezium.connector.sqlserver.SqlServerConnector"
  maximum_tasks = "1"

  configuration = {
    "snapshot.isolation.mode"                  = "exclusive",
    "database.server.name"                     = "main",
    "database.hostname"                        = "mssql-mssql-linux.kafka",
    "database.port"                            = 1433,
    "database.user"                            = "sa",
    "database.password"                        = "M6JzVLUBprPnbTT3Ph0M",
    "database.dbname"                          = "kafka",
    "database.history.kafka.bootstrap.servers" = "cp-cp-kafka.kafka:9092",
    "database.history.kafka.topic"             = "__debezium.dbhistory",
    "table.whitelist"                          = "dbo[.]ship,dbo[.]train",
  }
}
