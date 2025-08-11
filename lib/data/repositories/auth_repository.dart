import 'package:chickfit/data/repositories/base_repository.dart';
import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/data/source/network/requests/change_password_request.dart';
import 'package:chickfit/data/source/network/requests/login_request.dart';
import 'package:chickfit/data/source/network/requests/register_request.dart';
import 'package:chickfit/data/source/network/responses/base.dart';
import 'package:chickfit/data/source/network/responses/login_response_data.dart';
import 'package:chickfit/data/source/network/services/api_service.dart';
import 'package:chickfit/models/base.dart';
import 'package:chickfit/models/user_profile.dart';
import 'package:dio/dio.dart';

class AuthRepository extends BaseRepository {
  AuthRepository(
      {required ApiService apiClient, required LocalDataSource localDataSource})
      : super(apiClient: apiClient, localDataSource: localDataSource);

  Future<BaseDTOModel<LoginResponseData>> authenticate({
    required String email,
    required String password,
  }) async {
    LoginResponseData data;
    try {
      BaseObjectResponse<LoginResponseData> response =
          await apiClient.login(LoginRequest(
        email: email,
        password: password,
      ));
      if (response.success && response.data != null) {
        data = response.data!;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      print("Exception terjadi: $error ");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      print("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return BaseDTOModel()..data = data;
  }

  Future<BaseDTOModel<bool>> changePassword({
    required String oldPass,
    required String password,
  }) async {
    bool data = false;
    try {
      BaseObjectResponse response =
          await apiClient.updatePassword(ChangePasswordRequest(
        newPass: password,
        currentPass: oldPass,
      ));
      if (response.success && response.data != null) {
        data = true!;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      print("Exception terjadi: $error ");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      print("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return BaseDTOModel()..data = data;
  }

  Future<BaseDTOModel<LoginResponseData>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    LoginResponseData data;
    try {
      BaseObjectResponse<LoginResponseData> response =
          await apiClient.register(RegisterRequest(
        name: name,
        email: email,
        password: password,
      ));
      if (response.success && response.data != null) {
        data = response.data!;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      print("Exception terjadi: $error ");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      print("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return BaseDTOModel()..data = data;
  }

  Future<BaseDTOModel<UserProfile>> getUserData() async {
    UserProfile data;
    try {
      BaseObjectResponse<LoginResponseData> response =
          await apiClient.getUserData();
      if (response.success && response.data != null) {
        data = response.data!.userProfile!;
      } else {
        return BaseDTOModel()
          ..setException(ServerError.withUserError(response.message));
      }
    } on DioException catch (error) {
      print("Exception terjadi: $error ");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    } catch (error, stacktrace) {
      print("Exception terjadi: $error stackTrace: $stacktrace");
      return BaseDTOModel()..setException(ServerError.withError(error: error));
    }
    return BaseDTOModel()..data = data;
  }

  Future<BaseDTOModel<bool>> logout() async {
    localDataSource.deleteUserdata();
    localDataSource.deleteToken();
    bool data;
    String? message;
    data = true;
    // try {
    //   BaseObjectResponse response = await apiClient.logout();
    //   if (response.success) {
    //     data = true;
    //     message = response.message;
    //   } else {
    //     return BaseDTOModel()
    //       ..setException(ServerError.withUserError(response.message));
    //   }
    // } on DioException catch (error) {
    //   return BaseDTOModel()..setException(ServerError.withError(error: error));
    // } catch (error, stacktrace) {
    //   print("Exception terjadi: $error stackTrace: $stacktrace");
    //   return BaseDTOModel()..setException(ServerError.withError(error: error));
    // }
    return (BaseDTOModel()..data = data)..successMessage = message;
  }

  // Future<void> deleteUserLogedInData() =>
  //     localDataSource.deleteUserLogedInData();
  //
  Future<UserProfile> getLocalUserProfile() => localDataSource.getUserProfile();

  Future<void> persistUserProfile(UserProfile user) =>
      localDataSource.persistUserData(user);

  //
  // Future<void> updateUserProfile(UserProfile user) =>
  //     localDataSource.updateUserProfile(user);

  Future<void> persistUserToken({required String accessToken}) =>
      localDataSource.persistUserToken(accessToken);

  Future<bool> hasToken() => localDataSource.hasToken();

  Future<String?> getUserToken() => localDataSource.getUserToken();
}
