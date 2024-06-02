import 'package:equatable/equatable.dart';

abstract class LocalDataState extends Equatable {
  final List<String>? tables;
  final List<List<String>>? tablesColumns;
  final String? errorMessage;
  final String? dbName;

  const LocalDataState(
      {this.tables, this.tablesColumns, this.errorMessage, this.dbName});
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
      {required List<String> tables, required List<List<String>> tablesColumns})
      : super(tables: tables, tablesColumns: tablesColumns);

  @override
  List<Object> get props => [tables!, tablesColumns!];
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
