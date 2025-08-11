import 'package:chickfit/data/repositories/repositories.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/models/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final _authRepository = locator.get<AuthRepository>();
  final _userRepo = locator.get<UserRepository>();

  RegisterCubit()
      : super(RegisterState(
            status: RegisterStatus.initial,
            username: '',
            password: '',
            passwordObscure: true,
            name: ''));

  Future<void> postRegister() async {
    emit(state.copyWith(status: RegisterStatus.loading));
    var loginResponse = await _authRepository.register(
      name: state.name,
      email: state.username,
      password: state.password,
    );
    if (loginResponse.data != null) {
      await _authRepository.persistUserToken(
          accessToken: loginResponse.data!.accessToken!);
      await _authRepository
          .persistUserProfile(loginResponse.data!.userProfile!);
      emit(state.copyWith(
        status: RegisterStatus.success,
        userProfile: loginResponse.data!.userProfile,
      ));
    } else {
      if (loginResponse.getException != null) {
        emit(state.copyWith(
            status: RegisterStatus.unauthenticated,
            errorMessage: loginResponse.getException!.getErrorMessage()));
      }
    }
  }

  void setName(String? name) {
    emit(state.copyWith(name: name));
  }

  void setEmail(String? username) {
    emit(state.copyWith(username: username));
  }

  void setPassword(String? pass) => emit(state.copyWith(password: pass));

  void setPassword2(String? pass) => emit(state.copyWith(password2: pass));

  void toggleShowPassword() =>
      emit(state.copyWith(passwordObscure: !state.passwordObscure));
}

enum RegisterStatus { initial, loading, error, success, unauthenticated }

class RegisterState extends Equatable {
  final RegisterStatus status;

  final String? message;
  final String? errorMessage;
  final String name;
  final String username;
  final String password;
  final bool passwordObscure;
  final UserProfile? userProfile;

  String? get displayErrorText {
    return status == RegisterStatus.unauthenticated && errorMessage != null
        ? errorMessage
        : null;
  }

  RegisterState({
    required this.status,
    required this.passwordObscure,
    this.message,
    this.errorMessage,
    required this.username,
    required this.name,
    required this.password,
    this.userProfile,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    bool? passwordObscure,
    String? message,
    String? errorMessage,
    String? name,
    String? username,
    String? password,
    String? password2,
    UserProfile? userProfile,
  }) {
    return RegisterState(
      status: status ?? this.status,
      passwordObscure: passwordObscure ?? this.passwordObscure,
      message: message,
      errorMessage: errorMessage,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        username,
        name,
        password,
        userProfile,
        errorMessage,
        passwordObscure
      ];
}
