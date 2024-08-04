import 'dart:convert';

class ChatModel {
  final String? userName;
  final int? userId;
  final String? comment;
  final DateTime? createdAt;

  ChatModel(
    this.userName,
    this.userId,
    this.comment,
    this.createdAt,
  );

  ChatModel copyWith({
    String? userName,
    int? userId,
    String? comment,
    DateTime? createdAt,
  }) {
    return ChatModel(
      userName ?? this.userName,
      userId ?? this.userId,
      comment ?? this.comment,
      createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': userName,
      'userid': userId,
      'comment': comment,
      'commented_on': createdAt?.toIso8601String(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      map['username'],
      map['userid'],
      map['comment'],
      DateTime.parse(map['commented_on']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(username: $userName, user_id: $userId, comment: $comment, commented_on: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.userName == userName &&
        other.userId == userId &&
        other.comment == comment &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        userId.hashCode ^
        comment.hashCode ^
        createdAt.hashCode;
  }
}
