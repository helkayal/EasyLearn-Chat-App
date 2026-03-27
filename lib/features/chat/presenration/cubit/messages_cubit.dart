import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/supabase_service.dart';
import '../../model/message_model.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  final _firestore = FirebaseFirestore.instance;

  void watchMessages(String chatId, {required String currentUserId}) {
    emit(MessagesLoading());
    _sub?.cancel();
    _sub = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final messages = snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList();
          emit(MessagesLoaded(messages));
          _markOthersMessagesAsRead(
            chatId: chatId,
            currentUserId: currentUserId,
            messages: messages,
          );
        }, onError: (e) => emit(MessagesError(e.toString())));
  }

  /// Updates messages from other users (not sent by currentUserId) to isRead: true.
  Future<void> _markOthersMessagesAsRead({
    required String chatId,
    required String currentUserId,
    required List<MessageModel> messages,
  }) async {
    final toMark = messages
        .where((m) => m.senderId != currentUserId && !m.isRead)
        .toList();

    // Always clear unread count for current user on this chat, because
    // if they are watching it, it means they are actively viewing the screen.
    await _firestore.collection('chats').doc(chatId).update({
      'unreadByUser.$currentUserId': 0,
    });

    if (toMark.isEmpty) return;

    final col = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    final batch = _firestore.batch();
    for (final msg in toMark) {
      batch.update(col.doc(msg.id), {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderPic,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;
    try {
      final message = MessageModel(
        id: '',
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        senderPic: senderPic,
        text: text.trim(),
        type: MessageType.text,
      );
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatSnap = await chatRef.get();
      final data = chatSnap.data();
      final participantIds = List<String>.from(data?['participantIds'] ?? []);
      final unreadRaw = data?['unreadByUser'] as Map<String, dynamic>?;
      final unreadByUser = Map<String, int>.from(
        unreadRaw?.map(
              (k, v) =>
                  MapEntry(k, v is num ? v.toInt() : int.tryParse('$v') ?? 0),
            ) ??
            {},
      );
      for (final uid in participantIds) {
        if (uid != senderId) {
          unreadByUser[uid] = (unreadByUser[uid] ?? 0) + 1;
        } else {
          // Explicitly ensure the sender's unread count is 0
          unreadByUser[uid] = 0;
        }
      }
      await chatRef.update({
        'lastMessage': text.trim(),
        'lastMessageSenderId': senderId,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadByUser': unreadByUser,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMediaMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderPic,
    required MessageType type,
    required Uint8List bytes,
    required String extension,
  }) async {
    try {
      final url = await SupabaseService.uploadChatMessageMedia(
        bytes: bytes,
        chatId: chatId,
        extension: extension,
      );

      final message = MessageModel(
        id: '',
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        senderPic: senderPic,
        text: type == MessageType.image
            ? '📷 Image'
            : (type == MessageType.video ? '🎥 Video' : '🎵 Audio'),
        type: type,
        attachmentUrl: url,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatSnap = await chatRef.get();
      final data = chatSnap.data();
      final participantIds = List<String>.from(data?['participantIds'] ?? []);

      final unreadRaw = data?['unreadByUser'] as Map<String, dynamic>?;
      final unreadByUser = Map<String, int>.from(
        unreadRaw?.map(
              (k, v) =>
                  MapEntry(k, v is num ? v.toInt() : int.tryParse('$v') ?? 0),
            ) ??
            {},
      );

      for (final uid in participantIds) {
        if (uid != senderId) {
          unreadByUser[uid] = (unreadByUser[uid] ?? 0) + 1;
        } else {
          unreadByUser[uid] = 0;
        }
      }

      await chatRef.update({
        'lastMessage': message.text,
        'lastMessageSenderId': senderId,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadByUser': unreadByUser,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
