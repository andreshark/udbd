import 'package:udbd/core/constants.dart';

import '../../domain/entities/order_metric.dart';

class OrderMetricModel extends OrderMetricEntity {
  const OrderMetricModel({required month, required ordersCount})
      : super(month: month, ordersCount: ordersCount);

  factory OrderMetricModel.fromJson(Map<String, dynamic> json) {
    return OrderMetricModel(
        month: months[json['month']] as String,
        ordersCount: json['orders_count'] as int);
  }
}
