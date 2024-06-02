import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_state.dart';

void chooseBdDialog(BuildContext _) async {
  String password = '';
  String user = '';
  String bd = '';
  bool bdEmpty = false;
  bool userEmpty = false;
  String error = '';
  // ignore: unused_local_variable
  final result = await showDialog<String>(
    context: _,
    builder: (context) => BlocConsumer<LocalDataBloc, LocalDataState>(
        listener: (context, state) {
          if (state is LocalDataDbError) {
            error = state.errorMessage!;
          }
          if (state is LocalDataDone) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return ContentDialog(
                title: const Text('Войдите в базу данных'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    error.isNotEmpty
                        ? Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox.shrink(),
                    const Text('Название'),
                    TextFormBox(
                      onChanged: (value) {
                        bd = value;
                        bdEmpty = false;
                        setState(() {});
                      },
                      suffix: bdEmpty
                          ? Text('Введите название базы данных!',
                              style: TextStyle(color: Colors.red))
                          : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Пользователь'),
                    TextFormBox(
                      onChanged: (value) {
                        user = value;
                        userEmpty = false;
                        setState(() {});
                      },
                      suffix: userEmpty
                          ? Text('Введите имя пользователя!',
                              style: TextStyle(color: Colors.red))
                          : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Пароль'),
                    TextFormBox(
                      onChanged: (value) => password = value,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                actions: [
                  FilledButton(
                    child: const Text('Okey'),
                    onPressed: () {
                      if (bd.isEmpty) {
                        bdEmpty = true;
                        setState(() {});
                      }
                      if (user.isEmpty) {
                        userEmpty = true;
                        setState(() {});
                      } else {
                        BlocProvider.of<LocalDataBloc>(context).add(
                            InitTable(user: user, pass: password, bdName: bd));
                      }
                    },
                  ),
                ],
              );
            })),
  );
}
