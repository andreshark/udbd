import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_event.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_event.dart';
import 'package:udbd/features/presentation/pages/order_info_page.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/widgets/bd_choose_dialog.dart';
import '../../../injection_container.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_state.dart';
import '../widgets/error_dialog.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/loader.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
                          .order_rows!
                          .length, (index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).push(MaterialPageRoute(builder: (context) {
                            return OrderInfoPage(
                              index: index,
                            );
                          }));
                        },
                        child: Card(
                          child: ListTile(
                              title: Text(
                                '''Заказ #${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['id'].toString()}''',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(BlocProvider.of<LocalDataBloc>(context)
                                        .state
                                        .order_rows![index]['customer_name']),
                                    Text(DateFormat('yyyy-MM-dd').format(
                                        BlocProvider.of<LocalDataBloc>(context)
                                            .state
                                            .order_rows![index]['date'])),
                                  ])),
                        ));
                  }),
                ))
              ],
            )));
  }
}
