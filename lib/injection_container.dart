import 'package:get_it/get_it.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:udbd/core/theme/theme.dart';
import 'package:udbd/features/data/app_data_service.dart';
import 'package:udbd/features/data/local_data_repository_impl.dart';
import 'package:udbd/features/domain/usecases/delete_row.dart';
import 'package:udbd/features/domain/usecases/init_table.dart';
import 'package:udbd/features/domain/usecases/insert_row.dart';
import 'package:udbd/features/domain/usecases/load_metrics.dart';
import 'package:udbd/features/domain/usecases/load_table.dart';
import 'package:udbd/features/domain/usecases/show_tables.dart';
import 'package:udbd/features/domain/usecases/update_row.dart';
import 'package:udbd/features/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:udbd/features/presentation/bloc/metric_data/metric_bloc.dart';
import 'package:udbd/features/presentation/bloc/table/table_bloc.dart';
import 'config/routes.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies(
    GlobalKey<NavigatorState> rootNavigatorKey) async {
  //routes
  sl.registerLazySingleton<GoRouter>(
      () => AppRoutes.onGenerateRoutes(rootNavigatorKey));

  //services
  sl.registerLazySingleton<AppDataService>(() => AppDataService());

  //repositories
  sl.registerLazySingleton<LocalDataRepositoryImpl>(
      () => LocalDataRepositoryImpl(sl()));

  //usecases
  sl.registerLazySingleton<ShowTableUseCase>(() => ShowTableUseCase(sl()));
  sl.registerLazySingleton<LoadTableUseCase>(() => LoadTableUseCase(sl()));
  sl.registerLazySingleton<DeleteRowUseCase>(() => DeleteRowUseCase(sl()));
  sl.registerLazySingleton<InsertRowUseCase>(() => InsertRowUseCase(sl()));
  sl.registerLazySingleton<UpdateRowUseCase>(() => UpdateRowUseCase(sl()));
  sl.registerLazySingleton<InitTableUseCase>(() => InitTableUseCase(sl()));
  sl.registerLazySingleton<LoadMetricsUseCase>(() => LoadMetricsUseCase(sl()));

  //blocs
  sl.registerLazySingleton<LocalDataBloc>(() => LocalDataBloc(sl(), sl()));
  sl.registerLazySingleton<AppTheme>(() => AppTheme());
  sl.registerLazySingleton<MetricBloc>(() => MetricBloc(sl()));
  sl.registerFactoryParam<TableBloc, String, List<String>>(
      (tableName, columns) =>
          TableBloc(sl(), sl(), sl(), sl(), tableName, columns));
}
