import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:udbd/core/resources/data_state.dart';
import 'package:udbd/features/data/app_data_service.dart';

void main() async {
  AppDataService appDataService = AppDataService();
  await appDataService.init();
  // DataState<List<String>> result1 = await appDataService.showTables();
  // debugPrint(result1.data.toString());
  // DataState<(List<String>, Result)> result =
  //     await appDataService.readTable('users');

  String tableName = 'quest_tag';
  List<String> columns = ['quest_id', 'tag_id'];

  List<dynamic> row = [1, 5];
  // DataState<void> result =
  //     await appDataService.insertRow(tableName, columns, row);
  // debugPrint(
  //     result.data!.$2.map((element) => element.toColumnMap()).toString());
  String h = '2022-03-15 00:00:00.000Z';
  DateTime t = DateTime.parse(h);
  debugPrint(t.day.toString());
  // DataState<void> result = await appDataService.deleteRow(tableName, 11);
  // debugPrint(result.errorMessage);
}
