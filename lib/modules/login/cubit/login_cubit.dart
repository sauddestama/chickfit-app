import 'package:chickfit/data/repositories/repositories.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/models/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final _authRepository = locator.get<AuthRepository>();
  final _userRepo = locator.get<UserRepository>();

  LoginCubit()
      : super(LoginState(
          status: LoginStatus.initial,
          username: '',
          password: '',
          passwordObscure: true,
        ));

  Future<void> postLogin(String deviceUUID) async {
    emit(state.copyWith(status: LoginStatus.loading));
    var loginResponse = await _authRepository.authenticate(
      email: state.username,
      password: state.password,
    );
    if (loginResponse.data != null) {
      await _authRepository.persistUserToken(
          accessToken: loginResponse.data!.accessToken!);
      await _authRepository
          .persistUserProfile(loginResponse.data!.userProfile!);
      emit(state.copyWith(
        status: LoginStatus.authenticated,
        userProfile: loginResponse.data!.userProfile,
      ));
    } else {
      if (loginResponse.getException != null) {
        emit(state.copyWith(
            status: LoginStatus.unauthenticated,
            errorMessage: loginResponse.getException!.getErrorMessage()));
      }
    }
  }

  void setUsername(String? username) {
    emit(state.copyWith(username: username));
  }

  void setPassword(String? pass) => emit(state.copyWith(password: pass));

  void toggleShowPassword() =>
      emit(state.copyWith(passwordObscure: !state.passwordObscure));
}

enum LoginStatus { initial, loading, error, authenticated, unauthenticated }

class LoginState extends Equatable {
  final LoginStatus status;

  final String? message;
  final String? errorMessage;
  final String username;
  final String password;
  final bool passwordObscure;
  final UserProfile? userProfile;

  String? get displayErrorText {
    return status == LoginStatus.unauthenticated && errorMessage != null
        ? errorMessage
        : null;
  }

  LoginState({
    required this.status,
    required this.passwordObscure,
    this.message,
    this.errorMessage,
    required this.username,
    required this.password,
    this.userProfile,
  });

  LoginState copyWith({
    LoginStatus? status,
    bool? passwordObscure,
    String? message,
    String? errorMessage,
    String? username,
    String? password,
    UserProfile? userProfile,
  }) {
    return LoginState(
      status: status ?? this.status,
      passwordObscure: passwordObscure ?? this.passwordObscure,
      message: message,
      errorMessage: errorMessage,
      username: username ?? this.username,
      password: password ?? this.password,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        username,
        password,
        errorMessage,
        passwordObscure,
        userProfile,
      ];
}
