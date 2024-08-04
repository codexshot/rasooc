import 'dart:convert';

class NotificationsModel {
  final int? id;
  final int? campaignId;
  final int? submissionId;
  final String? body;
  final String? createdAt;
  final DateTime? readAt;
  final bool? hasRead;
  final String? notificationImageUrl;

  NotificationsModel({
    this.id,
    this.campaignId,
    this.submissionId,
    this.body,
    this.createdAt,
    this.readAt,
    this.hasRead,
    this.notificationImageUrl,
  });

  NotificationsModel copyWith({
    int? campaignId,
    int? submissionId,
    String? body,
    String? createdAt,
    DateTime? readAt,
    bool? hasRead,
    String? notificationImageUrl,
  }) {
    return NotificationsModel(
      campaignId: campaignId ?? this.campaignId,
      submissionId: submissionId ?? this.submissionId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      hasRead: hasRead ?? this.hasRead,
      notificationImageUrl: notificationImageUrl ?? this.notificationImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'campaign_id': campaignId,
      'submission_id': submissionId,
      'body': body,
      'created_at': createdAt,
      'readAt': readAt?.toIso8601String(),
      'hasRead': hasRead,
      'campaign_image': notificationImageUrl,
    };
  }

  factory NotificationsModel.fromMap(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id'],
      campaignId: map['campaign_id'],
      submissionId: map['submission_id'],
      body: map['message'],
      createdAt: map['created_at'],
      hasRead: map['hasRead'],
      notificationImageUrl: map['campaign_image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationsModel.fromJson(String source) =>
      NotificationsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationsModel(campaign_id: $campaignId, message: $body, createdAt: $createdAt, readAt: $readAt, hasRead: $hasRead, campaign_image: $notificationImageUrl)';
  }
}
