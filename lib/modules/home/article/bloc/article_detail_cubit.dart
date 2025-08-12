import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/data_repository.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:equatable/equatable.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final DataRepository _dataRepository;

  ArticleDetailCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const ArticleDetailState(
          articleDetailDataStatus: DataStatus.initial,
        ));

  Future<void> fetchArticleDetail(int articleId) async {
    emit(state.copyWith(
      articleDetailDataStatus: DataStatus.loading,
    ));

    final result = await _dataRepository.getDetailArticle(articleId);

    if (result.data == null) {
      emit(state.copyWith(
        articleDetailDataStatus: DataStatus.failure,
        errorMessage: result.getException?.getErrorMessage(),
      ));
      return;
    }

    emit(state.copyWith(
      articleDetailDataStatus: DataStatus.success,
      article: result.data as ArticleItemResponse,
      message: result.successMessage,
    ));
  }
}

class ArticleDetailState extends Equatable {
  final DataStatus articleDetailDataStatus;
  final String? message;
  final String? errorMessage;
  final ArticleItemResponse? article;

  const ArticleDetailState({
    this.message,
    this.errorMessage,
    required this.articleDetailDataStatus,
    this.article,
  });

  ArticleDetailState copyWith({
    String? message,
    String? errorMessage,
    DataStatus? articleDetailDataStatus,
    ArticleItemResponse? article,
  }) {
    return ArticleDetailState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      articleDetailDataStatus:
          articleDetailDataStatus ?? this.articleDetailDataStatus,
      article: article ?? this.article,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        articleDetailDataStatus,
        article,
      ];
}
