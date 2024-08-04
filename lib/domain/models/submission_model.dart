import 'package:rasooc/domain/helper/enums.dart';

class SubmissionModel {
  SubmissionModel({
    this.influencerId,
    this.caption,
    this.amount,
    this.campaignId,
    this.accountId,
    this.accountType,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.notes,
    this.submissionType,
  });

  final int? influencerId;
  final String? caption;
  final double? amount;
  final int? campaignId;
  final int? accountId;
  final CampaignSocialType? accountType;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;
  final String? notes;
  final CampaignSubmissionType? submissionType;

  factory SubmissionModel.fromJson(Map<String, dynamic> json) =>
      SubmissionModel(
        influencerId: json["influencer_id"],
        caption: json["caption"],
        amount: json["amount"],
        campaignId: json["campaign_id"],
        accountId: json["account_id"],
        accountType: CampaignSocialTypeSearch.fromString(
                json["account_type"].toLowerCase()) ??
            CampaignSocialType.instagram,
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "campaign_id": campaignId,
        "caption": caption,
        "account_type": accountType?.asString() ?? "instagram",
        "account_id": accountId,
        "notes": notes,
        "submission_type": submissionType?.asString() ?? "posts",
      };
}
