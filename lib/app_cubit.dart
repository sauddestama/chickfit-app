import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/models/user_profile.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';

import 'data/repositories/repositories.dart';

class AppCubit extends Cubit<AppState> {
  final AuthRepository authRepo = locator.get<AuthRepository>();
  final UserRepository userRepo = locator.get<UserRepository>();

  AppCubit()
      : super(const AppState(
          status: AuthenticationStatus.initial,
          uploadStatus: AuthenticationStatus.initial,
        ));

  Future<void> appStarted() async {
    final futures = [
      Future.delayed(const Duration(seconds: 1)),
      getUserProfile(),
      getDeviceId(),
    ];
    final results = await Future.wait(futures);
    final deviceUUID = results.last as String?;
    final userProfile = results[1] as UserProfile?;
    if (userProfile == null) {
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        data: userProfile,
      ));
    } else {
      emit(state.copyWith(
        status: AuthenticationStatus.aunthenticated,
        data: userProfile,
        deviceUUID: deviceUUID,
      ));
    }

    // await Future.delayed(const Duration(seconds: 1), () async {
    //   authRepo.hasToken().then((value) async {
    //     if (value) {
    //       UserProfile userProfile =
    //           await getUserProfile() ?? await authRepo.getLocalUserProfile();
    //       emit(state.copyWith(
    //         status: AuthenticationStatus.aunthenticated,
    //         data: userProfile,
    //       ));
    //     } else {
    //       emit(state.copyWith(
    //         status: AuthenticationStatus.unauthenticated,
    //       ));
    //     }
    //   });
    // });
  }

  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }

    return null;
  }

  void setUserProfile(UserProfile userProfile) {
    emit(state.copyWith(
      data: userProfile,
    ));
  }

  Future<bool> isUserLogedIn() async {
    final bool hasToken = await authRepo.hasToken();
    return hasToken;
  }

  Future<UserProfile?> getUserProfile() async {
    final result = await authRepo.getUserData();
    if (result.data != null) {
      await authRepo.persistUserProfile(result.data!);
      return result.data;
    }
    return null;
  }

  Future<bool> updateProfilePicture(File imageFile) async {
    try {
      emit(state.copyWith(
        uploadStatus: AuthenticationStatus.loading,
        errorMessage: null,
        message: null,
      ));

      final result = await userRepo.postUpdateProfilePicture(imageFile);

      if (result.isSuccess && result.data != null) {
        final updatedUser = state.data?.copyWith(avatarUrl: result.data);
        if (updatedUser != null) {
          await authRepo.persistUserProfile(updatedUser);
          emit(state.copyWith(
            uploadStatus: AuthenticationStatus.success,
            data: updatedUser,
            message: result.successMessage,
            errorMessage: null,
          ));

          // Clear success message after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (state.message != null) {
              emit(state.copyWith(message: null));
            }
          });
        }
        return true;
      } else {
        emit(state.copyWith(
          uploadStatus: AuthenticationStatus.success,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to update profile picture',
        ));

        // Clear error message after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (state.errorMessage != null) {
            emit(state.copyWith(errorMessage: null));
          }
        });

        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        uploadStatus: AuthenticationStatus.failed,
        errorMessage: 'An error occurred while updating profile picture',
      ));

      // Clear error message after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (state.errorMessage != null) {
          emit(state.copyWith(errorMessage: null));
        }
      });

      return false;
    }
  }

  void logout() {
    authRepo.logout();
  }
}

enum AuthenticationStatus {
  initial,
  loading,
  aunthenticated,
  unauthenticated,
  failed,
  success
}

class AppState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticationStatus uploadStatus;

  final String? message;

  final UserProfile? data;

  final String? errorMessage;
  final String? deviceUUID;

  const AppState({
    required this.status,
    required this.uploadStatus,
    this.message,
    this.data,
    this.errorMessage,
    this.deviceUUID,
  });

  AppState copyWith({
    AuthenticationStatus? status,
    AuthenticationStatus? uploadStatus,
    String? message,
    UserProfile? data,
    String? errorMessage,
    String? deviceUUID,
  }) {
    return AppState(
        status: status ?? this.status,
        uploadStatus: uploadStatus ?? this.uploadStatus,
        data: data ?? this.data,
        message: message ?? this.message,
        deviceUUID: deviceUUID ?? this.deviceUUID,
        errorMessage: errorMessage);
  }

  @override
  List<Object?> get props =>
      [data, status, uploadStatus, message, errorMessage, deviceUUID];
}
