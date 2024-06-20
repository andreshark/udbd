import 'package:equatable/equatable.dart';

abstract class TableEvent extends Equatable {
  final int? id;
  final Map<String, dynamic>? row;
  final int? columnIndex;
  final int? interval;
  final bool? sortAscending;
  final int? indexRow;
  final String? column;
  final value;
  const TableEvent(
      {this.row,
      this.id,
      this.sortAscending,
      this.columnIndex,
      this.indexRow,
      this.column,
      this.value,
      this.interval});
}

class DeleteRow extends TableEvent {
  const DeleteRow({required int id})
      : super(
          id: id,
        );

  @override
  List<Object> get props => [id!];
}

class EditMode extends TableEvent {
  const EditMode();

  @override
  List<Object> get props => [];
}

class ChangeIntervalMode extends TableEvent {
  const ChangeIntervalMode({required super.interval});

  @override
  List<Object> get props => [interval!];
}

class CancelChanges extends TableEvent {
  const CancelChanges();

  @override
  List<Object> get props => [];
}

class ModifSortColumn extends TableEvent {
  const ModifSortColumn({
    required super.columnIndex,
    required super.value,
  });

  @override
  List<Object> get props => [columnIndex!, value!];
}

class UpdateRow extends TableEvent {
  const UpdateRow();

  @override
  List<Object> get props => [];
}

class SortColumn extends TableEvent {
  const SortColumn({required int columnIndex, required bool sortAscending})
      : super(sortAscending: sortAscending, columnIndex: columnIndex);

  @override
  List<Object> get props => [sortAscending!, columnIndex!];
}

class DataChange extends TableEvent {
  const DataChange(
      {required var value, required int indexRow, required String column})
      : super(value: value, indexRow: indexRow, column: column);

  @override
  List<Object> get props => [sortAscending!, columnIndex!];
}

class InsertRow extends TableEvent {
  const InsertRow({required Map<String, dynamic> row}) : super(row: row);

  @override
  List<Object> get props => [row!];
}

class LoadTable extends TableEvent {
  const LoadTable();

  @override
  List<Object> get props => [];
}
