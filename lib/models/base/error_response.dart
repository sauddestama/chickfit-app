class ErrorResponse {
  String? error;
  String? errorDescription;
  String? message;

  ErrorResponse({this.error, this.errorDescription, this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorDescription = json['error_description'];
    message = json['message'];
  }

}