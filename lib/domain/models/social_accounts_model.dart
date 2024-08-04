class SocialAccountsModel {
  SocialAccountsModel({
    this.instaDetails,
    this.facebookDetails,
    this.twitterDetails,
  });

  InstaAccount? instaDetails;
  List<FacebookPageAccount>? facebookDetails;
  List<TwitterAccount>? twitterDetails;

  factory SocialAccountsModel.fromJson(Map<String, dynamic> json) =>
      SocialAccountsModel(
        instaDetails: json["insta_details"] != null
            ? InstaAccount.fromJson(json["insta_details"])
            : null,
        facebookDetails: json["facebook_details"] != null
            ? List<FacebookPageAccount>.from(json["facebook_details"]
                .map((x) => FacebookPageAccount.fromJson(x)))
            : null,
        twitterDetails: json["twitter_details"] != null
            ? List<TwitterAccount>.from(
                json["twitter_details"].map((x) => TwitterAccount.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "insta_details": instaDetails?.toJson(),
        "facebook_details":
            List<dynamic>.from(facebookDetails!.map((x) => x.toJson())),
        "twitterDetails":
            List<dynamic>.from(twitterDetails!.map((x) => x.toJson())),
      };
}

class FacebookPageAccount {
  FacebookPageAccount({
    this.accessToken,
    this.pageId,
    this.name,
    this.profilePictureUrl,
  });

  final String? accessToken;
  final int? pageId;
  final String? name;
  final String? profilePictureUrl;

  factory FacebookPageAccount.fromJson(Map<String, dynamic> json) =>
      FacebookPageAccount(
        accessToken: json["access_token"],
        pageId: json["pageid"],
        name: json["name"],
        profilePictureUrl: json["profile_picture_url"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "pageid": pageId,
        "name": name,
        "profile_picture_url": profilePictureUrl,
      };
}

class InstaAccount {
  InstaAccount({
    this.instagramId,
    this.fbAccessToken,
    this.username,
    this.profilePictureUrl,
    this.followsCount,
    this.followersCount,
  });

  final int? instagramId;
  final String? fbAccessToken;
  final String? username;
  final String? profilePictureUrl;
  final int? followsCount;
  final int? followersCount;

  factory InstaAccount.fromJson(Map<String, dynamic> json) => InstaAccount(
        instagramId: json["instagram_id"],
        fbAccessToken: json["fbAccessToken"],
        username: json["username"],
        profilePictureUrl: json["profile_picture_url"],
        followsCount: json["follows_count"],
        followersCount: json["followers_count"],
      );

  Map<String, dynamic> toJson() => {
        "instagram_id": instagramId,
        "fbAccessToken": fbAccessToken,
        "username": username,
        "profile_picture_url": profilePictureUrl,
        "follows_count": followsCount,
        "followers_count": followersCount,
      };
}

class TwitterAccount {
  TwitterAccount({
    this.userId,
    this.userName,
    this.secret,
    this.token,
    this.profilePictureUrl,
  });

  final int? userId;
  final String? userName;
  final String? secret;
  final String? token;
  final String? profilePictureUrl;

  factory TwitterAccount.fromJson(Map<String, dynamic> json) => TwitterAccount(
        userId: json["user_id"],
        userName: json["screen_name"],
        secret: json["oauth_token_secret"],
        token: json["oauth_token"],
        profilePictureUrl: json["profile_picture_url"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "screen_name": userName,
        "oauth_token_secret": secret,
        "oauth_token": token,
        "profile_picture_url": profilePictureUrl,
      };
}
