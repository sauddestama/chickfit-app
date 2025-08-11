import 'package:dio/dio.dart' hide Headers;

import 'error_response.dart';

class ServerError implements Exception {
  int? _errorCode;
  String? _errorMessage = "";

  ServerError.withUserError(this._errorMessage);

  ServerError.withError({required Object? error}) {
    if (error == null || error is! DioException) {
      _errorMessage = "Unknown Error";
    } else {
      _handleError(error);
    }
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) {
    if (error.response?.data != null && error.response?.data is Map) {
      final Response? res = error.response;
      _errorCode = error.response?.statusCode;
      print("errorny $res");
      try {
        if (ErrorResponse.fromJson(res?.data).message != null) {
          _errorMessage = ErrorResponse.fromJson(res?.data).message;
        }
      } catch (e) {
        if (_errorCode == 400) {
          _errorMessage = ErrorResponse.fromJson(res?.data).message;
        }
        if (_errorCode == 401) {
          _errorMessage =
              "Received invalid status code: ${error.response?.statusCode}";
        }
      }
    }

    if (_errorMessage == null) {
      switch (error.type) {
        case DioExceptionType.cancel:
          _errorMessage = "Request was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          _errorMessage = "Connection timeout";
          break;
        case DioExceptionType.unknown:
          _errorMessage = "Something went wrong";
          break;
        case DioExceptionType.receiveTimeout:
          _errorMessage = "Receive timeout in connection";
          break;
        case DioExceptionType.sendTimeout:
          _errorMessage = "Receive timeout in send request";
          break;

        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.connectionError:
          _errorMessage = "Something went wrong";
      }
    }

    return _errorMessage;
  }
}
