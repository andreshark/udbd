import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/domain/entities/new_client_metric.dart';
import 'package:udbd/features/domain/entities/order_metric.dart';
import 'package:udbd/features/domain/entities/popular_pc_part_metric.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_state.dart';
import '../../../core/theme/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../bloc/local_data/local_data_state.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loader.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AppTheme>();
    FluentTheme.of(context);
    return BlocConsumer<MetricBloc, MetricState>(
        buildWhen: (previous, current) {
      return current.runtimeType != LocalDataDbError;
    }, listener: (context, state) {
      if (state is MetricError) {
        showErrorDialog(context, state.errorMessage!, 'Data error');
      }
    }, builder: (context, state) {
      if (state is LocalDataLoading) {
        //BlocProvider.of<LocalDataBloc>(context).add(const ReadTables());
        return const Loader();
      }

      return _buildbody(context);
    });
  }

  Widget _buildbody(BuildContext context) {
    return ScaffoldPage(
        content: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Wrap(
              children: [
                SfCartesianChart(
                  legend: Legend(isVisible: true),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                      // axisLabelFormatter: (axisLabelRenderArgs) {
                      //   return ChartAxisLabel(
                      //       NumberFormat.compact()
                      //           .format(int.parse(axisLabelRenderArgs.text)),
                      //       TextStyle());
                      // },
                      ),
                  title: const ChartTitle(
                      text: 'Количество заказов за каждый месяц в 2023'),
                  series: [
                    ColumnSeries<OrderMetricEntity, String>(
                        color: Colors.green,
                        isVisibleInLegend: true,
                        legendItemText: 'заказы',
                        dataSource: BlocProvider.of<MetricBloc>(context)
                            .state
                            .orderPerMonth,
                        // Bind data sour,
                        xValueMapper: (OrderMetricEntity orders, _) =>
                            orders.month,
                        yValueMapper: (OrderMetricEntity orders, _) =>
                            orders.ordersCount),
                    ColumnSeries<NewClientMetricEntity, String>(
                        color: Colors.yellow,
                        isVisibleInLegend: true,
                        legendItemText: 'новые клиенты',
                        dataSource: BlocProvider.of<MetricBloc>(context)
                            .state
                            .clientPerMonth,
                        // Bind data sour,
                        xValueMapper: (NewClientMetricEntity clients, _) =>
                            clients.month,
                        yValueMapper: (NewClientMetricEntity clients, _) =>
                            clients.clientsCount),
                  ],
                ),
                SfCircularChart(
                    title: const ChartTitle(
                        text: 'Наиболее частые детали в заказе'),
                    legend: const Legend(isVisible: true),
                    series: <DoughnutSeries<PcPartMetricEntity, String>>[
                      DoughnutSeries<PcPartMetricEntity, String>(
                          explode: true,
                          explodeIndex: 0,
                          dataSource: BlocProvider.of<MetricBloc>(context)
                              .state
                              .popularPcParts,
                          xValueMapper: (PcPartMetricEntity data, _) =>
                              data.name,
                          yValueMapper: (PcPartMetricEntity data, _) =>
                              data.count,
                          dataLabelMapper: (PcPartMetricEntity data, _) =>
                              data.name,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false)),
                    ])
              ],
            )));
  }
}
