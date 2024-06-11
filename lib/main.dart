import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_theme/system_theme.dart';
import 'package:udbd/core/app_bloc_observer.dart';
import 'package:udbd/core/theme/theme.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_event.dart';
import 'package:udbd/features/presentation/pages/navigation_page.dart';
import 'package:window_manager/window_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'injection_container.dart';

const String appTitle = 'Postgres db';
String failMes = '';
final rootNavigatorKey = GlobalKey<NavigatorState>();

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

// пофиксить closesession
void main() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeDependencies(rootNavigatorKey);
      // if it's not on the web, windows or android, load the accent color
      // if (!kIsWeb &&
      //     [
      //       TargetPlatform.windows,
      //       TargetPlatform.android,
      //     ].contains(defaultTargetPlatform)) {
      //   SystemTheme.accentColor.load();
      // }

      // if (isDesktop) {
      //   await WindowManager.instance.ensureInitialized();
      //   if (isDesktop) {
      //     await flutter_acrylic.Window.initialize();
      //   }
      //   if (defaultTargetPlatform == TargetPlatform.windows) {
      //     await flutter_acrylic.Window.hideWindowControls();
      //   }
      //   await initializeDependencies(rootNavigatorKey);

      //   windowManager.waitUntilReadyToShow().then((_) async {
      //     await windowManager.setTitleBarStyle(
      //       TitleBarStyle.hidden,
      //       windowButtonVisibility: false,
      //     );
      //     await windowManager.setMinimumSize(const Size(800, 600));
      //     await windowManager.setSize(const Size(1400, 800));
      //     await windowManager.show();
      //     await windowManager.setPreventClose(true);
      //     await windowManager.setSkipTaskbar(false);
      //   });
      // }

      return runApp(MultiBlocProvider(providers: [
        BlocProvider<LocalDataBloc>(
          create: (context) => sl(),
        ),
      ], child: const MyApp()));
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Computer_service',
      themeMode: ThemeMode.light,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                  systemNavigationBarColor: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
          )).colorScheme.surface))),
      debugShowCheckedModeBanner: false,
      home: NavigationPage(),
    );
  }
}
