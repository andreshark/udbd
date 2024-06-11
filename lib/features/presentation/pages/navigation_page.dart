import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:udbd/core/constants.dart';
import 'package:udbd/features/presentation/pages/info_page.dart';
import 'package:udbd/features/presentation/pages/orders_page.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/pages/tables_page.dart';

import '../../../../main.dart';
import '../bloc/local_data/local_data_bloc.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({
    super.key,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          BlocProvider.of<LocalDataBloc>(context).dbName,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt),
            icon: Icon(Icons.receipt_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.table_chart),
            icon: Badge(child: Icon(Icons.table_chart_outlined)),
            label: 'Tables',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outline),
            label: 'Info',
          ),
        ],
      ),
      body: <Widget>[
        OrdersPage(),
        TablesPage(),
        InfoPage(),
      ][currentPageIndex],
    );
  }
}
