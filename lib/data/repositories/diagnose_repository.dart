import 'dart:io';

import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/base_repository.dart';
import 'package:chickfit/data/source/network/responses/base.dart';
import 'package:chickfit/data/source/network/responses/diagnose_result_response.dart';
import 'package:chickfit/data/source/network/responses/get_diagnose_histories_response.dart';
import 'package:chickfit/models/base.dart';
import 'package:dio/dio.dart';

class DiagnoseRepository extends BaseRepository {
  DiagnoseRepository({
    required super.apiClient,
    required super.localDataSource,
  });

  Future<BaseDTOModel<DiagnoseResultResponse>> postDiagnoseImage(
    File file,
  ) async {
    DiagnoseResultResponse data;
    String? message;
    try {
      LogUtil.info("TESS filenya ${file}");
      BaseObjectResponse<DiagnoseResultResponse> response =
          await apiClient.postDiagnose(
        file,
      );
      LogUtil.info("TESS filenya ${file}");
      if (response.success && response.data != null) {
        data = response.data!;
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
    return (BaseDTOModel.success(data))..successMessage = message;
  }

  Future<BaseDTOModel<DiagnoseResultResponse>> getDiagnoseDetail(
    int id,
  ) async {
    DiagnoseResultResponse data;
    String? message;
    try {
      BaseObjectResponse<DiagnoseResultResponse> response =
          await apiClient.getDiagnoseResultDetail(
        id,
      );
      if (response.success && response.data != null) {
        data = response.data!;
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
    return (BaseDTOModel.success(data))..successMessage = message;
  }

  Future<BaseDTOModel<List<DiagnoseHistoryItem>>> getDiagnoseHistories(
      {required String userId}) async {
    List<DiagnoseHistoryItem>? data;
    String? message;
    try {
      BaseObjectResponse<GetDiagnoseHistoriesResponse> response =
          await apiClient.getDiagnoseHistories(userId: userId);
      if (response.success) {
        data = response.data?.diagnoses;
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
