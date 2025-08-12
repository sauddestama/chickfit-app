import 'package:chickfit/data/source/network/responses/article_item_response.dart';

class GetDetailArticleResponse {
  GetDetailArticleResponse({
    required this.article,
  });

  final ArticleItemResponse article;

  factory GetDetailArticleResponse.fromJson(Map<String, dynamic> json) {
    return GetDetailArticleResponse(
      article: ArticleItemResponse.fromJson(json['article']),
    );
  }
}
