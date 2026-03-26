import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/user_model.dart';
import '../../../../core/services/supabase_service.dart';
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
  /// If an image is provided it is uploaded to Supabase **before** the
  /// Firestore document is created, so the URL is stored atomically.
  /// If Firestore creation fails the uploaded image is deleted (rollback).
  Future<String> createGroup({
    required String currentUserId,
    required String groupName,
    required List<String> newUserIds,
    Uint8List? groupImageBytes,
  }) async {
    emit(GroupManagementAdding());

    // Step 1 — upload image bytes first to get the public URL
    String? groupImageUrl;
    final tempKey =
        'temp_${currentUserId}_${DateTime.now().millisecondsSinceEpoch}';

    if (groupImageBytes != null) {
      try {
        groupImageUrl = await SupabaseService.uploadGroupImageBytes(
          bytes: groupImageBytes,
          chatId: tempKey,
        );
      } catch (e) {
        emit(GroupManagementError('Image upload failed: $e'));
        return '';
      }
    }

    // Step 2 — create the Firestore document with URL already set
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
        'groupImage': groupImageUrl,
      });

      emit(GroupManagementSuccess(newChatId: doc.id));
      return doc.id;
    } catch (e) {
      // Step 3 — rollback: delete the uploaded image if Firestore failed
      if (groupImageUrl != null) {
        // ignore: avoid_print
        print('[GroupManagementCubit] Firestore failed — rolling back image…');
        await SupabaseService.deleteGroupImage(chatId: tempKey);
      }
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
    Uint8List? groupImageBytes,
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

        // Upload group image if provided when converting to group
        if (groupImageBytes != null) {
          try {
            final imageUrl = await SupabaseService.uploadGroupImageBytes(
              bytes: groupImageBytes,
              chatId: chatId,
            );
            update['groupImage'] = imageUrl;
          } catch (e) {
            rethrow;
          }
        }
      }

      await chatRef.update(update);
      emit(GroupManagementSuccess());
    } catch (e) {
      emit(GroupManagementError(e.toString()));
    }
  }
}
