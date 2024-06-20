import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:udbd/features/domain/usecases/delete_row.dart';
import 'package:udbd/features/domain/usecases/insert_row.dart';
import 'package:udbd/features/domain/usecases/load_table.dart';
import 'package:udbd/features/domain/usecases/update_row.dart';
import 'table_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'table_event.dart';
import 'package:collection/collection.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final LoadTableUseCase _loadTableUseCase;
  final DeleteRowUseCase _deleteRowUseCase;
  final InsertRowUseCase _insertRowUseCase;
  final UpdateRowUseCase _updateRowUseCase;
  final String tableName;
  late TableState initState;
  final List<String> columns;

  TableBloc(
      this._loadTableUseCase,
      this._deleteRowUseCase,
      this._insertRowUseCase,
      this._updateRowUseCase,
      this.tableName,
      this.columns)
      : super(const TableLoading()) {
    on<UpdateRow>(updateRow);
    on<InsertRow>(insertRow);
    on<DeleteRow>(deleteRow);
    on<LoadTable>(loadTable);
    on<SortColumn>(sortColumn);
    on<DataChange>(dataChange);
    on<EditMode>(editMode);
    on<ChangeIntervalMode>(changeIntervalMode);
    on<ModifSortColumn>(modifSortColumn);
    on<CancelChanges>(cancelChanges);
  }

  Future<void> cancelChanges(
      CancelChanges event, Emitter<TableState> emit) async {
    emit(TableDone(
        rows: initState.rows!,
        columns: state.columns!,
        columnsTypes: state.columnsTypes!,
        sortAsc: state.sortAsc,
        sortColumnIndex: state.sortColumnIndex,
        sortValueAsc: state.sortValueAsc,
        haveChange: false,
        editMode: true,
        sortedRows: state.sortedRows,
        interval: state.interval,
        sortIntervals: state.sortIntervals));
  }

  Future<void> modifSortColumn(
      ModifSortColumn event, Emitter<TableState> emit) async {
    List<List<dynamic>> sortIntervals = List.from(state.sortIntervals!);
    sortIntervals[event.columnIndex!] = (event.value.length == 1)
        ? (event.value[0].runtimeType == String)
            ? [event.value[0]]
            : [event.value[0], sortIntervals[event.columnIndex!][1]]
        : event.value;
    List<dynamic> sortedrows = List.generate(state.rows!.length,
        (int index) => Map<String, dynamic>.from(state.rows![index]));

    for (int i = 0; i < sortIntervals.length; i++) {
      if (sortIntervals[i][0].runtimeType == String) {
        sortedrows = sortedrows
            .where((row) => (row[state.columns![i]] as String)
                .contains(sortIntervals[i][0]))
            .toList();
      }
      if (sortIntervals[i][0].runtimeType == int) {
        if (state.interval![i] == false) {
          sortedrows = sortedrows.where((row) {
            return row[state.columns![i]] == sortIntervals[i][0];
          }).toList();
        } else {
          sortedrows = sortedrows
              .where((row) =>
                  row[state.columns![i]] >= sortIntervals[i][0] &&
                  row[state.columns![i]] <= sortIntervals[i][1])
              .toList();
        }
      }
      if (sortIntervals[i][0].runtimeType == DateTime) {
        if (state.interval![i] == false) {
          sortedrows = sortedrows.where((row) {
            return DateFormat('yyyy-MM-dd').format(row[state.columns![i]]) ==
                DateFormat('yyyy-MM-dd').format(sortIntervals[i][0]);
          }).toList();
        } else {
          sortedrows = sortedrows
              .where((row) =>
                  row[state.columns![i]].compareTo(sortIntervals[i][0]) == 1 &&
                  row[state.columns![i]].compareTo(sortIntervals[i][1]) == -1)
              .toList();
        }
      }
    }
    emit(TableDone(
        rows: state.rows!,
        columns: state.columns!,
        columnsTypes: state.columnsTypes!,
        sortAsc: state.sortAsc,
        sortColumnIndex: state.sortColumnIndex,
        sortValueAsc: state.sortValueAsc,
        haveChange: state.haveChange,
        editMode: state.editMode!,
        sortedRows: sortedrows,
        interval: state.interval,
        sortIntervals: sortIntervals));
  }

  Future<void> changeIntervalMode(
      ChangeIntervalMode event, Emitter<TableState> emit) async {
    List<bool> interval = List.from(state.interval!);
    interval[event.interval!] = !interval[event.interval!];

    emit(TableDone(
        rows: state.rows!,
        columns: state.columns!,
        columnsTypes: state.columnsTypes!,
        sortAsc: state.sortAsc,
        sortColumnIndex: state.sortColumnIndex,
        sortValueAsc: state.sortValueAsc,
        haveChange: state.haveChange,
        editMode: state.editMode!,
        sortedRows: state.sortedRows,
        interval: interval,
        sortIntervals: state.sortIntervals));
  }

  Future<void> editMode(EditMode event, Emitter<TableState> emit) async {
    emit(TableDone(
        rows: initState.rows!,
        columns: state.columns!,
        columnsTypes: state.columnsTypes!,
        sortAsc: state.sortAsc,
        sortColumnIndex: state.sortColumnIndex,
        sortValueAsc: state.sortValueAsc,
        haveChange: false,
        editMode: !state.editMode!,
        sortedRows: state.sortedRows,
        interval: state.interval,
        sortIntervals: state.sortIntervals));
  }

  Future<void> updateRow(UpdateRow event, Emitter<TableState> emit) async {
    if (initState != state) {
      final dataState =
          await _updateRowUseCase(params: (tableName, state.rows!));

      if (dataState is DataSuccess) {
        emit(TableDone(
            rows: state.rows!,
            columns: state.columns!,
            columnsTypes: state.columnsTypes!,
            sortAsc: state.sortAsc,
            sortColumnIndex: state.sortColumnIndex,
            sortValueAsc: state.sortValueAsc,
            haveChange: true,
            editMode: false,
            sortedRows: state.sortedRows,
            interval: state.interval,
            sortIntervals: state.sortIntervals));
        initState = TableDone(
            rows: state.rows!,
            columns: state.columns!,
            columnsTypes: state.columnsTypes!,
            sortAsc: state.sortAsc,
            sortColumnIndex: state.sortColumnIndex,
            sortValueAsc: state.sortValueAsc,
            haveChange: true,
            editMode: false,
            sortedRows: state.sortedRows,
            interval: state.interval,
            sortIntervals: state.sortIntervals);
      }

      if (dataState is DataFailedMessage) {
        emit(TableError(dataState.errorMessage!));
      }
    } else {
      emit(initState);
    }
  }

  Future<void> dataChange(DataChange event, Emitter<TableState> emit) async {
    final List<dynamic> rows = List.generate(state.rows!.length,
        (int index) => Map<String, dynamic>.from(state.rows![index]));

    if (event.value is DateTime) {
      debugPrint(
          '${initState.rows![event.indexRow!][event.column!].month}      ${event.value.month}');
      debugPrint(
          '${initState.rows![event.indexRow!][event.column!].year}      ${event.value.year}');
      debugPrint(
          '${initState.rows![event.indexRow!][event.column!].day}      ${event.value.day}');
      if (initState.rows![event.indexRow!][event.column!].month !=
              event.value.month ||
          initState.rows![event.indexRow!][event.column!].year !=
              event.value.year ||
          initState.rows![event.indexRow!][event.column!].day !=
              event.value.day) {
        rows[event.indexRow!][event.column!] = event.value;
      } else {
        rows[event.indexRow!][event.column!] =
            initState.rows![event.indexRow!][event.column!];
      }
    } else {
      rows[event.indexRow!][event.column!] = event.value;
    }

    if (!const DeepCollectionEquality().equals(rows, initState.rows)) {
      emit(TableDone(
          rows: rows,
          columns: columns,
          columnsTypes: state.columnsTypes!,
          sortAsc: state.sortAsc,
          sortColumnIndex: state.sortColumnIndex,
          sortValueAsc: state.sortValueAsc,
          haveChange: true,
          editMode: state.editMode,
          sortedRows: state.sortedRows,
          interval: state.interval,
          sortIntervals: state.sortIntervals));
    } else {
      emit(TableDone(
          rows: initState.rows!,
          columns: columns,
          columnsTypes: state.columnsTypes!,
          sortAsc: state.sortAsc,
          sortColumnIndex: state.sortColumnIndex,
          sortValueAsc: state.sortValueAsc,
          haveChange: false,
          editMode: state.editMode,
          sortedRows: state.sortedRows,
          interval: state.interval,
          sortIntervals: state.sortIntervals));
    }
  }

  Future<void> sortColumn(SortColumn event, Emitter<TableState> emit) async {
    bool sortAsc;
    int? sortColumnIndex;
    List<bool> sortValueAsc = List.of(state.sortValueAsc!);
    if (event.columnIndex == state.sortColumnIndex) {
      sortAsc = event.sortAscending!;
      sortValueAsc[event.columnIndex!] = event.sortAscending!;
    } else {
      sortColumnIndex = event.columnIndex!;
      sortAsc = state.sortValueAsc![event.columnIndex!];
    }
    List<dynamic> rows = List.of(state.rows!)
      ..sort((a, b) => a[state.columns![event.columnIndex!]]
          .compareTo(b[state.columns![event.columnIndex!]]));
    if (!sortAsc) {
      rows = rows.reversed.toList();
    }
    emit(TableDone(
        rows: rows,
        columns: state.columns!,
        columnsTypes: state.columnsTypes!,
        sortAsc: sortAsc,
        sortColumnIndex: sortColumnIndex ?? state.sortColumnIndex,
        sortValueAsc: sortValueAsc,
        haveChange: state.haveChange,
        editMode: state.editMode,
        sortedRows: state.sortedRows,
        interval: state.interval,
        sortIntervals: state.sortIntervals));
  }

  Future<void> insertRow(InsertRow event, Emitter<TableState> emit) async {
    final dataState = await _insertRowUseCase(params: (tableName, event.row!));
    final List<dynamic> rows = List<dynamic>.of(state.rows!)..add(event.row);
    if (dataState is DataSuccess) {
      emit(TableDone(
          rows: rows,
          columns: state.columns!,
          columnsTypes: state.columnsTypes!,
          sortAsc: state.sortAsc,
          sortColumnIndex: state.sortColumnIndex,
          sortValueAsc: state.sortValueAsc,
          haveChange: false,
          editMode: false,
          sortedRows: const [],
          interval: List.filled(columns.length, false),
          sortIntervals: List.generate(columns.length, (index) {
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is String) {
              return [''];
            }
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is int) {
              int min = 999999999999;
              int max = -999999999999;
              for (int i = 0; i < rows.length; i++) {
                min = min > rows[i][columns[i]] ? rows[i][columns[i]] : min;
                max = max < rows[i][columns[i]] ? rows[i][columns[i]] : max;
              }
              return [min, max];
            }
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is DateTime) {
              DateTime min = DateTime(2030);
              DateTime max = DateTime(2000);
              for (int i = 0; i < rows.length; i++) {
                if (min.compareTo(rows[i][columns[i]]) > 0) {
                  min = rows[i][columns[i]];
                }

                if (max.compareTo(rows[i][columns[i]]) < 0) {
                  max = rows[i][columns[i]];
                }
              }
              return [min, max];
            }
            return [];
          })));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }

  Future<void> deleteRow(DeleteRow event, Emitter<TableState> emit) async {
    final dataState = await _deleteRowUseCase(
        params: (tableName, columns[0], state.rows![event.id!][columns[0]]!));
    if (dataState is DataSuccess) {
      List<dynamic> rows = List<dynamic>.of(state.rows!)..removeAt(event.id!);

      emit(TableDone(
          rows: rows,
          columns: state.columns!,
          columnsTypes: state.columnsTypes!,
          sortAsc: state.sortAsc,
          sortColumnIndex: state.sortColumnIndex,
          sortValueAsc: state.sortValueAsc,
          haveChange: false,
          editMode: false,
          sortedRows: const [],
          interval: List.filled(columns.length, false),
          sortIntervals: List.generate(columns.length, (index) {
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is String) {
              return [''];
            }
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is int) {
              int min = 999999999999;
              int max = -999999999999;
              for (int i = 0; i < rows.length; i++) {
                min = min > rows[i][columns[i]] ? rows[i][columns[i]] : min;
                max = max < rows[i][columns[i]] ? rows[i][columns[i]] : max;
              }
              return [min, max];
            }
            if ((rows[0] as Map<String, dynamic>)
                .values
                .toList()[index]
                .runtimeType is DateTime) {
              DateTime min = DateTime(2030);
              DateTime max = DateTime(2000);
              for (int i = 0; i < rows.length; i++) {
                if (min.compareTo(rows[i][columns[i]]) > 0) {
                  min = rows[i][columns[i]];
                }

                if (max.compareTo(rows[i][columns[i]]) < 0) {
                  max = rows[i][columns[i]];
                }
              }
              return [min, max];
            }
            return [];
          })));
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }

  Future<void> loadTable(LoadTable event, Emitter<TableState> emit) async {
    final dataState = await _loadTableUseCase(params: (tableName, columns[0]));
    if (dataState is DataSuccess) {
      initState = TableDone(
          rows: dataState.data,
          columnsTypes: List.generate(
              (dataState.data as List<dynamic>).isNotEmpty ? columns.length : 0,
              (index) => (dataState.data[0] as Map<String, dynamic>)
                  .values
                  .toList()[index]
                  .runtimeType),
          columns: columns,
          sortAsc: true,
          sortColumnIndex: 0,
          sortValueAsc: List.filled(columns.length, true),
          haveChange: false,
          editMode: false,
          sortedRows: const [],
          interval: List.filled(columns.length, true),
          sortIntervals: List.generate(columns.length, (index) {
            if ((dataState.data[0] as Map<String, dynamic>)
                    .values
                    .toList()[index]
                    .runtimeType ==
                String) {
              return [''];
            }
            if ((dataState.data[0] as Map<String, dynamic>)
                    .values
                    .toList()[index]
                    .runtimeType ==
                int) {
              int min = 999999999999;
              int max = -999999999999;
              for (int i = 0; i < dataState.data.length; i++) {
                min = min > dataState.data[i][columns[index]]
                    ? dataState.data[i][columns[index]]
                    : min;
                max = max < dataState.data[i][columns[index]]
                    ? dataState.data[i][columns[index]]
                    : max;
              }
              return [min, max];
            }
            if ((dataState.data[0] as Map<String, dynamic>)
                    .values
                    .toList()[index]
                    .runtimeType ==
                DateTime) {
              DateTime min = DateTime(2030);
              DateTime max = DateTime(2000);
              for (int i = 0; i < dataState.data.length; i++) {
                if (dataState.data[i][columns[index]] != null) {
                  if (min.compareTo(dataState.data[i][columns[index]]) > 0) {
                    min = dataState.data[i][columns[index]];
                  }

                  if (max.compareTo(dataState.data[i][columns[index]]) < 0) {
                    max = dataState.data[i][columns[index]];
                  }
                }
              }
              return [min, max];
            }
            return [];
          }));
      emit(initState);
    }

    if (dataState is DataFailedMessage) {
      emit(TableError(dataState.errorMessage!));
    }
  }
}
