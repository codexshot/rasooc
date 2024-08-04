import 'dart:convert';

class ContentRightsModel {
  final int? id;
  final String? influencerImage;
  final String? campaignTitle;
  final String? campaignImage;
  final String? caption;
  final DateTime? createdAt;
  ContentRightsModel({
    this.id,
    this.influencerImage,
    this.campaignTitle,
    this.campaignImage,
    this.caption,
    this.createdAt,
  });

  ContentRightsModel copyWith({
    int? id,
    String? influencerImage,
    String? campaignTitle,
    String? campaignImage,
    String? caption,
  }) {
    return ContentRightsModel(
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
    };
  }

  factory ContentRightsModel.fromMap(Map<String, dynamic> map) {
    return ContentRightsModel(
      id: map['id'],
      influencerImage: map['influencer_image'],
      campaignTitle: map['title'],
      campaignImage: map['campaign_image'],
      caption: map['caption'],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContentRightsModel.fromJson(String source) =>
      ContentRightsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContentRightsModel(id: $id, influencerImage: $influencerImage, campaignTitle: $campaignTitle, campaignImage: $campaignImage, caption: $caption, created_at: $createdAt)';
  }
}
