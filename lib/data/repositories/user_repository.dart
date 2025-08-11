import 'dart:io';

import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/base_repository.dart';
import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/data/source/network/responses/base.dart';
import 'package:chickfit/data/source/network/responses/post_update_profile_picture_response.dart';
import 'package:chickfit/data/source/network/services/api_service.dart';
import 'package:chickfit/models/base.dart';
import 'package:dio/dio.dart';

class UserRepository extends BaseRepository {
  UserRepository(
      {required ApiService apiClient, required LocalDataSource localDataSource})
      : super(apiClient: apiClient, localDataSource: localDataSource);

  Future<void> persistUsername({required String username}) =>
      localDataSource.persistUsername(username);

  Future<void> deleteUserdata() => localDataSource.deleteUserdata();

  Future<String?> getUserUsername() => localDataSource.getUsername();

  Future<BaseDTOModel<String>> postUpdateProfilePicture(
    File file,
  ) async {
    String data;
    String? message;
    try {
      BaseObjectResponse<PostUpdateProfilePictureResponse> response =
          await apiClient.postUpdateProfilePicture(
        file,
      );
      if (response.success && response.data != null) {
        data = response.data!.avatarUrl!;
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
}
