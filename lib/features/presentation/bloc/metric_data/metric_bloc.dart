import 'package:udbd/features/domain/usecases/load_metrics.dart';
import 'metric_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'metric_event.dart';

class MetricBloc extends Bloc<MetricsEvent, MetricState> {
  final LoadMetricsUseCase _loadMetricsUseCase;
  late final String dbName;

  MetricBloc(this._loadMetricsUseCase) : super(const MetricLoading()) {
    on<LoadMetrics>(loadMetrics);
  }

  Future<void> loadMetrics(LoadMetrics event, Emitter<MetricState> emit) async {
    final dataState = await _loadMetricsUseCase();
    if (dataState is DataSuccess) {
      emit(MetricDataDone(
          orderPerMonth: dataState.data.$1,
          clientPerMonth: dataState.data.$2,
          popularPcParts: dataState.data.$3));
    }

    if (dataState is DataFailedMessage) {
      emit(MetricError(dataState.errorMessage!));
    }
  }
}
