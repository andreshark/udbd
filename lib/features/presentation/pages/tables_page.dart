import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
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
  @override
  Widget build(BuildContext context) {
    context.watch<AppTheme>();
    FluentTheme.of(context);
    return BlocConsumer<LocalDataBloc, LocalDataState>(
        listener: (context, state) {
      if (state is LocalDataError) {
        showErrorDialog(context, state.errorMessage!, 'Data error');
      }
    }, builder: (context, state) {
      if (state is LocalDataLoading) {
        return const Loader();
      }

      return _buildbody(context);
    });
  }

  Widget _buildbody(BuildContext context) {
    return ScaffoldPage(
        content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'База данных форум',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
              BlocProvider.of<LocalDataBloc>(context).state.tables!.length,
              (indexTable) {
            return GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(FluentPageRoute(builder: (context) {
                    return BlocProvider<TableBloc>(
                        create: (context) => sl(
                            param1: BlocProvider.of<LocalDataBloc>(context)
                                .state
                                .tables![indexTable])
                          ..add(const LoadTable()),
                        child: const TableInfoPage());
                  }));
                },
                child: Card(
                    backgroundColor: indexTable % 2 == 0
                        ? FluentTheme.of(context).accentColor.withAlpha(204)
                        : FluentTheme.of(context).accentColor.withAlpha(104),
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            BlocProvider.of<LocalDataBloc>(context)
                                .state
                                .tablesColumns![indexTable]
                                .length,
                            (indexColumn) {
                              return Text(
                                  BlocProvider.of<LocalDataBloc>(context)
                                      .state
                                      .tablesColumns![indexTable][indexColumn]);
                            },
                          )..insert(
                              0,
                              Text(
                                BlocProvider.of<LocalDataBloc>(context)
                                    .state
                                    .tables![indexTable],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ))),
                    )));
          }),
        )
      ],
    ));
  }
}
