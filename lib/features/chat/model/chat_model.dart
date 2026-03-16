import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType {
  individual,
  group,
}

class ChatModel {
  final String id;
  final ChatType type;
  final List<String> participantIds;
  final String? groupName;
  final String? groupImage;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;
  final String createdBy;
  /// User IDs who have marked this chat as favorite.
  final List<String> favoritedByUserIds;
  /// Per-user unread message count. Key = userId, value = count.
  final Map<String, int> unreadByUser;

  ChatModel({
    required this.id,
    required this.type,
    required this.participantIds,
    required this.createdBy,
    this.groupName,
    this.groupImage,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageAt,
    this.createdAt,
    this.favoritedByUserIds = const [],
    this.unreadByUser = const {},
  });

  bool get isGroup => type == ChatType.group;

  /// Unread count for a given user.
  int unreadCountFor(String userId) => unreadByUser[userId] ?? 0;

  factory ChatModel.fromMap(Map<String, dynamic> map, String documentId) {
    final unreadRaw = map['unreadByUser'] as Map<String, dynamic>?;
    final unreadByUser = unreadRaw?.map(
          (k, v) => MapEntry(
              k,
              v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0)),
        ) ??
        {};
    return ChatModel(
      id: documentId,
      type: _chatTypeFromString(map['type'] as String?),
      participantIds: List<String>.from(map['participantIds'] ?? []),
      groupName: map['groupName'] as String?,
      groupImage: map['groupImage'] as String?,
      lastMessage: map['lastMessage'] as String?,
      lastMessageSenderId: map['lastMessageSenderId'] as String?,
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      createdBy: map['createdBy'] as String? ?? '',
      favoritedByUserIds:
          List<String>.from(map['favoritedByUserIds'] ?? []),
      unreadByUser: unreadByUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': _chatTypeToString(type),
      'participantIds': participantIds,
      'groupName': groupName,
      'groupImage': groupImage,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageAt': lastMessageAt != null
          ? Timestamp.fromDate(lastMessageAt!)
          : FieldValue.serverTimestamp(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'favoritedByUserIds': favoritedByUserIds,
      'unreadByUser': unreadByUser,
    };
  }
}

ChatType _chatTypeFromString(String? value) {
  switch (value) {
    case 'group':
      return ChatType.group;
    case 'individual':
    default:
      return ChatType.individual;
  }
}

String _chatTypeToString(ChatType type) {
  switch (type) {
    case ChatType.group:
      return 'group';
    case ChatType.individual:
      return 'individual';
  }
}

