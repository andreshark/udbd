import 'package:equatable/equatable.dart';

abstract class TableState extends Equatable {
  final List<dynamic>? sortedRows;
  final List<bool>? interval;
  final List<List<dynamic>>? sortIntervals;
  final List<dynamic>? rows;
  final List<String>? columns;
  final List<bool>? sortValueAsc;
  final bool? sortAsc;
  final int? sortColumnIndex;
  final String? errorMessage;
  final List<Type>? columnsTypes;
  final bool? haveChange;
  final bool? editMode;

  const TableState({
    this.rows,
    this.errorMessage,
    this.columns,
    this.columnsTypes,
    this.sortValueAsc,
    this.sortColumnIndex,
    this.sortAsc,
    this.haveChange,
    this.editMode,
    this.sortedRows,
    this.interval,
    this.sortIntervals,
  });
}

class TableLoading extends TableState {
  const TableLoading();

  @override
  List<Object> get props => [];
}

class TableDone extends TableState {
  const TableDone({
    required List<dynamic> rows,
    required List<String> columns,
    required List<Type> columnsTypes,
    List<bool>? sortValueAsc,
    int? sortColumnIndex,
    bool? sortAsc,
    bool? haveChange,
    bool? editMode,
    List<dynamic>? sortedRows,
    List<bool>? interval,
    List<List<dynamic>>? sortIntervals,
  }) : super(
            rows: rows,
            columns: columns,
            columnsTypes: columnsTypes,
            sortValueAsc: sortValueAsc,
            sortColumnIndex: sortColumnIndex,
            sortAsc: sortAsc,
            haveChange: haveChange,
            editMode: editMode,
            sortedRows: sortedRows,
            interval: interval,
            sortIntervals: sortIntervals);

  // TableDone copyWith(
  //     {List<dynamic>? rows,
  //     List<String>? columns,
  //     List<Type>? columnsTypes,
  //     List<bool>? sortValueAsc,
  //     int? sortColumnIndex,
  //     bool? sortAsc}) {
  //   return TableDone(
  //     rows: rows ?? this.rows!,
  //     columns: columns ?? this.columns!,
  //     columnsTypes: columnsTypes ?? this.columnsTypes!,
  //     sortValueAsc: sortValueAsc ?? this.sortValueAsc!,
  //     sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex!,
  //     sortAsc: sortAsc ?? this.sortAsc!,
  //   );
  // }

  @override
  List<Object> get props => [
        rows!,
        sortValueAsc!,
        sortColumnIndex!,
        sortAsc!,
        haveChange!,
        editMode!,
        sortedRows!,
        interval!,
        sortIntervals!
      ];
}

class TableError extends TableState {
  const TableError(String errorMessage) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
