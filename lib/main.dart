import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:udbd/core/app_bloc_observer.dart';
import 'package:udbd/core/theme/theme.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_event.dart';
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

      // if it's not on the web, windows or android, load the accent color
      if (!kIsWeb &&
          [
            TargetPlatform.windows,
            TargetPlatform.android,
          ].contains(defaultTargetPlatform)) {
        SystemTheme.accentColor.load();
      }

      if (isDesktop) {
        await WindowManager.instance.ensureInitialized();
        if (isDesktop) {
          await flutter_acrylic.Window.initialize();
        }
        if (defaultTargetPlatform == TargetPlatform.windows) {
          await flutter_acrylic.Window.hideWindowControls();
        }
        await initializeDependencies(rootNavigatorKey);

        windowManager.waitUntilReadyToShow().then((_) async {
          await windowManager.setTitleBarStyle(
            TitleBarStyle.hidden,
            windowButtonVisibility: false,
          );
          await windowManager.setMinimumSize(const Size(800, 600));
          await windowManager.setSize(const Size(1400, 800));
          await windowManager.show();
          await windowManager.setPreventClose(true);
          await windowManager.setSkipTaskbar(false);
        });
      }

      return runApp(MultiBlocProvider(providers: [
        BlocProvider<AppTheme>(create: (context) => sl()),
        BlocProvider<MetricBloc>(
            create: (context) => sl()..add(const LoadMetrics())),
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
    final appTheme = context.watch<AppTheme>();
    return FluentApp.router(
      title: 'Discord sender',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      color: const Color(0xffebaee9),
      darkTheme: FluentThemeData(
        accentColor: Colors.purple,
        dialogTheme: const ContentDialogThemeData(
            actionsDecoration: BoxDecoration(
              color: Color(0xff2e0773),
            ),
            decoration: BoxDecoration(
              color: Color(0xff1A0D29),
            )),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff1A0D29),
        buttonTheme: ButtonThemeData.all(ButtonStyle(
            textStyle: ButtonState.all(TextStyle(color: Colors.black)),
            shape: ButtonState.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor:
                ButtonState.resolveWith<Color?>((Set<ButtonStates> states) {
              if (states.contains(ButtonStates.hovering)) {
                return const Color(0xffebaee9);
              }
              if (states.contains(ButtonStates.disabled)) {
                return const Color(0xff2e0773);
              }
              if (states.contains(ButtonStates.pressing)) {
                return const Color(0xffAa014A);
              }
              return const Color(0xffFFDEFE);
            }))),
        navigationPaneTheme: const NavigationPaneThemeData(
            backgroundColor: Color(0xff2e0773),
            highlightColor: Color(0xffFFDEFE)),
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
        cardColor: const Color(0xff6F23F3),
      ),
      theme: FluentThemeData(
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      locale: appTheme.locale,
      routeInformationParser: sl<GoRouter>().routeInformationParser,
      routerDelegate: sl<GoRouter>().routerDelegate,
      routeInformationProvider: sl<GoRouter>().routeInformationProvider,
    );
  }
}
