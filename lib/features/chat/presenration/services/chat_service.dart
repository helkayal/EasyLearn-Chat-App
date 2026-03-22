import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static Future<void> toggleFavorite({
    required String chatId,
    required String currentUserId,
  }) async {
    try {
      final ref = FirebaseFirestore.instance.collection('chats').doc(chatId);
      final doc = await ref.get();
      if (!doc.exists) return;

      final data = doc.data()!;
      final List<dynamic> favorited = data['favoritedByUserIds'] ?? [];

      if (favorited.contains(currentUserId)) {
        await ref.update({
          'favoritedByUserIds': FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        await ref.update({
          'favoritedByUserIds': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      // Allow it to fail silently
    }
  }

  static Future<void> deleteOrLeaveChat({
    required String chatId,
    required bool isGroup,
    required String currentUserId,
  }) async {
    final ref = FirebaseFirestore.instance.collection('chats').doc(chatId);

    if (isGroup) {
      // Leave group cleanly
      final snap = await ref.get();
      if (!snap.exists) return;

      final data = snap.data();
      if (data == null) return;

      final currentIds = List<String>.from(data['participantIds'] ?? []);
      currentIds.remove(currentUserId);

      final unreadByUser = Map<String, dynamic>.from(
        data['unreadByUser'] ?? {},
      );
      unreadByUser.remove(currentUserId);

      final favorited = List<String>.from(data['favoritedByUserIds'] ?? []);
      favorited.remove(currentUserId);

      await ref.update({
        'participantIds': currentIds,
        'unreadByUser': unreadByUser,
        'favoritedByUserIds': favorited,
      });
    } else {
      // Delete individual chat entirely
      await ref.delete();
    }
  }
}
