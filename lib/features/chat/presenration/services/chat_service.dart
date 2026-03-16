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
}
