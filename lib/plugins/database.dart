import 'package:mysql_client/mysql_client.dart';

class Database {

  static MySQLConnection? _conn;

  static final Database _instance = Database._internal();
  factory Database() => _instance;
  Database._internal();

  Future<void> connect() async {
    if (_conn == null || !_conn!.connected) {
      _conn = await MySQLConnection.createConnection(
        host: "192.168.100.7",
        port: 3309,
        userName: "root",
        password: "root",
        databaseName: "test",
      );
      await _conn!.connect();
    }
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await connect();
    final columns = data.keys.join(", ");
    final values = data.values.map((v) => "'$v'").join(", ");

    final sql = "INSERT INTO $table ($columns) VALUES ($values)";
    await _conn!.execute(sql);
  }

  Future<void> update(String table, Map<String, dynamic> data, String where) async {
    await connect();
    final updates = data.entries.map((e) => "${e.key} = '${e.value}'").join(", ");
    final sql = "UPDATE $table SET $updates WHERE $where";
    await _conn!.execute(sql);
  }

  Future<List<Map<String, dynamic>>> select(String sql) async {
    await connect();
    final results = await _conn!.execute(sql);

    List<Map<String, dynamic>> rows = [];

    for (final row in results.rows) {
      // This returns a Map<String, dynamic> with column names and values
      final rowData = row.typedAssoc(); 
      rows.add(rowData);
    }

    return rows;
  }

  Future<void> delete(String table, String where) async {
    await connect();
    final sql = "DELETE FROM $table WHERE $where";
    await _conn!.execute(sql);
  }
}