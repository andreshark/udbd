import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class LoadTableUseCase implements UseCase<DataState, (String, String)> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  LoadTableUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({(String, String)? params}) async {
    return await _dataRepositoryImpl.readTable(params!.$1, params.$2);
  }
}
