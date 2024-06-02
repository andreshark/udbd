import 'package:udbd/features/domain/usecases/init_table.dart';
import 'package:udbd/features/domain/usecases/show_tables.dart';
import 'local_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'local_data_event.dart';

class LocalDataBloc extends Bloc<LocalDataEvent, LocalDataState> {
  final ShowTableUseCase _showTableUseCase;
  final InitTableUseCase _initTableUseCase;
  late final String dbName;

  LocalDataBloc(this._showTableUseCase, this._initTableUseCase)
      : super(const LocalDataWainting()) {
    on<ReadTables>(readTables);
    on<InitTable>(initTable);
  }

  Future<void> readTables(
      ReadTables event, Emitter<LocalDataState> emit) async {
    final dataState = await _showTableUseCase();
    if (dataState is DataSuccess) {
      emit(LocalDataDone(
          tables: dataState.data.$1, tablesColumns: dataState.data.$2));
    }

    if (dataState is DataFailedMessage) {
      emit(LocalDataError(dataState.errorMessage!));
    }
  }

  Future<void> initTable(InitTable event, Emitter<LocalDataState> emit) async {
    final dataState =
        await _initTableUseCase(params: (event.bdName, event.user, event.pass));
    if (dataState is DataSuccess) {
      dbName = event.bdName;
      emit(LocalDataLoading());
    }

    if (dataState is DataFailedMessage) {
      emit(LocalDataDbError(dataState.errorMessage!));
    }
  }
}
