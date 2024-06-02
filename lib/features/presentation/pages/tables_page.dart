import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/widgets/bd_choose_dialog.dart';
import '../../../core/theme/theme.dart';
import '../../../injection_container.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_state.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loader.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  bool kostil = false;

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
    return ScaffoldPage(
        content: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BlocProvider.of<LocalDataBloc>(context).dbName,
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: ListView(
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
                                        param1: BlocProvider.of<LocalDataBloc>(
                                                context)
                                            .state
                                            .tables![indexTable],
                                        param2: BlocProvider.of<LocalDataBloc>(
                                                context)
                                            .state
                                            .tablesColumns![indexTable]
                                            .map((column) => column.substring(
                                                0, column.indexOf('(')))
                                            .toList())
                                      ..add(const LoadTable()),
                                    child: const TableInfoPage());
                              }));
                            },
                            child: Card(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      BlocProvider.of<LocalDataBloc>(context)
                                          .state
                                          .tables![indexTable],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Row(
                                      children: List.generate(
                                        BlocProvider.of<LocalDataBloc>(context)
                                            .state
                                            .tablesColumns![indexTable]
                                            .length,
                                        (indexColumn) {
                                          return Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(BlocProvider
                                                          .of<LocalDataBloc>(
                                                              context)
                                                      .state
                                                      .tablesColumns![
                                                  indexTable][indexColumn]));
                                        },
                                      ),
                                    )
                                  ]),
                            )));
                  }),
                ))
              ],
            )));
  }
}
