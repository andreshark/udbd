import 'package:udbd/features/domain/entities/popular_pc_part_metric.dart';

class PcPartMetricModel extends PcPartMetricEntity {
  const PcPartMetricModel({required name, required count})
      : super(name: name, count: count);

  factory PcPartMetricModel.fromJson(Map<String, dynamic> json) {
    return PcPartMetricModel(
        name: json['name'] as String, count: json['total_orders'] as int);
  }
}
