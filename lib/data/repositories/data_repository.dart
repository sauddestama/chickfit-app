import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/base_repository.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:chickfit/data/source/network/responses/base.dart';
import 'package:chickfit/data/source/network/responses/get_article_response.dart';
import 'package:chickfit/data/source/network/responses/veterinarian_item_response.dart';
import 'package:chickfit/data/source/network/responses/veterinarian_response.dart';
import 'package:chickfit/models/base.dart';
import 'package:dio/dio.dart';

class DataRepository extends BaseRepository {
  DataRepository({
    required super.apiClient,
    required super.localDataSource,
  });

  Future<BaseDTOModel<List<VeterinarianItemResponse>>>
      getVeterinarians() async {
    List<VeterinarianItemResponse>? data;
    String? message;
    try {
      BaseObjectResponse<GetVeterinarianResponse> response =
          await apiClient.getVeterinarian();
      if (response.success) {
        data = response.data?.veterinarians;
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  Future<BaseDTOModel<List<ArticleItemResponse>>> getPublishedArticle() async {
    List<ArticleItemResponse>? data;
    String? message;
    try {
      BaseObjectResponse<GetArticleResponse> response =
          await apiClient.getPublishedArticle();
      if (response.success) {
        data = response.data?.articles;
        message = response.message;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      LogUtil.error("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }
}
