import 'package:udbd/features/data/local_data_repository_impl.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class ShowTableUseCase implements UseCase<DataState, void> {
  final LocalDataRepositoryImpl _dataRepositoryImpl;

  ShowTableUseCase(this._dataRepositoryImpl);

  @override
  Future<DataState> call({void params}) async {
    return await _dataRepositoryImpl.showTables();
  }
}
