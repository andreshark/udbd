import 'package:postgres/postgres.dart';
import '../../../../../core/resources/data_state.dart';

class AppDataService {
  Future<DataState> init() async {
    try {
      conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'forum',
          username: 'postgres',
          password: 'password',
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  late final Connection conn;

  Future<DataState<(List<String>, List<List<String>>)>> showTables() async {
    DataState datastate = await init();
    if (datastate is DataFailedMessage) {
      return datastate as DataFailedMessage<(List<String>, List<List<String>>)>;
    }
    try {
      List<List<String>> tablesColumns = [];
      final result0 = await conn.execute(
          "SELECT * FROM pg_catalog.pg_tables WHERE schemaname='public';");
      final tableNames =
          result0.map((element) => element[1] as String).toList();
      for (String name in tableNames) {
        final result1 = await conn.execute('''
SELECT
    pg_attribute.attname AS column_name,
    pg_catalog.format_type(pg_attribute.atttypid, pg_attribute.atttypmod) AS data_type
FROM
    pg_catalog.pg_attribute
INNER JOIN
    pg_catalog.pg_class ON pg_class.oid = pg_attribute.attrelid
INNER JOIN
    pg_catalog.pg_namespace ON pg_namespace.oid = pg_class.relnamespace
WHERE
    pg_attribute.attnum > 0
    AND NOT pg_attribute.attisdropped
    AND pg_class.relname = '$name'
ORDER BY
    attnum ASC;''');
        tablesColumns.add(
            result1.map((element) => '${element[0]}(${element[1]})').toList());
      }
      return DataSuccess((tableNames, tablesColumns));
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState<Result>> readTable(String tableName) async {
    try {
      final result1 = tableName.contains('_')
          ? await conn.execute('SELECT * FROM $tableName')
          : await conn.execute('SELECT * FROM $tableName ORDER BY id ASC ');
      return DataSuccess(result1);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState<void>> insertRow(
      String tableName, Map<String, dynamic> row) async {
    List<String> columns = row.keys.toList();
    String args = '';
    String col = '';
    try {
      for (int i = 0; i < columns.length; i++) {
        args += '@${columns[i]}';
        col += columns[i];
        if (i + 1 != columns.length) {
          args += ',';
          col += ',';
        }
      }

      await conn.execute(
        Sql.named('INSERT INTO $tableName ($col) VALUES ($args)'),
        parameters: row,
      );
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState> updateRow(
      String tableName, Map<String, dynamic> row, int id) async {
    try {
      List<String> columns = row.keys.toList();
      String args = '';

      for (int i = 0; i < columns.length; i++) {
        args += '${columns[i]}=@${columns[i]}';
        if (i + 1 != columns.length) {
          args += ',';
        }
      }

      await conn.execute(Sql.named('UPDATE $tableName SET $args WHERE id=$id'),
          parameters: row);
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState> deleteRow(String tableName, int id) async {
    try {
      await conn.execute('DELETE FROM $tableName WHERE id = $id');
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }
}
