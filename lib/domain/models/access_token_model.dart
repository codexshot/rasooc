import 'dart:convert';

AccessTokenModel accessToeknFromJson(String str) =>
    AccessTokenModel.fromJson(json.decode(str));

String accessToeknToJson(AccessTokenModel data) => json.encode(data.toJson());

class AccessTokenModel {
  AccessTokenModel({
    this.data,
  });

  Data? data;

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) =>
      AccessTokenModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.appId,
    this.type,
    this.application,
    this.dataAccessExpiresAt,
    this.expiresAt,
    this.isValid,
    this.scopes,
    this.userId,
  });

  String? appId;
  String? type;
  String? application;
  int? dataAccessExpiresAt;
  int? expiresAt;
  bool? isValid;
  List<String>? scopes;

  String? userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        appId: json["app_id"],
        type: json["type"],
        application: json["application"],
        dataAccessExpiresAt: json["data_access_expires_at"],
        expiresAt: json["expires_at"],
        isValid: json["is_valid"],
        scopes: List<String>.from(json["scopes"].map((x) => x)),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "app_id": appId,
        "type": type,
        "application": application,
        "data_access_expires_at": dataAccessExpiresAt,
        "expires_at": expiresAt,
        "is_valid": isValid,
        "scopes": List<dynamic>.from(scopes!.map((x) => x)),
        "user_id": userId,
      };
}
