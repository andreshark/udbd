import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';

import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/table/table_bloc.dart';
import '../bloc/table/table_event.dart';
import '../bloc/table/table_state.dart';

class EditTablePage extends StatefulWidget {
  const EditTablePage({
    super.key,
    this.row,
    required this.columns,
    this.id,
    required this.columnsType,
  });

  final List<String> columns;
  final Map<String, dynamic>? row;
  final int? id;
  final List<Type> columnsType;

  @override
  State<EditTablePage> createState() => _EditTablePageState();
}

class _EditTablePageState extends State<EditTablePage> {
  late List<TextEditingController> _controllers;
  Map<String, dynamic> result = {};
  late List<bool> emptyText;
  @override
  void initState() {
    super.initState();

    emptyText = widget.row != null
        ? List<bool>.filled(widget.columns.length, true)
        : List<bool>.filled(widget.columns.length, false);
    _controllers = List.generate(
      widget.columns.length,
      (index) => TextEditingController()
        ..text = result[widget.columns[index]] ??
            ((widget.columnsType[index] == DateTime)
                ? (widget.row == null)
                    ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                    : DateFormat('yyyy-MM-dd')
                        .format(widget.row![widget.columns[index]])
                : ''),
      // ..addListener(() {
      //   if (widget.columnsType[index] == DateTime) {
      //     result[widget.columns[index]] =
      //         DateTime.tryParse(_controllers[index].text);
      //   }
      //   emptyText[index] = true;
      // })
    );
  }

  @override
  void dispose() {
    for (var i in _controllers) {
      i.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tableBloc = BlocProvider.of<TableBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Редактирование строки'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: List.generate(
              widget.columns.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (widget.columnsType[index] == int ||
                            widget.columnsType[index] == double)
                        ? TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: widget.columns[index],
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            initialValue: ((widget.row == null)
                                    ? '0'
                                    : widget.row![widget.columns[index]])
                                .toString(),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                emptyText[index] = false;
                              } else {
                                emptyText[index] = true;
                                if (widget.columnsType[index] != double) {
                                  result[widget.columns[index]] =
                                      (double.tryParse(value))!.round();
                                } else {
                                  result[widget.columns[index]] =
                                      (double.tryParse(value));
                                }
                              }
                            },
                          )
                        : (widget.columnsType[index] == DateTime)
                            ? TextField(
                                controller: _controllers[index],
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: widget.columns[index],
                                ),
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate:
                                              result[widget.columns[index]] ??
                                                  ((widget.row == null)
                                                      ? DateTime.now()
                                                      : widget.row![widget
                                                          .columns[index]]),
                                          firstDate: DateTime(2016, 1),
                                          lastDate: DateTime(2024, 12))
                                      .then((selectedDate) {
                                    if (selectedDate != null) {
                                      setState(() {
                                        result[widget.columns[index]] =
                                            selectedDate;
                                        _controllers[index].text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                        emptyText[index] = true;
                                      });
                                    }
                                  });
                                },
                              )
                            : (widget.columnsType[index] == bool)
                                ? SegmentedButton(
                                    style: ButtonStyle(backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.green;
                                        }
                                        return null;
                                      },
                                    ), foregroundColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.white;
                                        }
                                        return null;
                                      },
                                    )),
                                    segments: const <ButtonSegment<bool>>[
                                      ButtonSegment<bool>(
                                        value: true,
                                        label: Text('true'),
                                      ),
                                      ButtonSegment<bool>(
                                        value: false,
                                        label: Text('false'),
                                      ),
                                    ],
                                    selected: result[widget.columns[index]] ??
                                        ((widget.row == null)
                                            ? false
                                            : widget
                                                .row![widget.columns[index]]),
                                    onSelectionChanged:
                                        (Set<bool> newSelection) {
                                      setState(() {
                                        // By default there is only a single segment that can be
                                        // selected at one time, so its value is always the first
                                        // item in the selected set.
                                        result[widget.columns[index]] =
                                            newSelection.first;

                                        emptyText[index] = true;
                                      });
                                    },
                                  )
                                : TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: widget.columns[index],
                                    ),
                                    initialValue: ((widget.row == null)
                                        ? ''
                                        : widget.row![widget.columns[index]]),
                                    onChanged: (value) {
                                      result[widget.columns[index]] = value;
                                      if (value.isEmpty) {
                                        emptyText[index] = false;
                                      } else {
                                        emptyText[index] = true;
                                      }
                                    },
                                  ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                );
              },
            )..add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                        return Colors.green;
                      }), foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                        return Colors.white;
                      })),
                      child: const Text('Save'),
                      onPressed: () {
                        if (emptyText.any((element) => element == false)) {
                          return;
                        }

                        if (widget.row == null) {
                          tableBloc.add(InsertRow(row: result));
                        } else {
                          tableBloc.add(UpdateRow(row: result, id: widget.id!));
                        }

                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FilledButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.red.shade200;
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.red.shade900;
                        }
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.red.shade100;
                        }
                        return Colors.red;
                      })),
                      child: const Text('Delete'),
                      onPressed: () {
                        if (widget.id != null) {
                          tableBloc.add(DeleteRow(id: widget.id!));
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ])))));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
