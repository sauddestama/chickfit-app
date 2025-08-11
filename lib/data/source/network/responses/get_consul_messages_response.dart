class GetConsultationMessagesResponse {
  GetConsultationMessagesResponse({
    required this.messages,
  });

  final List<ConsulMessage> messages;

  factory GetConsultationMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GetConsultationMessagesResponse(
      messages: json["messages"] == null
          ? []
          : List<ConsulMessage>.from(
              json["messages"]!.map((x) => ConsulMessage.fromJson(x))),
    );
  }
}

class ConsulMessage {
  ConsulMessage({
    required this.id,
    required this.message,
    required this.senderId,
    required this.sentAt,
    required this.senderName,
    required this.senderAvatar,
    required this.senderRole,
  });

  final int? id;
  final String? message;
  final int? senderId;
  final DateTime? sentAt;
  final String? senderName;
  final dynamic senderAvatar;
  final String? senderRole;

  factory ConsulMessage.fromJson(Map<String, dynamic> json) {
    return ConsulMessage(
      id: json["id"],
      message: json["message"],
      senderId: json["sender_id"],
      sentAt: DateTime.tryParse(json["sent_at"] ?? ""),
      senderName: json["sender_name"],
      senderAvatar: json["sender_avatar"],
      senderRole: json["sender_role"],
    );
  }
}
