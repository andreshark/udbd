import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_state.dart';
import 'package:intl/intl.dart';
import 'package:udbd/features/presentation/widgets/error_snackbar.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_event.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loader.dart';
import 'edit_table_page.dart';

class TableInfoPage extends StatefulWidget {
  const TableInfoPage({super.key});

  @override
  State<TableInfoPage> createState() => _TableInfoPagetate();
}

class _TableInfoPagetate extends State<TableInfoPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TableBloc, TableState>(
      listener: (context, state) {
        if (state is TableError) {
          showErrorSnackBar(context, state.errorMessage!, 'Data error');
        }
        if (state is TableDone) {
          debugPrint('52');
          BlocProvider.of<LocalDataBloc>(context).add(const ReadTables());
        }
      },
      builder: (context, state) {
        if (state is TableLoading) {
          return const Loader();
        }

        return _buildbody(context);
      },
      buildWhen: (previous, current) {
        if (current is TableError) {
          BlocProvider.of<TableBloc>(context).add(const LoadTable());
          return false;
        }
        return true;
      },
    );
  }

  Widget _buildbody(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(BlocProvider.of<TableBloc>(context).tableName)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<TableBloc>(
                    context), // use the injected context
                child: EditTablePage(
                    columns: BlocProvider.of<TableBloc>(context).state.columns!,
                    columnsType: BlocProvider.of<TableBloc>(context)
                        .state
                        .columnsTypes!),
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            strokeWidth: 4.0,
            onRefresh: () async {
              BlocProvider.of<TableBloc>(context).add(const LoadTable());
            },
            // Pull from top to show refresh indicator.
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      showBottomBorder: true,
                      columns: List.generate(
                        BlocProvider.of<TableBloc>(context)
                            .state
                            .columns!
                            .length,
                        (index) {
                          return DataColumn(
                            label: Text(
                              BlocProvider.of<TableBloc>(context)
                                  .state
                                  .columns![index],
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          );
                        },
                      ),
                      rows: List.generate(
                          BlocProvider.of<TableBloc>(context)
                              .state
                              .rows!
                              .length, (index) {
                        return DataRow(
                          cells: List.generate(
                            BlocProvider.of<TableBloc>(context)
                                .state
                                .columns!
                                .length,
                            (indexRow) {
                              return DataCell(GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<TableBloc>(
                                          context), // use the injected context
                                      child: EditTablePage(
                                          columns: BlocProvider.of<TableBloc>(
                                                  context)
                                              .state
                                              .columns!,
                                          id: index,
                                          columnsType:
                                              BlocProvider.of<TableBloc>(
                                                      context)
                                                  .state
                                                  .columnsTypes!,
                                          row: BlocProvider.of<TableBloc>(
                                                  context)
                                              .state
                                              .rows![index]),
                                    );
                                  }));
                                },
                                child: Text(rowText(context, index, indexRow)),
                              ));
                            },
                          ),
                        );
                      })),
                ))));
  }

  String rowText(context, int index, int indexRow) {
    if (BlocProvider.of<TableBloc>(context).state.columnsTypes![indexRow] ==
        DateTime) {
      final data = BlocProvider.of<TableBloc>(context).state.rows![index]
          [BlocProvider.of<TableBloc>(context).state.columns![indexRow]];
      return data == null ? '' : DateFormat('yyyy-MM-dd').format(data);
    }

    return BlocProvider.of<TableBloc>(context)
        .state
        .rows![index]
            [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]
        .toString();
  }
}
