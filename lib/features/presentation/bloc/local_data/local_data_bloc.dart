import 'package:udbd/features/domain/usecases/init_table.dart';
import 'package:udbd/features/domain/usecases/orders.dart';
import 'package:udbd/features/domain/usecases/show_tables.dart';
import 'local_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/data_state.dart';
import 'local_data_event.dart';

class LocalDataBloc extends Bloc<LocalDataEvent, LocalDataState> {
  final ShowTableUseCase _showTableUseCase;
  final InitTableUseCase _initTableUseCase;
  final OrderUseCase _orderUseCase;
  final String dbName = 'Delivery DB';

  LocalDataBloc(
      this._showTableUseCase, this._initTableUseCase, this._orderUseCase)
      : super(const LocalDataLoading()) {
    on<ReadTables>(readTables);
    on<InitTable>(initTable);
  }

  Future<void> readTables(
      ReadTables event, Emitter<LocalDataState> emit) async {
    DataState dataState =
        await _initTableUseCase(params: ('delivery', 'postgres', '123'));
    if (dataState is DataSuccess) {
      dataState = await _showTableUseCase();
      DataState dataState1 = await _orderUseCase();
      if (dataState is DataSuccess) {
        emit(LocalDataDone(
            tables: dataState.data.$1,
            tablesColumns: dataState.data.$2,
            order_rows: dataState1.data.$1,
            product_rows: dataState1.data.$2));
      }

      if (dataState is DataFailedMessage) {
        emit(LocalDataError(dataState.errorMessage!));
      }
    }
  }

  Future<void> initTable(InitTable event, Emitter<LocalDataState> emit) async {
    final dataState =
        await _initTableUseCase(params: (event.bdName, event.user, event.pass));
    if (dataState is DataSuccess) {
      //dbName = event.bdName;
      emit(const LocalDataLoading());
    }

    if (dataState is DataFailedMessage) {
      emit(LocalDataDbError(dataState.errorMessage!));
    }
  }
}
