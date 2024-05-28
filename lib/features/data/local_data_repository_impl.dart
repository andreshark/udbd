import 'package:udbd/features/data/app_data_service.dart';
import '../../core/resources/data_state.dart';
import '../domain/local_data_repository.dart';

class LocalDataRepositoryImpl extends LocalDataRepository {
  LocalDataRepositoryImpl(this.appDataService);
  final AppDataService appDataService;

  @override
  deleteRow(String tableName, int id) {
    return appDataService.deleteRow(tableName, id);
  }

  @override
  insertRow(String tableName, Map<String, dynamic> row) {
    return appDataService.insertRow(tableName, row);
  }

  @override
  updateRow(String tableName, int id, Map<String, dynamic> row) {
    return appDataService.updateRow(tableName, row, id);
  }

  @override
  readTable(String tableName) async {
    DataState response = await appDataService.readTable(tableName);
    if (response is DataSuccess) {
      List<dynamic> rows =
          response.data.map((element) => element.toColumnMap()).toList();
      return DataSuccess(rows);
    }
    return response;
  }

  @override
  showTables() {
    return appDataService.showTables();
  }
}
