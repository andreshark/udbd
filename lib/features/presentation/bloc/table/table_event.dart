import 'package:equatable/equatable.dart';

abstract class TableEvent extends Equatable {
  final int? id;
  final Map<String, dynamic>? row;
  const TableEvent({this.row, this.id});
}

class DeleteRow extends TableEvent {
  const DeleteRow({required int id})
      : super(
          id: id,
        );

  @override
  List<Object> get props => [id!];
}

class UpdateRow extends TableEvent {
  const UpdateRow({required Map<String, dynamic> row, required int id})
      : super(id: id, row: row);

  @override
  List<Object> get props => [id!, row!];
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
