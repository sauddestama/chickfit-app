import 'package:chickfit/models/user_profile.dart';
import 'package:hive_flutter/adapters.dart';

class LocalDataSource {
  static Future<void> init() async {
    // register adapter
    // register your hive adapter in this code
    Hive.registerAdapter(UserProfileAdapter());

    // Open box
    // register your hive box in this code

    // if (!Hive.isBoxOpen('auth_tokens')) await Hive.openBox<AuthToken>('auth_tokens');
    // if (!Hive.isBoxOpen('patients')) await Hive.openBox<Patient>('patient');
  }

  Future<void> persistUserData(UserProfile userProfile) async {
    try {
      Box box = await Hive.openBox(_userBox);
      await box.put(_userKey, userProfile);
    } catch (error) {
      throw HiveError(error.toString());
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      var box = await Hive.openBox(_userBox);
      dynamic result = await box.get(_userKey);
      return result;
    } catch (error) {
      throw HiveError(error.toString());
    }
  }

  Future<void> persistUserToken(String accessToken) async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    userKeyPairBox.put(accessTokenKey, accessToken);
  }

  Future<bool> hasToken() async {
    var boxKey = await Hive.openBox(keyValueBox);
    if (boxKey.containsKey(accessTokenKey)) {
      return true;
    }
    return false;
  }

  Future<String?> getUserToken() async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    if (userKeyPairBox.containsKey(accessTokenKey)) {
      return userKeyPairBox.get(accessTokenKey);
    }
    return null;
  }

  Future<String?> getBaseUrl() async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    if (userKeyPairBox.containsKey(baseUrlKey)) {
      return userKeyPairBox.get(baseUrlKey);
    }
    return null;
  }

  Future<void> persistBaseUrl(String baseUrl) async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    final url = baseUrl.endsWith("/")
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    userKeyPairBox.put(baseUrlKey, url);
  }

  Future<void> persistUsername(String username) async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    userKeyPairBox.put(usernameKey, username);
  }

  Future<String?> getUsername() async {
    final userKeyPairBox = await Hive.openBox(keyValueBox);
    if (userKeyPairBox.containsKey(usernameKey)) {
      return userKeyPairBox.get(usernameKey);
    }
    return null;
  }

  Future<void> deleteToken() async {
    var box = await Hive.openBox(keyValueBox);
    await box.delete(accessTokenKey);
  }

  Future<void> deleteUserdata() async {
    var box = await Hive.openBox(keyValueBox);
    await box.delete(accessTokenKey);
    await box.delete(usernameKey);
  }

  static const _userBox = "box_user";
  static const _userKey = "user_key";

  static const accessTokenKey = "key_access_token_unified_master";
  static const usernameKey = "key_username";
  static const baseUrlKey = "key_base_url";

  static const keyValueBox = "unified_master_KeyValueBox";
}
