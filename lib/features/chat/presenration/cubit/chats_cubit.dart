import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';
import '../services/chat_service.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  void watchChats({required String currentUserId}) {
    emit(ChatsLoading());

    _sub?.cancel();
    _sub = FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) async {
            final chats = snapshot.docs
                .map((doc) => ChatModel.fromMap(doc.data(), doc.id))
                .toList();

            if (chats.isEmpty) {
              emit(ChatsEmpty());
              return;
            }

            final otherUids = <String>{};
            for (final chat in chats) {
              if (!chat.isGroup && chat.participantIds.length == 2) {
                final other = chat.participantIds
                    .where((id) => id != currentUserId)
                    .firstOrNull;
                if (other != null) otherUids.add(other);
              }
            }

            final otherUsers = <String, UserModel>{};
            if (otherUids.isNotEmpty) {
              final list = otherUids.toList();
              const batchSize = 30;
              for (var i = 0; i < list.length; i += batchSize) {
                final batch = list.skip(i).take(batchSize).toList();
                final query = await FirebaseFirestore.instance
                    .collection('users')
                    .where(FieldPath.documentId, whereIn: batch)
                    .get();
                for (final doc in query.docs) {
                  otherUsers[doc.id] = UserModel.fromMap(doc.data());
                }
              }
            }

            emit(ChatsLoaded(chats, otherUsers: otherUsers));
          },
          onError: (error) {
            emit(ChatsError(error.toString()));
          },
        );
  }

  Future<void> toggleFavorite({
    required String chatId,
    required String currentUserId,
  }) async {
    await ChatService.toggleFavorite(
      chatId: chatId,
      currentUserId: currentUserId,
    );
  }

  Future<void> stopWatching() async {
    await _sub?.cancel();
    _sub = null;
  }

  @override
  Future<void> close() async {
    await stopWatching();
    return super.close();
  }
}
