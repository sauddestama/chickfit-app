import 'package:chickfit/data/source/network/responses/get_consul_messages_response.dart';

class PostConsultationMessagesResponse {
  PostConsultationMessagesResponse({
    required this.message,
  });

  final ConsulMessage? message;

  factory PostConsultationMessagesResponse.fromJson(Map<String, dynamic> json) {
    return PostConsultationMessagesResponse(
      message: json["message"] == null
          ? null
          : ConsulMessage.fromJson(json["message"]),
    );
  }
}
