import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';
import 'new_chat_state.dart';

class NewChatCubit extends Cubit<NewChatState> {
  NewChatCubit() : super(NewChatInitial());

  final _firestore = FirebaseFirestore.instance;
  List<UserModel> _lastLoadedUsers = [];
  String _lastSearchQuery = '';

  Future<void> loadUsers(String currentUserId) async {
    emit(NewChatLoading());
    try {
      final snapshot = await _firestore.collection('users').get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .where((u) => u.uid != currentUserId)
          .toList();
      _lastLoadedUsers = users;
      emit(NewChatLoaded(users));
    } catch (e) {
      emit(NewChatError(e.toString()));
    }
  }

  void setSearchQuery(String query) {
    _lastSearchQuery = query;
    final current = state;
    if (current is NewChatLoaded) {
      emit(NewChatLoaded(current.users, searchQuery: query));
    }
  }

  void _restoreLoadedState() {
    emit(NewChatLoaded(_lastLoadedUsers, searchQuery: _lastSearchQuery));
  }

  /// Creates an individual chat or returns existing one. Returns the chat document id.
  Future<String> createOrGetIndividualChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    emit(NewChatCreating());
    try {
      final chatsSnapshot = await _firestore
          .collection('chats')
          .where('type', isEqualTo: 'individual')
          .where('participantIds', arrayContains: currentUserId)
          .get();

      for (final doc in chatsSnapshot.docs) {
        final ids = List<String>.from(doc.data()['participantIds'] ?? []);
        if (ids.length == 2 && ids.contains(otherUserId)) {
          _restoreLoadedState();
          return doc.id;
        }
      }

      final newChat = ChatModel(
        id: '',
        type: ChatType.individual,
        participantIds: [currentUserId, otherUserId],
        createdBy: currentUserId,
        lastMessageAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
      final ref = await _firestore.collection('chats').add(newChat.toMap());

      _restoreLoadedState();
      return ref.id;
    } catch (e) {
      _restoreLoadedState();
      rethrow;
    }
  }
}
