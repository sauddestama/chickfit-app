import 'server_error.dart';

class BaseDTOModel<T> {
  ServerError? _error;
  T? data;
  String? successMessage;

  factory BaseDTOModel.error(ServerError error) {
    return BaseDTOModel(
      error: error,
    );
  }
  factory BaseDTOModel.success(T data) {
    return BaseDTOModel(
      data: data,
    );
  }

  setException(ServerError error) {
    _error = error;
  }

  setData(T data) {
    this.data = data;
  }

  ServerError? get getException {
    return _error;
  }

  bool get isSuccess => _error == null;

  BaseDTOModel({
    this.data,
    this.successMessage,
    ServerError? error,
  }) : _error = error;
}
