import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/local_data/local_data_bloc.dart';
import '../bloc/local_data/local_data_state.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return _buildbody(context, index);
  }
}

Widget _buildbody(BuildContext context, int index) {
  final List<dynamic> products = BlocProvider.of<LocalDataBloc>(context)
      .state
      .product_rows!
      .where((product) =>
          product['id'] ==
          BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]
              ['id'])
      .toList();
  Map status = {
    'Доставлено': Colors.green,
    'В пути': Colors.orangeAccent,
    'Отменено': Colors.red
  };
  return Scaffold(
      appBar: AppBar(
        title: Text(
          '''Заказ #${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['id'].toString()}''',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 18),
                    children: <TextSpan>[
                  const TextSpan(
                    text: 'Статус доставки:',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text:
                        ' ${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['status']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status[BlocProvider.of<LocalDataBloc>(context)
                            .state
                            .order_rows![index]['status']]),
                  ),
                ])),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Адрес доставки',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
                '${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['customer_addres']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Получатель',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
                '${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['customer_name']}',
                style: const TextStyle(fontSize: 16)),
            Text(
                '${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['customer_phone']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Водитель',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
                '${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['driver_name']}',
                style: const TextStyle(fontSize: 16)),
            Text(
                '${BlocProvider.of<LocalDataBloc>(context).state.order_rows![index]['driver_veh']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Товары',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: List<TextSpan>.generate(
                        products.length,
                        (index1) => TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${index1 == 0 ? '' : '\n'}Идентификатор: ${products[index1]['product_id']}\n'),
                              TextSpan(
                                  text:
                                      'Наименование: ${products[index1]['name']}\n'),
                              TextSpan(
                                  text: 'Цена: ${products[index1]['price']}\n')
                            ])))),
          ])));
}
