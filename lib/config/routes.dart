import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:udbd/features/presentation/pages/metrics_page.dart';
import 'package:udbd/features/presentation/pages/table_info_page.dart';
import 'package:udbd/features/presentation/pages/tables_page.dart';

import '../features/presentation/pages/navigation_page.dart';
import '../features/presentation/pages/settings_page.dart';

class AppRoutes {
  static GoRouter onGenerateRoutes(rootNavigatorKey) {
    final shellNavigatorKey = GlobalKey<NavigatorState>();
    return GoRouter(navigatorKey: rootNavigatorKey, routes: [
      ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            return const TablesPage();
          },
          routes: [
            /// Home
            GoRoute(path: '/', builder: (context, state) => const TablesPage()),
            //GoRoute(path: '/logs', builder: (context, state) => LogsPage()),

            /// Settings
            GoRoute(
                path: '/metrics',
                builder: (context, state) => const MetricsPage())
          ]),
    ]);
  }
}
