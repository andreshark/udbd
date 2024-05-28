abstract class DataState<T> {
  final T? data;
  final String? errorMessage;

  const DataState({this.data, this.errorMessage});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailedMessage<T> extends DataState<T> {
  const DataFailedMessage(String errorMessage)
      : super(errorMessage: errorMessage);
}
