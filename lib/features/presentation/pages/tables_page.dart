import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/widgets/bd_choose_dialog.dart';
import 'package:window_manager/window_manager.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_state.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loader.dart';
import '../widgets/window_buttons.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> with WindowListener {
  bool kostil = false;
  List<IconData> icons = [
    FluentIcons.accounts,
    FluentIcons.car,
    FluentIcons.activate_orders,
    FluentIcons.settings,
    FluentIcons.service_activity,
    FluentIcons.page_header,
    FluentIcons.account_management,
    FluentIcons.cube_shape_solid,
    FluentIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    context.watch<AppTheme>();
    FluentTheme.of(context);
    return BlocConsumer<LocalDataBloc, LocalDataState>(
        buildWhen: (previous, current) {
      return current.runtimeType != LocalDataDbError;
    }, listener: (context, state) {
      if (state is LocalDataError) {
        showErrorDialog(context, state.errorMessage!, 'Data error');
      }
    }, builder: (context, state) {
      if (state is LocalDataWainting) {
        if (!kostil) {
          Future.delayed(
              const Duration(seconds: 1), () => chooseBdDialog(context));
        }
        kostil = true;
        return const Center(
          child: SizedBox.expand(),
        );
      }
      if (state is LocalDataLoading) {
        BlocProvider.of<LocalDataBloc>(context).add(const ReadTables());
        return const Loader();
      }

      return _buildbody(context);
    });
  }

  Widget _buildbody(BuildContext context) {
    return NavigationView(
        appBar: NavigationAppBar(
          title: () {
            const title = Text('Автосервис');

            return const DragToMoveArea(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: title,
              ),
            );
          }(),
          actions: const WindowButtons(),
        ),
        content: ScaffoldPage(
            content: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      BlocProvider.of<LocalDataBloc>(context).dbName,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                          BlocProvider.of<LocalDataBloc>(context)
                              .state
                              .tables!
                              .length, (indexTable) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(FluentPageRoute(builder: (context) {
                                    return BlocProvider<TableBloc>(
                                        create: (context) => sl(
                                            param1:
                                                BlocProvider.of<LocalDataBloc>(
                                                        context)
                                                    .state
                                                    .tables![indexTable],
                                            param2: BlocProvider.of<
                                                    LocalDataBloc>(context)
                                                .state
                                                .tablesColumns![indexTable]
                                                .map((column) =>
                                                    column.substring(
                                                        0, column.indexOf('(')))
                                                .toList())
                                          ..add(const LoadTable()),
                                        child: const TableInfoPage());
                                  }));
                                },
                                child: Card(
                                    padding: const EdgeInsets.all(20),
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Center(
                                          child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Text(
                                            BlocProvider.of<LocalDataBloc>(
                                                    context)
                                                .state
                                                .tables![indexTable],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 24),
                                          ),
                                          Opacity(
                                            opacity: 0.3,
                                            child: ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return RadialGradient(
                                                  center: Alignment.topLeft,
                                                  radius: 1.0,
                                                  colors: <Color>[
                                                    Colors.yellow,
                                                    Colors.blue
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ).createShader(bounds);
                                              },
                                              child: Icon(
                                                icons[indexTable],
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                    ))));
                      }),
                    ),
                    Spacer(),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Это база данных автомобильного сервиса. Состоит из таблиц: car, car mechanic, client, ar part, orders, orders services, services, services car part, stock. В данной программе можно удобно просматривать таблицы, сортируя данные по возрастанию, убыванию или используя индивидуальные параметры для сортировки, сортировка работает с уже имеющиемся данными, не отправляя запросы. Также можно свободно редактировать таблицы, добавлять новые записи и удалять имеющиеся. ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    Text('@Богдан Камский')
                  ],
                ))));
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    debugPrint('fwe');
    if (isPreventClose && mounted) {
      windowManager.destroy();
    }
  }
}
