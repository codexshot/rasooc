import 'package:rasooc/domain/helper/enums.dart';

class PostSubmissionsModel {
  PostSubmissionsModel({
    this.id,
    this.title,
    this.createdAt,
    this.accountId,
    this.image,
    this.carousel,
    this.video,
    this.caption,
    this.submissionType,
    this.accountDetails,
    this.coverImage,
    this.accessToken,
    this.accountType,
  });

  final int? id;
  final String? title;
  final DateTime? createdAt;
  final String? accountId;
  final String? image;
  final List<String>? carousel;
  final String? video;
  final String? caption;
  final CampaignSubmissionType? submissionType;
  final AccountDetails? accountDetails;
  final String? coverImage;
  final String? accessToken;
  final CampaignSocialType? accountType;

  factory PostSubmissionsModel.fromJson(Map<String, dynamic> json) =>
      PostSubmissionsModel(
        id: json["id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        accountId: json["account_id"],
        image: json["image"],
        carousel: json["carousel"] != null
            ? List<String>.from(json["carousel"].map((x) => x))
            : json["carousel"],
        video: json["video"],
        caption: json["caption"],
        submissionType: json["submission_type"] != null
            ? CampaignSubmissionTypeSearch.fromString(json["submission_type"])
            : json["submission_type"],
        accountDetails: json["account_details"] != null
            ? AccountDetails.fromJson(json["account_details"])
            : null,
        coverImage: json["cover_image"],
        accountType: json["account_type"] != null
            ? CampaignSocialTypeSearch.fromString(json["account_type"])
            : json["account_type"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
        "account_id": accountId,
        "image": image,
        "carousel": List<dynamic>.from(carousel!.map((x) => x)),
        "video": video,
        "caption": caption,
        "submission_type": submissionType?.asString(),
        "account_details": accountDetails?.toJson(),
        "access_token": accessToken,
        "account_type": accountType?.asString(),
      };
}

class AccountDetails {
  AccountDetails({
    this.username,
    this.profilePictureUrl,
    this.followersCount,
  });

  final String? username;
  final String? profilePictureUrl;
  final int? followersCount;

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
        username: json["username"],
        profilePictureUrl: json["profile_picture_url"],
        followersCount: json["followers_count"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "profile_picture_url": profilePictureUrl,
        "followers_count": followersCount,
      };
}
