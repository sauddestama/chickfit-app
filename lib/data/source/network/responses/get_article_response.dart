import 'package:chickfit/data/source/network/responses/article_item_response.dart';

class GetArticleResponse {
  GetArticleResponse({
    required this.articles,
  });

  final List<ArticleItemResponse> articles;

  factory GetArticleResponse.fromJson(Map<String, dynamic> json) {
    return GetArticleResponse(
      articles: json["articles"] == null
          ? []
          : List<ArticleItemResponse>.from(
              json["articles"]!.map((x) => ArticleItemResponse.fromJson(x))),
    );
  }
}
