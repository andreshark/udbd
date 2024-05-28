import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class UpdateRowUseCase
    implements UseCase<DataState, (String, Map<String, dynamic>, int)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  UpdateRowUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, Map<String, dynamic>, int)? params}) async {
    return await _dataRepositoryImpl.updateRow(
        params!.$1, params.$3, params.$2);
  }
}
