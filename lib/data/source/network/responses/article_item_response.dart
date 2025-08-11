class ArticleItemResponse {
  ArticleItemResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.authorName,
  });

  final int? id;
  final String? title;
  final String? content;
  final String? thumbnailUrl;
  final DateTime? createdAt;
  final String? authorName;

  factory ArticleItemResponse.fromJson(Map<String, dynamic> json) {
    return ArticleItemResponse(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      thumbnailUrl: json["thumbnail_url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      authorName: json["author_name"],
    );
  }
}
