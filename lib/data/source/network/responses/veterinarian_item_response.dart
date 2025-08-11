class VeterinarianItemResponse {
  VeterinarianItemResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.rating,
    required this.isAvailable,
    required this.createdAt,
    required this.avatarUrl,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? specialization;
  final double? rating;
  final int? isAvailable;
  final String? avatarUrl;
  final DateTime? createdAt;

  String get initials {
    if (name == null || name!.trim().isEmpty) return "-";
    final parts = name!.trim().split(RegExp(r"\s+"));
    return parts.length >= 2
        ? "${parts.first[0]}${parts.last[0]}"
        : parts.first[0];
  }

  factory VeterinarianItemResponse.fromJson(Map<String, dynamic> json) {
    final numRating = json["rating"] as num?;
    return VeterinarianItemResponse(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      specialization: json["specialization"],
      rating: numRating?.toDouble() ?? 0,
      isAvailable: json["is_available"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      avatarUrl: json['avatar_url'],
    );
  }
}
