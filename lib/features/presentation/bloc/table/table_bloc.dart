import 'package:udbd/features/domain/usecases/delete_row.dart';
import 'package:udbd/features/domain/usecases/insert_row.dart';
import 'package:udbd/features/domain/usecases/load_table.dart';
import 'package:udbd/features/domain/usecases/update_row.dart';
import 'table_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'table_event.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final LoadTableUseCase _loadTableUseCase;
  final DeleteRowUseCase _deleteRowUseCase;
  final InsertRowUseCase _insertRowUseCase;
  final UpdateRowUseCase _updateRowUseCase;
  final String tableName;

  TableBloc(this._loadTableUseCase, this._deleteRowUseCase,
      this._insertRowUseCase, this.tableName, this._updateRowUseCase)
      : super(const TableLoading()) {
    on<UpdateRow>(updateRow);
    on<InsertRow>(insertRow);
    on<DeleteRow>(deleteRow);
    on<LoadTable>(loadTable);
  }

  Future<void> updateRow(UpdateRow event, Emitter<TableState> emit) async {
    final dataState =
        await _updateRowUseCase(params: (tableName, event.row!, event.id!));
    if (dataState is DataSuccess) {
      List<dynamic> rows = List<dynamic>.of(state.rows!);
      rows[rows.indexWhere((element) => element['id'] == event.id)] =
          (rows.firstWhere((element) => element['id'] == event.id)
                  as Map<String, dynamic>)
              .map((key, value) => event.row!.keys.contains(key)
                  ? MapEntry(key, event.row![key])
                  : MapEntry(key, value));
      emit(TableDone(
          rows: rows,
          columns: state.columns!,
          columnsTypes: state.columnsTypes!));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }

  Future<void> insertRow(InsertRow event, Emitter<TableState> emit) async {
    final dataState = await _insertRowUseCase(params: (tableName, event.row!));
    if (dataState is DataSuccess) {
      emit(TableDone(
          rows: List<dynamic>.of(state.rows!)..add(event.row),
          columns: state.columns!,
          columnsTypes: state.columnsTypes!));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }

  Future<void> deleteRow(DeleteRow event, Emitter<TableState> emit) async {
    final dataState = await _deleteRowUseCase(params: (tableName, event.id!));
    if (dataState is DataSuccess) {
      emit(TableDone(
          rows: List<dynamic>.of(state.rows!)
            ..removeAt(state.rows!
                .indexWhere((element) => element['id'] == event.id!)),
          columns: state.columns!,
          columnsTypes: state.columnsTypes!));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }

  Future<void> loadTable(LoadTable event, Emitter<TableState> emit) async {
    final dataState = await _loadTableUseCase(params: tableName);
    if (dataState is DataSuccess) {
      List<String> columns =
          (dataState.data[0] as Map<String, dynamic>).keys.toList();
      emit(TableDone(
          rows: dataState.data,
          columnsTypes: List.generate(
              columns.length,
              (index) => (dataState.data[0] as Map<String, dynamic>)
                  .values
                  .toList()[index]
                  .runtimeType),
          columns: columns));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }
}
