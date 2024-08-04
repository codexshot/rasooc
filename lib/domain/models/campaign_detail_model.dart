import 'dart:convert';

CampaignDetailModel campaignDetailModelFromJson(String str) =>
    CampaignDetailModel.fromJson(json.decode(str));

String campaignDetailModelToJson(CampaignDetailModel data) =>
    json.encode(data.toJson());

class CampaignDetailModel {
  CampaignDetailModel({
    this.id,
    this.brandLogo,
    this.coverImage,
    this.brandName,
    this.title,
    this.callToAction,
    this.aboutBrand,
    this.visualDirection,
    this.moodboardContent,
    this.instaSubmissions,
    this.instaTags,
    this.instaHandle,
    this.fbTag,
    this.fbHandle,
    this.fbUrl,
    this.twitterTag,
    this.twitterUrl,
    this.dos,
    this.donts,
    this.storeType,
    this.influencerRequirement,
    this.favourite,
    this.houseRules,
  });

  final int? id;
  final String? brandLogo;
  final String? coverImage;
  final String? brandName;
  final String? title;
  final String? callToAction;
  final String? aboutBrand;
  final List<String>? visualDirection;
  final String? moodboardContent;
  final List<String>? instaSubmissions;
  final List<String>? instaTags;
  final String? instaHandle;
  final List<String>? fbTag;
  final List<String>? fbHandle;
  final List<String>? fbUrl;
  final List<String>? twitterTag;
  final List<String>? twitterUrl;
  final List<String>? dos;
  final List<String>? donts;
  final String? storeType;
  final InfluencerRequirement? influencerRequirement;
  final bool? favourite;
  final List<String>? houseRules;

  factory CampaignDetailModel.fromJson(Map<String, dynamic> json) =>
      CampaignDetailModel(
        id: json["id"],
        brandLogo: json["brand_logo"],
        coverImage: json["cover_image"],
        brandName: json["brand_name"],
        title: json["title"],
        callToAction: json["call_to_action"],
        aboutBrand: json["about_brand"],
        visualDirection: json["visual_direction"] != null
            ? List<String>.from(json["visual_direction"].map((x) => x))
            : [],
        moodboardContent: json["moodboard_content"],
        instaSubmissions: json["insta_submissions"] != null
            ? List<String>.from(json["insta_submissions"].map((x) => x))
            : [],
        instaTags: json["insta_tags"] != null
            ? List<String>.from(json["insta_tags"].map((x) => x))
            : [],
        instaHandle: json["insta_handle"],
        fbTag: json["fb_tag"] != null
            ? List<String>.from(json["fb_tag"].map((x) => x))
            : [],
        fbHandle: json["fb_handle"] != null
            ? List<String>.from(json["fb_handle"].map((x) => x))
            : [],
        fbUrl: json["fb_url"] != null
            ? List<String>.from(json["fb_url"].map((x) => x))
            : [],
        twitterTag: json["twitter_tag"] != null
            ? List<String>.from(json["twitter_tag"].map((x) => x))
            : [],
        twitterUrl: json["twitter_url"] != null
            ? List<String>.from(json["twitter_url"].map((x) => x))
            : [],
        dos: json["dos"] != null
            ? List<String>.from(json["dos"].map((x) => x))
            : [],
        donts: json["donts"] != null
            ? List<String>.from(json["donts"].map((x) => x))
            : [],
        storeType: json["store_type"],
        influencerRequirement:
            InfluencerRequirement.fromJson(json["influencer_requirement"]),
        favourite: json["favourite"] == 1 || true && false,
        houseRules: json["house_rules"] != null
            ? List<String>.from(json["house_rules"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand_logo": brandLogo,
        "cover_image": coverImage,
        "brand_name": brandName,
        "title": title,
        "call_to_action": callToAction,
        "about_brand": aboutBrand,
        "visual_direction": List<dynamic>.from(visualDirection!.map((x) => x)),
        "moodboard_content": moodboardContent,
        "insta_submissions":
            List<dynamic>.from(instaSubmissions!.map((x) => x)),
        "insta_tags": List<dynamic>.from(instaTags!.map((x) => x)),
        "insta_handle": instaHandle,
        "fb_tag": List<dynamic>.from(fbTag!.map((x) => x)),
        "fb_handle": List<dynamic>.from(fbHandle!.map((x) => x)),
        "fb_url": List<dynamic>.from(fbUrl!.map((x) => x)),
        "twitter_tag": List<dynamic>.from(twitterTag!.map((x) => x)),
        "twitter_url": List<dynamic>.from(twitterUrl!.map((x) => x)),
        "dos": List<dynamic>.from(dos!.map((x) => x)),
        "donts": List<dynamic>.from(donts!.map((x) => x)),
        "store_type": storeType,
        "influencer_requirement": influencerRequirement!.toJson(),
        "favourite": favourite == true ? 1 : 0,
        "house_rules": List<dynamic>.from(houseRules!.map((x) => x)),
      };
}

class InfluencerRequirement {
  InfluencerRequirement({
    this.creatorsGender,
    this.creatorsAge,
    this.submissionType,
    this.creatorsFollowers,
  });

  List<String>? creatorsGender;
  List<String>? creatorsAge;
  List<String>? submissionType;
  String? creatorsFollowers;

  factory InfluencerRequirement.fromJson(Map<String, dynamic> json) =>
      InfluencerRequirement(
        creatorsGender: json["creators_gender"] != null
            ? List<String>.from(json["creators_gender"].map((x) => x))
            : [],
        creatorsAge: json["creators_age"] != null
            ? List<String>.from(json["creators_age"].map((x) => x))
            : [],
        submissionType: json["submission_type"] != null
            ? List<String>.from(json["submission_type"].map((x) => x))
            : [],
        creatorsFollowers: json["creators_followers"],
      );

  Map<String, dynamic> toJson() => {
        "creators_gender": List<dynamic>.from(creatorsGender!.map((x) => x)),
        "creators_age": creatorsAge,
        "submission_type": List<dynamic>.from(submissionType!.map((x) => x)),
        "creators_followers": creatorsFollowers,
      };
}
