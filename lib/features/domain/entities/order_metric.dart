import 'package:equatable/equatable.dart';

class OrderMetricEntity extends Equatable {
  const OrderMetricEntity({required this.month, required this.ordersCount});
  final String month;
  final int ordersCount;

  @override
  List<Object?> get props {
    return [month, ordersCount];
  }
}
