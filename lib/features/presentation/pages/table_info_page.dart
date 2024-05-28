import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_state.dart';
import 'package:window_manager/window_manager.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loader.dart';
import '../widgets/window_buttons.dart';

class TableInfoPage extends StatefulWidget {
  const TableInfoPage({super.key});

  @override
  State<TableInfoPage> createState() => _TableInfoPagetate();
}

class _TableInfoPagetate extends State<TableInfoPage> {
  @override
  Widget build(BuildContext context) {
    context.watch<AppTheme>();
    FluentTheme.of(context);
    return BlocConsumer<TableBloc, TableState>(
      listener: (context, state) {
        if (state is TableError) {
          showErrorDialog(context, state.errorMessage!, 'Data error');
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
    return NavigationView(
        appBar: NavigationAppBar(
          title: () {
            const title = Text('Postgres db');

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
            content: ListView(children: [
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              FilledButton(
                  child: Text('Add row'),
                  onPressed: () {
                    editTableDialog(
                        context1: context,
                        columns:
                            BlocProvider.of<TableBloc>(context).state.columns!,
                        columnsType: BlocProvider.of<TableBloc>(context)
                            .state
                            .columnsTypes!);
                  }),
              const SizedBox(
                width: 15,
              ),
              OutlinedButton(
                  child: const Text('Refresh'),
                  onPressed: () {
                    BlocProvider.of<TableBloc>(context).add(const LoadTable());
                  }),
            ],
          ),
          mat.DataTable(
              showBottomBorder: true,
              columns: List.generate(
                BlocProvider.of<TableBloc>(context).state.columns!.length,
                (index) {
                  return mat.DataColumn(
                    label: Text(
                      BlocProvider.of<TableBloc>(context).state.columns![index],
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  );
                },
              ),
              rows: List.generate(
                  BlocProvider.of<TableBloc>(context).state.rows!.length,
                  (index) {
                return mat.DataRow(
                  cells: List.generate(
                    BlocProvider.of<TableBloc>(context).state.columns!.length,
                    (indexRow) {
                      return mat.DataCell(GestureDetector(
                        onTap: () {
                          editTableDialog(
                              context1: context,
                              columns: BlocProvider.of<TableBloc>(context)
                                  .state
                                  .columns!,
                              columnsType: BlocProvider.of<TableBloc>(context)
                                  .state
                                  .columnsTypes!,
                              row: BlocProvider.of<TableBloc>(context)
                                  .state
                                  .rows![index]);
                        },
                        child: BlocProvider.of<TableBloc>(context)
                                        .state
                                        .columns!
                                        .length -
                                    1 ==
                                indexRow
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(rowText(context, index, indexRow)),
                                  IconButton(
                                      icon: const Icon(FluentIcons.delete),
                                      onPressed: () {
                                        BlocProvider.of<TableBloc>(context).add(
                                            DeleteRow(
                                                id: BlocProvider.of<TableBloc>(
                                                        context)
                                                    .state
                                                    .rows![index]['id']));
                                      })
                                ],
                              )
                            : Text(rowText(context, index, indexRow)),
                      ));
                    },
                  ),
                  color: mat.MaterialStateProperty.resolveWith<Color?>(
                      (Set<mat.MaterialState> states) {
                    if (states.contains(mat.MaterialState.hovered)) {
                      debugPrint('gui');
                      return index % 2 == 0
                          ? FluentTheme.of(context)
                              .accentColor
                              .withOpacity(0.18)
                          : FluentTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.18);
                    }
                    return index % 2 == 0
                        ? FluentTheme.of(context).accentColor.withOpacity(0.08)
                        : FluentTheme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.08);
                  }),
                );
              })),
        ])));
  }

  String rowText(context, int index, int indexRow) {
    if (BlocProvider.of<TableBloc>(context)
        .state
        .columns![indexRow]
        .contains('date')) {
      return DateFormat('yyyy-MM-dd').format(
          BlocProvider.of<TableBloc>(context).state.rows![index]
              [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]);
    }

    return BlocProvider.of<TableBloc>(context)
        .state
        .rows![index]
            [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]
        .toString();
  }

  void editTableDialog(
      {required BuildContext context1,
      Map<String, dynamic>? row,
      required List<String> columns,
      required List<Type> columnsType}) async {
    // ignore: unused_local_variable
    final result = await showDialog<bool>(
        context: context1,
        builder: (context) {
          Map<String, dynamic> result = {};
          List<bool> emptyText = row != null
              ? List<bool>.filled(columns.length, true)
              : List<bool>.filled(columns.length, false);
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return ContentDialog(
                actions: [
                  FilledButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (emptyText.any((element) => element == false)) {
                        return;
                      }

                      if (row == null) {
                        BlocProvider.of<TableBloc>(context1)
                            .add(InsertRow(row: result));
                      } else {
                        BlocProvider.of<TableBloc>(context1)
                            .add(UpdateRow(row: result, id: row['id']));
                      }

                      Navigator.pop(context);
                    },
                  ),
                  FilledButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                constraints: BoxConstraints(maxHeight: 600, maxWidth: 600),
                title: const Text('Редактирование строки'),
                content: Wrap(
                    children: List.generate(
                  columns.length,
                  (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(columns[index]),
                        (columnsType[index] == int ||
                                columnsType[index] == double)
                            ? NumberBox(
                                value: ((row == null)
                                    ? 0
                                    : (columnsType[index] != double)
                                        ? row[columns[index]] as int
                                        : row[columns[index]] as double),
                                smallChange:
                                    columnsType[index] == double ? 0.1 : 1,
                                onChanged: (value) {
                                  if (value == null) {
                                    emptyText[index] = false;
                                  } else {
                                    emptyText[index] = true;
                                    if (columnsType[index] != double) {
                                      result[columns[index]] =
                                          (value as double).round();
                                    }
                                  }
                                },
                              )
                            : (columnsType[index] == DateTime)
                                ? DatePicker(
                                    selected: result[columns[index]] ??
                                        ((row == null)
                                            ? null
                                            : row[columns[index]]),
                                    onChanged: (value) {
                                      result[columns[index]] = value;
                                      emptyText[index] = true;
                                      setState(() {});
                                    },
                                  )
                                : (columnsType[index] == bool)
                                    ? ComboBox<bool>(
                                        value: result[columns[index]] ??
                                            ((row == null)
                                                ? null
                                                : row[columns[index]]),
                                        items: const [
                                          ComboBoxItem(
                                            value: false,
                                            child: Text('false'),
                                          ),
                                          ComboBoxItem(
                                            value: true,
                                            child: Text('true'),
                                          )
                                        ],
                                        onChanged: (value) {
                                          result[columns[index]] = value;
                                          if (value == null) {
                                            emptyText[index] = false;
                                          } else {
                                            emptyText[index] = true;
                                          }
                                          setState(() {});
                                        },
                                      )
                                    : TextFormBox(
                                        initialValue: ((row == null)
                                            ? ''
                                            : row[columns[index]]),
                                        onChanged: (value) {
                                          result[columns[index]] = value;
                                          if (value.isEmpty) {
                                            emptyText[index] = false;
                                          } else {
                                            emptyText[index] = true;
                                          }
                                        },
                                      )
                      ],
                    );
                  },
                )));
          });
        });
  }
}
