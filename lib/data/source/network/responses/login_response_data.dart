import 'package:chickfit/models/user_profile.dart';

class LoginResponseData {
  String? accessToken;
  UserProfile? userProfile;

  LoginResponseData({
    this.accessToken,
    this.userProfile,
  });

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    accessToken = json['token'];
    userProfile =
        json['user'] != null ? UserProfile.fromJson(json['user']) : null;
  }
}
