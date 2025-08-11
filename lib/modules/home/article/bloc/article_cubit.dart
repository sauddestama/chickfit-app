import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/data_repository.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:equatable/equatable.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final DataRepository _dataRepository;

  ArticleCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const ArticleState(
          articleDataStatus: DataStatus.initial,
        ));

  Future<void> fetchArticles() async {
    emit(state.copyWith(
      articleDataStatus: DataStatus.loading,
    ));

    final result = await _dataRepository.getPublishedArticle();

    if (result.data == null) {
      emit(state.copyWith(articleDataStatus: DataStatus.failure));
      return;
    }

    emit(state.copyWith(
      articleDataStatus: DataStatus.success,
      articles: result.data as List<ArticleItemResponse>,
    ));
  }
}

class ArticleState extends Equatable {
  final DataStatus articleDataStatus;
  final String? message;
  final String? errorMessage;
  final List<ArticleItemResponse>? articles;

  const ArticleState({
    this.message,
    this.errorMessage,
    required this.articleDataStatus,
    this.articles,
  });

  ArticleState copyWith({
    String? message,
    String? errorMessage,
    DataStatus? articleDataStatus,
    List<ArticleItemResponse>? articles,
  }) {
    return ArticleState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      articleDataStatus: articleDataStatus ?? this.articleDataStatus,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        articleDataStatus,
        articles,
      ];
}
