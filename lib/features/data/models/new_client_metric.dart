import 'package:udbd/core/constants.dart';
import 'package:udbd/features/domain/entities/new_client_metric.dart';

class NewClientMetricModel extends NewClientMetricEntity {
  const NewClientMetricModel({required month, required clientsCount})
      : super(month: month, clientsCount: clientsCount);

  factory NewClientMetricModel.fromJson(Map<String, dynamic> json) {
    return NewClientMetricModel(
        month: months[json['month']] as String,
        clientsCount: json['new_customers'] as int);
  }
}
