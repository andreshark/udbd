import '../../../../core/resources/data_state.dart';

abstract class LocalDataRepository {
  Future<DataState<(List<String>, List<List<String>>)>> showTables();

  Future<DataState> readTable(String tableName);

  Future<DataState> insertRow(String tableName, Map<String, dynamic> row);

  Future<DataState> updateRow(
      String tableName, int id, Map<String, dynamic> row);

  Future<DataState> deleteRow(String tableName, int id);
}
