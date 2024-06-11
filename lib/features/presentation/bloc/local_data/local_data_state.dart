import 'package:equatable/equatable.dart';

abstract class LocalDataState extends Equatable {
  final List<String>? tables;
  final List<List<String>>? tablesColumns;
  final String? errorMessage;
  final String? dbName;
  final List<dynamic>? product_rows;
  final List<dynamic>? order_rows;

  const LocalDataState(
      {this.product_rows,
      this.order_rows,
      this.tables,
      this.tablesColumns,
      this.errorMessage,
      this.dbName});
}

class LocalDataLoading extends LocalDataState {
  const LocalDataLoading();

  @override
  List<Object> get props => [];
}

class LocalDataWainting extends LocalDataState {
  const LocalDataWainting();

  @override
  List<Object> get props => [];
}

class LocalDataDone extends LocalDataState {
  const LocalDataDone(
      {required List<String> tables,
      required List<List<String>> tablesColumns,
      required List<dynamic> product_rows,
      required List<dynamic> order_rows})
      : super(
            tables: tables,
            tablesColumns: tablesColumns,
            product_rows: product_rows,
            order_rows: order_rows);

  @override
  List<Object> get props =>
      [tables!, tablesColumns!, product_rows!, order_rows!];
}

class LocalDataError extends LocalDataState {
  const LocalDataError(String errorMessage) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class LocalDataDbError extends LocalDataState {
  const LocalDataDbError(String errorMessage)
      : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
