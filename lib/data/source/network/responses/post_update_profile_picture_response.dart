class PostUpdateProfilePictureResponse {
  PostUpdateProfilePictureResponse({
    required this.avatarUrl,
  });

  final String? avatarUrl;

  factory PostUpdateProfilePictureResponse.fromJson(Map<String, dynamic> json) {
    return PostUpdateProfilePictureResponse(
      avatarUrl: json["avatar_url"],
    );
  }
}
