import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class InsertRowUseCase
    implements UseCase<DataState, (String, Map<String, dynamic>)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  InsertRowUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, Map<String, dynamic>)? params}) async {
    return await _dataRepositoryImpl.insertRow(params!.$1, params.$2);
  }
}
