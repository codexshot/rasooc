import 'dart:convert';

class ContentCampaignsModel {
  final int? id;
  final String? influencerImage;
  final String? campaignTitle;
  final String? campaignImage;
  final String? caption;
  final DateTime? createdAt;
  final String? bcaSpend;
  ContentCampaignsModel({
    this.id,
    this.influencerImage,
    this.campaignTitle,
    this.campaignImage,
    this.caption,
    this.createdAt,
    this.bcaSpend,
  });

  ContentCampaignsModel copyWith({
    int? id,
    String? influencerImage,
    String? campaignTitle,
    String? campaignImage,
    String? caption,
  }) {
    return ContentCampaignsModel(
      id: id ?? this.id,
      influencerImage: influencerImage ?? this.influencerImage,
      campaignTitle: campaignTitle ?? this.campaignTitle,
      campaignImage: campaignImage ?? this.campaignImage,
      caption: caption ?? this.caption,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'influencer_image': influencerImage,
      'title': campaignTitle,
      'campaign_image': campaignImage,
      'caption': caption,
      'created_At': createdAt,
      'bca_spend': bcaSpend,
    };
  }

  factory ContentCampaignsModel.fromMap(Map<String, dynamic> map) {
    return ContentCampaignsModel(
      id: map['id'],
      influencerImage: map['influencer_image'],
      campaignTitle: map['title'],
      campaignImage: map['campaign_image'],
      caption: map['caption'],
      createdAt:
          map["created_at"] != null ? DateTime.parse(map["created_at"]) : null,
      bcaSpend: map['bca_spend'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContentCampaignsModel.fromJson(String source) =>
      ContentCampaignsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContentRightsModel(id: $id, influencerImage: $influencerImage, campaignTitle: $campaignTitle, campaignImage: $campaignImage, caption: $caption, created_at: $createdAt)';
  }
}
