import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/widgets/bd_choose_dialog.dart';
import '../../../injection_container.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_state.dart';
import '../widgets/error_dialog.dart';
import '../widgets/error_snackbar.dart';
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
    return BlocConsumer<LocalDataBloc, LocalDataState>(
        buildWhen: (previous, current) {
      return current.runtimeType != LocalDataDbError;
    }, listener: (context, state) {
      if (state is LocalDataError) {
        showErrorSnackBar(context, state.errorMessage!, 'Data error');
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
        // BlocProvider.of<LocalDataBloc>(context).add(const InitTable(
        //     ));
        return const Loader();
      }

      return _buildbody(context);
    });
  }

  Widget _buildbody(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView(
                  children: List.generate(
                      BlocProvider.of<LocalDataBloc>(context)
                          .state
                          .tables!
                          .length, (indexTable) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).push(MaterialPageRoute(builder: (context) {
                            return BlocProvider<TableBloc>(
                                create: (context) => sl(
                                    param1:
                                        BlocProvider.of<LocalDataBloc>(context)
                                            .state
                                            .tables![indexTable],
                                    param2:
                                        BlocProvider.of<LocalDataBloc>(context)
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
                          child: ListTile(
                              title: Text(
                                BlocProvider.of<LocalDataBloc>(context)
                                    .state
                                    .tables![indexTable],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              subtitle: Wrap(
                                children: List.generate(
                                  BlocProvider.of<LocalDataBloc>(context)
                                      .state
                                      .tablesColumns![indexTable]
                                      .length,
                                  (indexColumn) {
                                    return Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                            BlocProvider.of<LocalDataBloc>(
                                                        context)
                                                    .state
                                                    .tablesColumns![indexTable]
                                                [indexColumn]));
                                  },
                                ),
                              )),
                        ));
                  }),
                ))
              ],
            )));
  }
}
