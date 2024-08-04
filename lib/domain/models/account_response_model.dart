import 'package:rasooc/domain/models/profile_model.dart';

class AccountResponseModel {
  AccountResponseModel({
    this.error,
    this.message,
    this.tokenType,
    this.accessToken,
    this.model,
  });

  String? error;
  String? message;
  String? tokenType;
  String? accessToken;
  ProfileModel? model;

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) =>
      AccountResponseModel(
        error: json["error"],
        message: json["message"],
        tokenType: json["token_type"],
        accessToken: json["access_token"],
        model: ProfileModel.fromBackendJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "token_type": tokenType,
        "access_token": accessToken,
        "data": model!.toBackendJson(),
      };
}
