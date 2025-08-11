class GetConsultationsResponse {
  GetConsultationsResponse({
    required this.consultations,
  });

  final List<ConsultationItemResponse> consultations;

  factory GetConsultationsResponse.fromJson(Map<String, dynamic> json) {
    return GetConsultationsResponse(
      consultations: json["consultations"] == null
          ? []
          : List<ConsultationItemResponse>.from(json["consultations"]!
              .map((x) => ConsultationItemResponse.fromJson(x))),
    );
  }
}

class ConsultationItemResponse {
  ConsultationItemResponse({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.messageCount,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.chatWith,
  });

  final int? id;
  final String? status;
  final DateTime? createdAt;
  final int? messageCount;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final ConsultationChatWith? chatWith;

  factory ConsultationItemResponse.fromJson(Map<String, dynamic> json) {
    return ConsultationItemResponse(
      id: json["id"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      messageCount: json["message_count"],
      lastMessage: json["last_message"],
      lastMessageTime: DateTime.tryParse(json["last_message_time"] ?? ""),
      chatWith: json["chat_with"] == null
          ? null
          : ConsultationChatWith.fromJson(json["chat_with"]),
    );
  }
}

class ConsultationChatWith {
  ConsultationChatWith({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
    required this.specialization,
  });

  final int? id;
  final String? name;
  final String? avatarUrl;
  final String? role;
  final String? specialization;

  factory ConsultationChatWith.fromJson(Map<String, dynamic> json) {
    return ConsultationChatWith(
      id: json["id"],
      name: json["name"],
      avatarUrl: json["avatar_url"],
      role: json["role"],
      specialization: json["specialization"],
    );
  }
}
