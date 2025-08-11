import 'package:hive_flutter/hive_flutter.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 1)
class UserProfile {
  @HiveField(1)
  final int? id;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? role;

  @HiveField(5)
  final String? specialization;

  @HiveField(6)
  final double? rating;

  @HiveField(7)
  final bool? isAvailable;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final String? avatarUrl;

  const UserProfile({
    this.id,
    this.name,
    this.email,
    this.role,
    this.specialization,
    this.rating,
    this.isAvailable,
    this.createdAt,
    this.avatarUrl,
  });

  /// Factory constructor for creating a [UserProfile] from JSON.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      avatarUrl: json['avatar_url'],
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      specialization: json['specialization'] as String?,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating'] as double?,
      isAvailable: json['is_available'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// Converts [UserProfile] back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'specialization': specialization,
      'rating': rating,
      'is_available': isAvailable == true ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Returns initials from the user's name.
  String get initials {
    if (name == null || name!.trim().isEmpty) return "-";
    final parts = name!.trim().split(RegExp(r"\s+"));
    return parts.length >= 2
        ? "${parts.first[0]}${parts.last[0]}"
        : parts.first[0];
  }

  /// Creates a copy of [UserProfile] with optional new values.
  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? specialization,
    double? rating,
    bool? isAvailable,
    DateTime? createdAt,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      specialization: specialization ?? this.specialization,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
