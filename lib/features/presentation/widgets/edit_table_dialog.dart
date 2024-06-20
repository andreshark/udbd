import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_state.dart';

import '../bloc/table/table_bloc.dart';

void editTableDialog(
    {required BuildContext context1,
    Map<String, dynamic>? row,
    int? id,
    required List<String> columns,
    required List<Type> columnsType}) async {
  // ignore: unused_local_variable
  final result = await showDialog<bool>(
      context: context1,
      builder: (context) {
        Map<String, dynamic> result = {};
        List<bool> emptyText = [];
        return BlocListener<TableBloc, TableState>(
          listener: (context1, state) {
            // do stuff here based on BlocA's state
          },
          child: ContentDialog(
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
              title: const Text('Редактирование строки'),
              content: Wrap(
                  children: List.generate(
                columns.length,
                (index) {
                  emptyText.add(false);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(columns[index]),
                      (columnsType[index] == int ||
                              columnsType[index] == double)
                          ? NumberFormBox(
                              initialValue:
                                  ((row == null) ? '' : row[columns[index]]),
                              smallChange:
                                  columnsType[index] is double ? 0.1 : 1,
                              onChanged: (value) {
                                result[columns[index]] = value;
                                if (value == null) {
                                  emptyText[index] = false;
                                } else {
                                  emptyText[index] = true;
                                }
                              },
                            )
                          : (columnsType[index] == DateTime)
                              ? DatePicker(
                                  selected: ((row == null)
                                      ? null
                                      : DateTime.tryParse(row[columns[index]])),
                                  onChanged: (value) {
                                    result[columns[index]] = value;

                                    emptyText[index] = true;
                                  },
                                )
                              : (columnsType[index] == bool)
                                  ? ComboBox<bool>(
                                      value: ((row == null)
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
              ))),
        );
      });
}
