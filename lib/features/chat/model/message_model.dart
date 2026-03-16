import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio, file, system }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderPic;
  final String? text;
  final String? attachmentUrl;
  final MessageType type;
  final DateTime? createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName = '',
    this.senderPic = '',
    required this.type,
    this.text,
    this.attachmentUrl,
    this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MessageModel(
      id: documentId,
      chatId: map['chatId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      senderPic: map['senderPic'] as String? ?? '',
      text: map['text'] as String?,
      attachmentUrl: map['attachmentUrl'] as String?,
      type: _messageTypeFromString(map['type'] as String?),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPic': senderPic,
      'text': text,
      'attachmentUrl': attachmentUrl,
      'type': _messageTypeToString(type),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'isRead': isRead,
    };
  }
}

MessageType _messageTypeFromString(String? value) {
  switch (value) {
    case 'image':
      return MessageType.image;
    case 'video':
      return MessageType.video;
    case 'audio':
      return MessageType.audio;
    case 'file':
      return MessageType.file;
    case 'system':
      return MessageType.system;
    case 'text':
    default:
      return MessageType.text;
  }
}

String _messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.image:
      return 'image';
    case MessageType.video:
      return 'video';
    case MessageType.audio:
      return 'audio';
    case MessageType.file:
      return 'file';
    case MessageType.system:
      return 'system';
    case MessageType.text:
      return 'text';
  }
}
