class InstaAccountLinkResponseModel {
  InstaAccountLinkResponseModel({
    this.pageId,
    this.connectedInstagramAccount,
  });

  final String? pageId;
  final ConnectedInstagramAccount? connectedInstagramAccount;

  factory InstaAccountLinkResponseModel.fromJson(Map<String, dynamic> json) =>
      InstaAccountLinkResponseModel(
        pageId: json["id"],
        connectedInstagramAccount: json["connected_instagram_account"] == null
            ? null
            : ConnectedInstagramAccount.fromJson(
                json["connected_instagram_account"]),
      );

  Map<String, dynamic> toJson() => {
        "id": pageId,
        "connected_instagram_account":
            connectedInstagramAccount ?? connectedInstagramAccount?.toJson(),
      };
}

class ConnectedInstagramAccount {
  ConnectedInstagramAccount({
    this.id,
  });

  final String? id;

  factory ConnectedInstagramAccount.fromJson(Map<String, dynamic> json) =>
      ConnectedInstagramAccount(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
