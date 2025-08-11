class PostConsulMessageRequest {
  String message;

  PostConsulMessageRequest({
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
