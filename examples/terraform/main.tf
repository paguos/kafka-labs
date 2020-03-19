provider "kafkaconnect" {
  url = "http://localhost:8083"
}

resource "kafkaconnect_connector" "file_stream_source" {
  name          = "jdbc-source"
  class         = "io.confluent.connect.jdbc.JdbcSourceConnector"
  maximum_tasks = "1"

  configuration = {
    "connection.url"           = "jdbc:sqlite:test.db",
    mode                       = "incrementing",
    "incrementing.column.name" = "id",
    "topic.prefix"             = "test-sqlite-jdbc-",
    name                       = "jdbc-source"
  }
}
