import 'package:equatable/equatable.dart';
import 'package:udbd/features/domain/entities/new_client_metric.dart';
import 'package:udbd/features/domain/entities/order_metric.dart';
import 'package:udbd/features/domain/entities/popular_pc_part_metric.dart';

abstract class MetricState extends Equatable {
  final List<OrderMetricEntity>? orderPerMonth;
  final List<NewClientMetricEntity>? clientPerMonth;
  final List<PcPartMetricEntity>? popularPcParts;
  final String? errorMessage;

  const MetricState(
      {this.orderPerMonth,
      this.clientPerMonth,
      this.popularPcParts,
      this.errorMessage});
}

class MetricLoading extends MetricState {
  const MetricLoading();

  @override
  List<Object> get props => [];
}

class MetricDataDone extends MetricState {
  const MetricDataDone(
      {required List<OrderMetricEntity> orderPerMonth,
      required List<NewClientMetricEntity> clientPerMonth,
      required List<PcPartMetricEntity> popularPcParts})
      : super(
            orderPerMonth: orderPerMonth,
            clientPerMonth: clientPerMonth,
            popularPcParts: popularPcParts);

  @override
  List<Object> get props => [orderPerMonth!, clientPerMonth!, popularPcParts!];
}

class MetricError extends MetricState {
  const MetricError(String errorMessage) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
