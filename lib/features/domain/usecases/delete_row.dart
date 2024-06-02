import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class DeleteRowUseCase implements UseCase<DataState, (String, String, int)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  DeleteRowUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, String, int)? params}) async {
    return await _dataRepositoryImpl.deleteRow(
        params!.$1, params.$2, params.$3);
  }
}
