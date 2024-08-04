import 'dart:convert';

import 'package:rasooc/domain/helper/enums.dart';

CampaignShortModel campaignShortModelFromJson(String str) =>
    CampaignShortModel.fromJson(json.decode(str));

String campaignShortModelToJson(CampaignShortModel data) =>
    json.encode(data.toJson());

class CampaignShortModel {
  CampaignShortModel({
    this.id,
    this.title,
    this.coverImage,
    this.aboutBrand,
    this.submissionType,
    this.favourite,
    appliedStatus,
  }){
    this._appliedStatus=appliedStatus;
  }

  final int? id;
  final String? title;
  final String? coverImage;
  final String? aboutBrand;
  final List<String>? submissionType;
  bool? favourite;
   CampaignStatus? _appliedStatus;

  CampaignStatus? get applied_status => _appliedStatus;

  set appliedStatus(CampaignStatus value) {
    _appliedStatus = value;
  }

  factory CampaignShortModel.fromJson(Map<String, dynamic> json) =>
      CampaignShortModel(
        id: json["id"],
        title: json["title"],
        coverImage: json["cover_image"],
        aboutBrand: json["about_brand"],
        submissionType: json["submission_type"] != null
            ? List<String>.from(json["submission_type"].map((x) => x))
            : [],
        favourite: json["favourite"] == 1 || true && false,

         appliedStatus: json["applied_status"]!=null?
            CampaignStatusTypeSearch.fromStatus(json["applied_status"]):CampaignStatus.apply,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cover_image": coverImage,
        "about_brand": aboutBrand,
        "submission_type": List<String>.from(submissionType!.map((x) => x)),
        "favourite": favourite == true ? 1 : 0,
        "applied_status": _appliedStatus?.asStatus(),
      };
}
