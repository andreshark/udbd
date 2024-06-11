import '../../../../core/resources/data_state.dart';

abstract class LocalDataRepository {
  Future<DataState<(List<String>, List<List<String>>)>> showTables();

  Future<
      DataState<
          (
            List<dynamic>,
            List<dynamic>,
          )>> getOrders();

  Future<DataState> readTable(String tableName, String columnId);

  Future<DataState> loadMetrics();

  Future<DataState> insertRow(String tableName, Map<String, dynamic> row);

  Future<DataState> updateRow(
      String tableName, String columnId, int id, Map<String, dynamic> row);

  Future<DataState> deleteRow(String tableName, String columnId, int id);

  Future<DataState> initTable(String bd, String user, String pass);
}
