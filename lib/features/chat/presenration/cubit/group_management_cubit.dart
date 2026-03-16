import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/user_model.dart';
import 'group_management_state.dart';

class GroupManagementCubit extends Cubit<GroupManagementState> {
  GroupManagementCubit() : super(GroupManagementInitial());

  final _firestore = FirebaseFirestore.instance;

  Future<void> loadNonParticipants(List<String> currentParticipantIds) async {
    emit(GroupManagementLoading());
    try {
      final snapshot = await _firestore.collection('users').get();
      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .where((u) => !currentParticipantIds.contains(u.uid))
          .toList();
      emit(GroupManagementLoaded(users));
    } catch (e) {
      emit(GroupManagementError(e.toString()));
    }
  }

  void toggleUser(String uid) {
    final current = state;
    if (current is GroupManagementLoaded) {
      final selected = Set<String>.from(current.selectedIds);
      if (selected.contains(uid)) {
        selected.remove(uid);
      } else {
        selected.add(uid);
      }
      emit(GroupManagementLoaded(current.users, selectedIds: selected));
    }
  }

  /// Creates a completely new group chat from scratch.
  Future<String> createGroup({
    required String currentUserId,
    required String groupName,
    required List<String> newUserIds,
  }) async {
    emit(GroupManagementAdding());
    try {
      final updatedIds = [currentUserId, ...newUserIds];
      final unreadMap = {for (final id in updatedIds) id: 0};

      final doc = await _firestore.collection('chats').add({
        'type': 'group',
        'groupName': groupName.trim().isNotEmpty ? groupName.trim() : 'Group',
        'participantIds': updatedIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': 'Group created',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUserId,
        'unreadByUser': unreadMap,
        'favoritedByUserIds': <String>[],
      });
      emit(GroupManagementSuccess(newChatId: doc.id));
      return doc.id;
    } catch (e) {
      emit(GroupManagementError(e.toString()));
      rethrow;
    }
  }

  /// Adds [newUserIds] to the chat. If [isCurrentlyIndividual] is true,
  /// also converts the chat to a group and sets [groupName].
  Future<void> addParticipants({
    required String chatId,
    required List<String> newUserIds,
    required bool isCurrentlyIndividual,
    String? groupName,
  }) async {
    emit(GroupManagementAdding());
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatSnap = await chatRef.get();
      final data = chatSnap.data();
      final currentIds = List<String>.from(data?['participantIds'] ?? []);
      final updatedIds = {...currentIds, ...newUserIds}.toList();

      final update = <String, dynamic>{'participantIds': updatedIds};

      if (isCurrentlyIndividual) {
        update['type'] = 'group';
        update['groupName'] = groupName?.trim().isNotEmpty == true
            ? groupName!.trim()
            : 'Group';
      }

      await chatRef.update(update);
      emit(GroupManagementSuccess());
    } catch (e) {
      emit(GroupManagementError(e.toString()));
    }
  }
}
