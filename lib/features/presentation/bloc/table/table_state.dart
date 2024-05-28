import 'package:equatable/equatable.dart';

abstract class TableState extends Equatable {
  final List<dynamic>? rows;
  final List<String>? columns;
  final String? errorMessage;
  final List<Type>? columnsTypes;

  const TableState(
      {this.rows, this.errorMessage, this.columns, this.columnsTypes});
}

class TableLoading extends TableState {
  const TableLoading();

  @override
  List<Object> get props => [];
}

class TableDone extends TableState {
  const TableDone(
      {required List<dynamic> rows,
      required List<String> columns,
      required List<Type> columnsTypes})
      : super(rows: rows, columns: columns, columnsTypes: columnsTypes);

  @override
  List<Object> get props => [rows!];
}

class TableError extends TableState {
  const TableError(String errorMessage) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
