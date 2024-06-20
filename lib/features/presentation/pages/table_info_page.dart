import 'dart:ffi';
import 'dart:ui';
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
//import 'package:data_table_2/data_table_2.dart';

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
        if (state is TableDone) {
          //BlocProvider.of<MetricBloc>(context).add(const LoadMetrics());
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
// var myColumns = [
//       new mat.DataColumn(label: new Text('name')),
//       new mat.DataColumn(label: new Text('age')),
//       new mat.DataColumn(label: new Text('Hight')),
//     ];

//     var myRows = [
//       new mat.DataRow(cells: [
//         new mat.DataCell(new Text('George')),
//         new mat.DataCell(new Text('18')),
//         new mat.DataCell(new Text('173cm')),
//       ]),
//       new mat.DataRow(cells: [
//         new mat.DataCell(new Text('Dave')),
//         new mat.DataCell(new Text('21')),
//         new mat.DataCell(new Text('183cm')),
//       ]),
//       new mat.DataRow(cells: [
//         new mat.DataCell(new Text('Sam')),
//         new mat.DataCell(new Text('55')),
//         new mat.DataCell(new Text('170cm')),
//       ])
//     ];

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
            content: ListView(children: [
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Tooltip(
                message: 'Add new row',
                child: IconButton(
                    icon: Icon(
                      FluentIcons.add,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      editTableDialog(
                          context1: context,
                          columns: BlocProvider.of<TableBloc>(context)
                              .state
                              .columns!,
                          columnsType: BlocProvider.of<TableBloc>(context)
                              .state
                              .columnsTypes!);
                    }),
              ),
              Tooltip(
                  message: 'Refresh table',
                  child: IconButton(
                      icon: Icon(
                        FluentIcons.refresh,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        BlocProvider.of<TableBloc>(context)
                            .add(const LoadTable());
                      })),
              SizedBox(
                width: 20,
              ),
              Divider(
                size: 20,
                style: DividerThemeData(
                    thickness: 2,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.5))),
                direction: Axis.vertical,
              ),
              SizedBox(
                width: 20,
              ),
              ToggleSwitch(
                  checked: BlocProvider.of<TableBloc>(context).state.editMode!,
                  content: const Text(
                    'Edit mode',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      //color: Colors.blue
                    ),
                  ),
                  onChanged: (value) {
                    BlocProvider.of<TableBloc>(context).add(const EditMode());
                  }),
              BlocProvider.of<TableBloc>(context).state.editMode!
                  ? Tooltip(
                      message: 'apply changes',
                      child: IconButton(
                          icon: Icon(
                            FluentIcons.accept,
                            color: BlocProvider.of<TableBloc>(context)
                                    .state
                                    .haveChange!
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: () {
                            BlocProvider.of<TableBloc>(context)
                                    .state
                                    .haveChange!
                                ? BlocProvider.of<TableBloc>(context)
                                    .add(const UpdateRow())
                                : null;
                          }))
                  : const SizedBox.shrink(),
              BlocProvider.of<TableBloc>(context).state.editMode!
                  ? Tooltip(
                      message: 'cancel changes',
                      child: IconButton(
                          icon: Icon(
                            FluentIcons.chrome_close,
                            color: BlocProvider.of<TableBloc>(context)
                                    .state
                                    .haveChange!
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            BlocProvider.of<TableBloc>(context)
                                    .state
                                    .haveChange!
                                ? BlocProvider.of<TableBloc>(context)
                                    .add(const CancelChanges())
                                : null;
                          }))
                  : const SizedBox.shrink(),
            ],
          ),
          mat.Material(
            child: mat.DataTable(
                headingRowColor: mat.MaterialStatePropertyAll(Colors.blue),
                // dataRowColor:
                //     mat.MaterialStatePropertyAll(Colors.grey.withOpacity(0.2)),
                headingTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                border: TableBorder.all(color: Colors.black),
                sortColumnIndex:
                    BlocProvider.of<TableBloc>(context).state.sortColumnIndex,
                sortAscending:
                    BlocProvider.of<TableBloc>(context).state.sortAsc!,
                showBottomBorder: true,
                columns: List.generate(
                  BlocProvider.of<TableBloc>(context).state.columns!.length,
                  (index) {
                    final contextController = FlyoutController();
                    final contextAttachKey = GlobalKey();

                    return mat.DataColumn(
                      label: GestureDetector(
                          onSecondaryTapUp: (d) {
                            // This calculates the position of the flyout according to the parent navigator
                            final targetContext =
                                contextAttachKey.currentContext;
                            if (targetContext == null) return;
                            final box =
                                targetContext.findRenderObject() as RenderBox;
                            final position = box.localToGlobal(
                              d.localPosition,
                              ancestor: Navigator.of(context)
                                  .context
                                  .findRenderObject(),
                            );

                            contextController.showFlyout(
                              placementMode: FlyoutPlacementMode.topCenter,
                              barrierColor: Colors.black.withOpacity(0),
                              position: position,
                              builder: (context1) {
                                return FlyoutContent(
                                    child: BlocProvider.value(
                                  value: BlocProvider.of<TableBloc>(context),
                                  child: BlocBuilder<TableBloc, TableState>(
                                      builder: (context2, state) {
                                    return (BlocProvider.of<TableBloc>(context)
                                                .state
                                                .columnsTypes![index] ==
                                            int)
                                        ? SizedBox(
                                            width: BlocProvider.of<TableBloc>(
                                                            context)
                                                        .state
                                                        .interval![index] ==
                                                    false
                                                ? 200
                                                : 400,
                                            height: BlocProvider.of<TableBloc>(
                                                            context)
                                                        .state
                                                        .interval![index] ==
                                                    false
                                                ? 70
                                                : 100,
                                            child: Column(
                                              children: [
                                                BlocProvider.of<TableBloc>(
                                                                context)
                                                            .state
                                                            .interval![index] ==
                                                        false
                                                    ? SizedBox(
                                                        width: 180,
                                                        height: 30,
                                                        child: NumberBox(
                                                            value: BlocProvider.of<
                                                                            TableBloc>(
                                                                        context)
                                                                    .state
                                                                    .sortIntervals![
                                                                index][0] as int,
                                                            onChanged: (value) {
                                                              value != null
                                                                  ? BlocProvider.of<
                                                                              TableBloc>(
                                                                          context)
                                                                      .add(ModifSortColumn(
                                                                          columnIndex:
                                                                              index,
                                                                          value: [
                                                                          value
                                                                        ]))
                                                                  : BlocProvider.of<TableBloc>(context).add(ModifSortColumn(
                                                                      columnIndex:
                                                                          index,
                                                                      value: BlocProvider.of<TableBloc>(
                                                                              context)
                                                                          .initState
                                                                          .sortIntervals![index][0]));
                                                            }),
                                                      )
                                                    : Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 180,
                                                            height: 30,
                                                            child: NumberBox(
                                                                value: BlocProvider.of<TableBloc>(
                                                                            context)
                                                                        .state
                                                                        .sortIntervals![index]
                                                                    [0] as int,
                                                                onChanged:
                                                                    (value) {
                                                                  BlocProvider.of<
                                                                              TableBloc>(
                                                                          context)
                                                                      .add(ModifSortColumn(
                                                                          columnIndex:
                                                                              index,
                                                                          value: [
                                                                        value,
                                                                        BlocProvider.of<TableBloc>(context)
                                                                            .state
                                                                            .sortIntervals![index][1]
                                                                      ]));
                                                                }),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            height: 30,
                                                            child: NumberBox(
                                                                value: BlocProvider.of<TableBloc>(
                                                                            context)
                                                                        .state
                                                                        .sortIntervals![index]
                                                                    [1] as int,
                                                                onChanged:
                                                                    (value) {
                                                                  BlocProvider.of<
                                                                              TableBloc>(
                                                                          context)
                                                                      .add(ModifSortColumn(
                                                                          columnIndex:
                                                                              index,
                                                                          value: [
                                                                        BlocProvider.of<TableBloc>(context)
                                                                            .state
                                                                            .sortIntervals![index][0],
                                                                        value
                                                                      ]));
                                                                }),
                                                          ),
                                                        ],
                                                      ),
                                                BlocProvider.of<TableBloc>(context)
                                                            .state
                                                            .interval![index] ==
                                                        true
                                                    ? mat.RangeSlider(
                                                        divisions: BlocProvider.of<TableBloc>(context).initState.sortIntervals![index][1] -
                                                            BlocProvider.of<TableBloc>(context).initState.sortIntervals![index]
                                                                [0],
                                                        values: mat.RangeValues(
                                                            BlocProvider.of<TableBloc>(context)
                                                                .state
                                                                .sortIntervals![index]
                                                                    [0]
                                                                .toDouble(),
                                                            BlocProvider.of<TableBloc>(context)
                                                                .state
                                                                .sortIntervals![index]
                                                                    [1]
                                                                .toDouble()),
                                                        min: BlocProvider.of<TableBloc>(context)
                                                            .initState
                                                            .sortIntervals![index]
                                                                [0]
                                                            .toDouble(),
                                                        max: BlocProvider.of<TableBloc>(context)
                                                            .initState
                                                            .sortIntervals![index][1]
                                                            .toDouble(),
                                                        onChanged: (value) {
                                                          BlocProvider.of<
                                                                      TableBloc>(
                                                                  context)
                                                              .add(ModifSortColumn(
                                                                  columnIndex:
                                                                      index,
                                                                  value: [
                                                                value.start
                                                                    .round(),
                                                                value.end
                                                                    .round()
                                                              ]));
                                                        })
                                                    : const SizedBox.shrink(),
                                                BlocProvider.of<TableBloc>(
                                                                context)
                                                            .state
                                                            .interval![index] ==
                                                        false
                                                    ? const SizedBox(
                                                        height: 15,
                                                      )
                                                    : const SizedBox.shrink(),
                                                Checkbox(
                                                    content: const Text(
                                                        'interval mode'),
                                                    checked: BlocProvider.of<
                                                            TableBloc>(context)
                                                        .state
                                                        .interval![index],
                                                    onChanged: (value) {
                                                      BlocProvider.of<
                                                                  TableBloc>(
                                                              context)
                                                          .add(
                                                              ChangeIntervalMode(
                                                                  interval:
                                                                      index));
                                                    }),
                                              ],
                                            ))
                                        : (BlocProvider.of<TableBloc>(context)
                                                    .state
                                                    .columnsTypes![index] ==
                                                DateTime)
                                            ? SizedBox(
                                                width: 200,
                                                height: 80,
                                                child: Column(
                                                  children: [
                                                    BlocProvider.of<TableBloc>(
                                                                        context)
                                                                    .state
                                                                    .interval![
                                                                index] ==
                                                            false
                                                        ? DatePicker(
                                                            selected: BlocProvider
                                                                    .of<TableBloc>(
                                                                        context)
                                                                .state
                                                                .sortIntervals![index][0],
                                                            onChanged:
                                                                (datetime) {
                                                              BlocProvider.of<
                                                                          TableBloc>(
                                                                      context)
                                                                  .add(ModifSortColumn(
                                                                      columnIndex:
                                                                          index,
                                                                      value: [
                                                                    datetime
                                                                  ]));
                                                            },
                                                          )
                                                        : FilledButton(
                                                            child: const Text(
                                                                'Choose Interval'),
                                                            onPressed:
                                                                () async {
                                                              DateTimeRange?
                                                                  dataTimeRange =
                                                                  await mat
                                                                      .showDateRangePicker(
                                                                initialEntryMode:
                                                                    mat.DatePickerEntryMode
                                                                        .input,
                                                                context:
                                                                    context,
                                                                firstDate: BlocProvider.of<
                                                                            TableBloc>(
                                                                        context)
                                                                    .initState
                                                                    .sortIntervals![index][0],
                                                                lastDate: BlocProvider.of<
                                                                            TableBloc>(
                                                                        context)
                                                                    .initState
                                                                    .sortIntervals![index][1],
                                                              );
                                                              if (dataTimeRange !=
                                                                  null) {
                                                                BlocProvider.of<
                                                                            TableBloc>(
                                                                        context)
                                                                    .add(ModifSortColumn(
                                                                        columnIndex:
                                                                            index,
                                                                        value: [
                                                                      dataTimeRange
                                                                          .start,
                                                                      dataTimeRange
                                                                          .end
                                                                    ]));
                                                              }
                                                            }),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Checkbox(
                                                        content: const Text(
                                                            'interval mode'),
                                                        checked: BlocProvider
                                                                .of<TableBloc>(
                                                                    context)
                                                            .state
                                                            .interval![index],
                                                        onChanged: (value) {
                                                          BlocProvider.of<
                                                                      TableBloc>(
                                                                  context)
                                                              .add(ChangeIntervalMode(
                                                                  interval:
                                                                      index));
                                                        }),
                                                  ],
                                                ))
                                            : SizedBox(
                                                width: 200,
                                                height: 50,
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        const Text('Find text'),
                                                        SizedBox(
                                                          width: 180,
                                                          height: 30,
                                                          child: TextFormBox(
                                                            initialValue: BlocProvider
                                                                    .of<TableBloc>(
                                                                        context)
                                                                .state
                                                                .sortIntervals![index][0],
                                                            onChanged: (value) {
                                                              BlocProvider.of<
                                                                          TableBloc>(
                                                                      context)
                                                                  .add(ModifSortColumn(
                                                                      columnIndex:
                                                                          index,
                                                                      value: [
                                                                    value
                                                                  ]));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              );
                                  }),
                                ));
                              },
                            );
                          },
                          child: FlyoutTarget(
                              key: contextAttachKey,
                              controller: contextController,
                              child: Text(
                                BlocProvider.of<TableBloc>(context)
                                    .state
                                    .columns![index],
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ))),
                      onSort: (columnIndex, sortAscending) {
                        BlocProvider.of<TableBloc>(context).add(SortColumn(
                            columnIndex: columnIndex,
                            sortAscending: sortAscending));
                      },
                    );
                  },
                ),
                rows: List.generate(
                    (BlocProvider.of<TableBloc>(context)
                                .state
                                .sortedRows!
                                .isEmpty ||
                            BlocProvider.of<TableBloc>(context).state.editMode!)
                        ? BlocProvider.of<TableBloc>(context).state.rows!.length
                        : BlocProvider.of<TableBloc>(context)
                            .state
                            .sortedRows!
                            .length, (index) {
                  return mat.DataRow(
                    cells: List.generate(
                      BlocProvider.of<TableBloc>(context).state.columns!.length,
                      (indexRow) {
                        return mat.DataCell(GestureDetector(
                            // onTap: () {
                            //   editTableDialog(
                            //       context1: context,
                            //       columns: BlocProvider.of<TableBloc>(context)
                            //           .state
                            //           .columns!,
                            //       id: index,
                            //       columnsType:
                            //           BlocProvider.of<TableBloc>(context)
                            //               .state
                            //               .columnsTypes!,
                            //       row: BlocProvider.of<TableBloc>(context)
                            //           .state
                            //           .rows![index]);
                            // },
                            child: BlocProvider.of<TableBloc>(context)
                                    .state
                                    .editMode!
                                ? (BlocProvider.of<TableBloc>(context).state.columnsTypes![indexRow] == int ||
                                        BlocProvider.of<TableBloc>(context)
                                                .state
                                                .columnsTypes![indexRow] ==
                                            double)
                                    ? (BlocProvider.of<TableBloc>(context).state.editMode! &&
                                            indexRow ==
                                                BlocProvider.of<TableBloc>(context)
                                                        .state
                                                        .columns!
                                                        .length -
                                                    1)
                                        ? Row(children: [
                                            SizedBox(
                                              width: 150,
                                              child: NumberBox<int>(
                                                mode: SpinButtonPlacementMode
                                                    .none,
                                                value: BlocProvider.of<
                                                            TableBloc>(context)
                                                        .state
                                                        .rows![index][
                                                    BlocProvider.of<TableBloc>(
                                                            context)
                                                        .state
                                                        .columns![indexRow]],
                                                onChanged: (value) {
                                                  BlocProvider.of<TableBloc>(
                                                          context)
                                                      .add(DataChange(
                                                          value: value,
                                                          indexRow: index,
                                                          column: BlocProvider
                                                                  .of<TableBloc>(
                                                                      context)
                                                              .state
                                                              .columns![indexRow]));
                                                },
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  FluentIcons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  BlocProvider.of<TableBloc>(
                                                          context)
                                                      .add(
                                                          DeleteRow(id: index));
                                                })
                                          ])
                                        : NumberBox<int>(
                                            mode: SpinButtonPlacementMode.none,
                                            value: BlocProvider.of<TableBloc>(
                                                        context)
                                                    .state
                                                    .rows![index][
                                                BlocProvider.of<TableBloc>(
                                                        context)
                                                    .state
                                                    .columns![indexRow]],
                                            onChanged: (value) {
                                              BlocProvider.of<TableBloc>(
                                                      context)
                                                  .add(DataChange(
                                                      value: value,
                                                      indexRow: index,
                                                      column: BlocProvider.of<
                                                                  TableBloc>(
                                                              context)
                                                          .state
                                                          .columns![indexRow]));
                                            },
                                          )
                                    : (BlocProvider.of<TableBloc>(context)
                                                .state
                                                .columnsTypes![indexRow] ==
                                            DateTime)
                                        ? (BlocProvider.of<TableBloc>(context)
                                                    .state
                                                    .editMode! &&
                                                indexRow ==
                                                    BlocProvider.of<TableBloc>(context)
                                                            .state
                                                            .columns!
                                                            .length -
                                                        1)
                                            ? Row(children: [
                                                DatePicker(
                                                  headerStyle: TextStyle(
                                                      color: Colors.black),
                                                  selected: BlocProvider.of<
                                                          TableBloc>(context)
                                                      .state
                                                      .rows![index][BlocProvider
                                                          .of<TableBloc>(
                                                              context)
                                                      .state
                                                      .columns![indexRow]],
                                                  onChanged: (value) {
                                                    BlocProvider.of<TableBloc>(
                                                            context)
                                                        .add(DataChange(
                                                            value: value,
                                                            indexRow: index,
                                                            column: BlocProvider
                                                                    .of<TableBloc>(
                                                                        context)
                                                                .state
                                                                .columns![indexRow]));
                                                  },
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      FluentIcons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  TableBloc>(
                                                              context)
                                                          .add(DeleteRow(
                                                              id: index));
                                                    })
                                              ])
                                            : DatePicker(
                                                headerStyle: TextStyle(
                                                    color: Colors.black),
                                                selected: BlocProvider.of<
                                                            TableBloc>(context)
                                                        .state
                                                        .rows![index][
                                                    BlocProvider.of<TableBloc>(
                                                            context)
                                                        .state
                                                        .columns![indexRow]],
                                                onChanged: (value) {
                                                  BlocProvider.of<TableBloc>(
                                                          context)
                                                      .add(DataChange(
                                                          value: value,
                                                          indexRow: index,
                                                          column: BlocProvider
                                                                  .of<TableBloc>(
                                                                      context)
                                                              .state
                                                              .columns![indexRow]));
                                                },
                                              )
                                        : (BlocProvider.of<TableBloc>(context)
                                                    .state
                                                    .editMode! &&
                                                indexRow == BlocProvider.of<TableBloc>(context).state.columns!.length - 1)
                                            ? Row(children: [
                                                SizedBox(
                                                  width: 150,
                                                  child: mat.TextFormField(
                                                    initialValue: rowText(
                                                        context,
                                                        index,
                                                        indexRow),
                                                    onChanged: (value) {
                                                      BlocProvider.of<
                                                                  TableBloc>(
                                                              context)
                                                          .add(DataChange(
                                                              value: value,
                                                              indexRow: index,
                                                              column: BlocProvider
                                                                      .of<TableBloc>(
                                                                          context)
                                                                  .state
                                                                  .columns![indexRow]));
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      FluentIcons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  TableBloc>(
                                                              context)
                                                          .add(DeleteRow(
                                                              id: index));
                                                    })
                                              ])
                                            : mat.TextFormField(
                                                initialValue: rowText(
                                                    context, index, indexRow),
                                                onChanged: (value) {
                                                  BlocProvider.of<TableBloc>(
                                                          context)
                                                      .add(DataChange(
                                                          value: value,
                                                          indexRow: index,
                                                          column: BlocProvider
                                                                  .of<TableBloc>(
                                                                      context)
                                                              .state
                                                              .columns![indexRow]));
                                                },
                                              )
                                : Text(rowText(context, index, indexRow))
                            //     TextFormBox(
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //           width: 0,
                            //           color: Colors.grey.withOpacity(0)),
                            //       color: Colors.grey.withOpacity(0)),
                            //   initialValue: rowText(context, index, indexRow),
                            //   onChanged: (value) {
                            //     BlocProvider.of<TableBloc>(context).add(
                            //         DataChange(
                            //             value: value,
                            //             indexRow: index,
                            //             column:
                            //                 BlocProvider.of<TableBloc>(context)
                            //                     .state
                            //                     .columns![indexRow]));
                            //   },
                            // ),
                            ));
                      },
                    ),
                  );
                })),
          )
        ])));
  }

  String rowText(context, int index, int indexRow) {
    if (BlocProvider.of<TableBloc>(context).state.columnsTypes![indexRow] ==
        DateTime) {
      final data = (BlocProvider.of<TableBloc>(context)
                  .state
                  .sortedRows!
                  .isEmpty ||
              BlocProvider.of<TableBloc>(context).state.editMode!)
          ? BlocProvider.of<TableBloc>(context).state.rows![index]
              [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]
          : BlocProvider.of<TableBloc>(context).state.sortedRows![index]
              [BlocProvider.of<TableBloc>(context).state.columns![indexRow]];
      return data == null ? '' : DateFormat('yyyy-MM-dd').format(data);
    }

    return (BlocProvider.of<TableBloc>(context).state.sortedRows!.isEmpty ||
            BlocProvider.of<TableBloc>(context).state.editMode!)
        ? BlocProvider.of<TableBloc>(context)
            .state
            .rows![index]
                [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]
            .toString()
        : BlocProvider.of<TableBloc>(context)
            .state
            .sortedRows![index]
                [BlocProvider.of<TableBloc>(context).state.columns![indexRow]]
            .toString();
  }

  void editTableDialog(
      {required BuildContext context1,
      Map<String, dynamic>? row,
      required List<String> columns,
      int? id,
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
                        // BlocProvider.of<TableBloc>(context1)
                        //     .add(UpdateRow(row: result, id: id!));
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
                title: const Text('Добавление строки'),
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
                            ? NumberBox<int>(
                                mode: SpinButtonPlacementMode.inline,
                                largeChange: 20,
                                value: 0,
                                onChanged: (value) {
                                  if (value == null) {
                                    emptyText[index] = false;
                                  } else {
                                    emptyText[index] = true;

                                    result[columns[index]] = value;
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
                                        popupColor: const Color(0xff420aa3),
                                        style: TextStyle(color: Colors.black),
                                        focusColor: const Color(0xff420aa3),
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
