import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class UpdateRowUseCase implements UseCase<DataState, (String, List<dynamic>)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  UpdateRowUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, List<dynamic>)? params}) async {
    return await _dataRepositoryImpl.updateRow(params!.$1, params!.$2);
  }
}
