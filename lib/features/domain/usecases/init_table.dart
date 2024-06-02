import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class InitTableUseCase implements UseCase<DataState, (String, String, String)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  InitTableUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, String, String)? params}) async {
    return await _dataRepositoryImpl.initTable(
        params!.$1, params.$2, params.$3);
  }
}
