import 'dart:convert';

import 'package:rasooc/domain/models/profile_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  factory SharedPreferenceHelper() {
    return _singleton;
  }
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  Future<bool?> setFBToken(String token) async {
    return (await SharedPreferences.getInstance())
        .setString(UserPreferenceKey.fBToken.toString(), token);
  }

  Future<String?> getFBToken() async {
    return (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.fBToken.toString());
  }

  Future<bool?> setAccessToken(String token) async {
    return (await SharedPreferences.getInstance())
        .setString(UserPreferenceKey.acessToken.toString(), token);
  }

  Future<String?> getAccessToken() async {
    return (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.acessToken.toString());
  }

  Future<bool?> setUserProfile(ProfileModel model) async {
    return (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.userProfile.toString(), json.encode(model.toJson()));
  }

  Future<ProfileModel?> getUserProfile() async {
    final jsonString = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.userProfile.toString());
    return ProfileModel.fromBackendJson(json.decode(jsonString!));
  }

  Future<bool?> setFBUserId(int userId) async {
    return (await SharedPreferences.getInstance())
        .setInt(UserPreferenceKey.fbUserId.toString(), userId);
  }

  Future<int?> getFBUserId() async {
    return (await SharedPreferences.getInstance())
        .getInt(UserPreferenceKey.fbUserId.toString());
  }

  Future<bool?> setCategories(List<CategoryModel> list) async {
    final List<Map<String, dynamic>> test = <Map<String, dynamic>>[];
    for (final element in list) {
      test.add(element.toJson());
    }

    final data = json.encode(test);
    return (await SharedPreferences.getInstance())
        .setString(UserPreferenceKey.categoryModelKey.toString(), data);
  }

  Future<List<CategoryModel>> getCategories() async {
    final jsonString = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.categoryModelKey.toString());

    final List<CategoryModel> list = <CategoryModel>[];
    if (jsonString != null) {
      json
          .decode(jsonString)
          .forEach((element) => list.add(CategoryModel.fromJson(element)));
    }

    return list;
  }

  Future<bool?> setNotificationLength(int len) async {
    return (await SharedPreferences.getInstance())
        .setInt(UserPreferenceKey.notifcationLength.toString(), len);
  }

  Future<int?> getNotificationLength() async {
    return (await SharedPreferences.getInstance())
        .getInt(UserPreferenceKey.notifcationLength.toString());
  }

  Future<bool?> setMessagesLength(int len) async {
    return (await SharedPreferences.getInstance())
        .setInt(UserPreferenceKey.messagesLength.toString(), len);
  }

  Future<int?> getMessagesLength() async {
    return (await SharedPreferences.getInstance())
        .getInt(UserPreferenceKey.messagesLength.toString());
  }

  Future<bool?> setOnboarded({required bool onboarded}) async {
    return (await SharedPreferences.getInstance())
        .setBool(UserPreferenceKey.onboarded.toString(), onboarded);
  }

  Future<bool?> getIfOnboarded() async {
    return (await SharedPreferences.getInstance())
        .getBool(UserPreferenceKey.onboarded.toString());
  }

  Future<bool?> clearAll() async {
    (await SharedPreferences.getInstance())
        .remove(UserPreferenceKey.acessToken.toString());
    (await SharedPreferences.getInstance())
        .remove(UserPreferenceKey.fBToken.toString());
    (await SharedPreferences.getInstance())
        .remove(UserPreferenceKey.fbUserId.toString());
    (await SharedPreferences.getInstance())
        .remove(UserPreferenceKey.categoryModelKey.toString());
    return true;
  }
}

enum UserPreferenceKey {
  fBToken,
  acessToken,
  userProfile,
  fbUserId,
  categoryModelKey,
  notifcationLength,
  messagesLength,
  onboarded,
}
