import 'package:postgres/postgres.dart';
import '../../../../../core/resources/data_state.dart';

class AppDataService {
  Future<DataState> init(String bd, String user, String pass) async {
    try {
      conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: bd,
          username: user,
          password: pass,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      return const DataSuccess(true);
    } catch (e) {
      return DataFailedMessage(e.toString());
    }
  }

  late Connection conn;

  Future<DataState<(List<String>, List<List<String>>)>> showTables() async {
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

  Future<DataState<Result>> readTable(String tableName, String columnId) async {
    try {
      final result1 = await conn
          .execute('SELECT * FROM $tableName ORDER BY $columnId ASC ');
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

  Future<DataState> updateRow(String tableName, String columnId,
      Map<String, dynamic> row, int id) async {
    try {
      List<String> columns = row.keys.toList();
      String args = '';

      for (int i = 0; i < columns.length; i++) {
        args += '${columns[i]}=@${columns[i]}';
        if (i + 1 != columns.length) {
          args += ',';
        }
      }

      await conn.execute(
          Sql.named('UPDATE $tableName SET $args WHERE $columnId=$id'),
          parameters: row);
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState> deleteRow(String tableName, String columnId, int id) async {
    try {
      await conn.execute('DELETE FROM $tableName WHERE $columnId = $id');
      return const DataSuccess(true);
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }

  Future<DataState> loadMetrics() async {
    try {
      // сколько заказов за каждый месяц в 23
      final result = await conn.execute(Sql.named('''
SELECT EXTRACT(MONTH FROM start_date) AS month, COUNT(order_id) AS orders_count
FROM orders
WHERE EXTRACT(YEAR FROM start_date) = 2023
GROUP BY EXTRACT(MONTH FROM start_date)
ORDER BY EXTRACT(MONTH FROM start_date);
'''));
// количество новых клиентов впервые сделавших заказ по месяцам в 23
      final result1 = await conn.execute(Sql.named('''
SELECT EXTRACT(MONTH FROM d.first_order_date) AS month,
       COUNT(DISTINCT d.client_id) AS new_customers
FROM (
    SELECT client_id,
           MIN(start_date) AS first_order_date
    FROM orders
    GROUP BY client_id
) as d
GROUP BY EXTRACT(MONTH FROM d.first_order_date)
ORDER BY month;
'''));
      // Наиболее частая деталь в заказе
      final result2 = await conn.execute(Sql.named('''
SELECT pc_part.pc_part_id, name, COUNT(*) AS total_orders
FROM  public.pc_part
JOIN public.services_pc_part ON pc_part.pc_part_id = services_pc_part.pc_part_id
JOIN public.orders_services ON services_pc_part.service_id = orders_services.service_id
GROUP BY pc_part.pc_part_id, name
ORDER BY total_orders DESC
'''));

      return DataSuccess((result, result1, result2));
    } on ServerException catch (e) {
      return DataFailedMessage(e.message.toString());
    }
  }
}
