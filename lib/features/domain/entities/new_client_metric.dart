import 'package:equatable/equatable.dart';

class NewClientMetricEntity extends Equatable {
  const NewClientMetricEntity(
      {required this.month, required this.clientsCount});
  final String month;
  final int clientsCount;

  @override
  List<Object?> get props {
    return [month, clientsCount];
  }
}
