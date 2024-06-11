import 'package:udbd/features/data/app_data_service.dart';
import 'package:udbd/features/data/models/new_client_metric.dart';
import 'package:udbd/features/data/models/oreder_metric.dart';
import 'package:udbd/features/data/models/popular_pc_part_metric.dart';
import '../../core/resources/data_state.dart';
import '../domain/local_data_repository.dart';

class LocalDataRepositoryImpl extends LocalDataRepository {
  LocalDataRepositoryImpl(this.appDataService);
  final AppDataService appDataService;

  @override
  deleteRow(String tableName, String columnId, int id) {
    return appDataService.deleteRow(tableName, columnId, id);
  }

  @override
  insertRow(String tableName, Map<String, dynamic> row) {
    return appDataService.insertRow(tableName, row);
  }

  @override
  updateRow(
      String tableName, String columnId, int id, Map<String, dynamic> row) {
    return appDataService.updateRow(tableName, columnId, row, id);
  }

  @override
  readTable(String tableName, String columnId) async {
    DataState response = await appDataService.readTable(tableName, columnId);
    if (response is DataSuccess) {
      List<dynamic> rows =
          response.data.map((element) => element.toColumnMap()).toList();
      return DataSuccess(rows);
    }
    return response;
  }

  @override
  loadMetrics() async {
    DataState response = await appDataService.loadMetrics();
    if (response is DataSuccess) {
      List<dynamic> data = response.data.$1
          .map((element) => OrderMetricModel.fromJson(element.toColumnMap()))
          .toList();
      List<OrderMetricModel> copyData =
          data.map((e) => e as OrderMetricModel).toList();
      List<dynamic> data2 = response.data.$2
          .map(
              (element) => NewClientMetricModel.fromJson(element.toColumnMap()))
          .toList();
      List<NewClientMetricModel> copyData1 =
          data2.map((e) => e as NewClientMetricModel).toList();
      List<dynamic> data3 = response.data.$3
          .map((element) => PcPartMetricModel.fromJson(element.toColumnMap()))
          .toList();
      List<PcPartMetricModel> copyData2 =
          data3.map((e) => e as PcPartMetricModel).toList();
      return DataSuccess((copyData, copyData1, copyData2));
    }
    return response;
  }

  @override
  showTables() {
    return appDataService.showTables();
  }

  @override
  Future<DataState> initTable(String bd, String user, String pass) {
    return appDataService.init(bd, user, pass);
  }

  @override
  Future<DataState<(List, List)>> getOrders() async {
    DataState response = await appDataService.getOrders();
    if (response is DataSuccess) {
      List<dynamic> orderRows =
          response.data.$1.map((element) => element.toColumnMap()).toList();
      List<dynamic> productRows =
          response.data.$2.map((element) => element.toColumnMap()).toList();
      return DataSuccess((orderRows, productRows));
    }
    return DataFailedMessage(response.errorMessage!);
  }
}
