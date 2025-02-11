import 'package:udbd/features/domain/usecases/show_tables.dart';
import 'local_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'local_data_event.dart';

class LocalDataBloc extends Bloc<LocalDataEvent, LocalDataState> {
  final ShowTableUseCase _showTableUseCase;

  LocalDataBloc(this._showTableUseCase) : super(const LocalDataLoading()) {
    on<ReadTables>(readTables);
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
}
