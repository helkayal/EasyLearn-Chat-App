import 'package:flutter/material.dart';

import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';
import 'chat_list_tile.dart';

class ChatItemCard extends StatelessWidget {
  final ChatModel chat;
  final UserModel? otherUser;
  final int unreadCount;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ChatItemCard({
    super.key,
    required this.chat,
    this.otherUser,
    this.unreadCount = 0,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ChatListTile(
        chat: chat,
        otherUser: otherUser,
        unreadCount: unreadCount,
        isFavorite: isFavorite,
        onFavoriteToggle: onFavoriteToggle,
      ),
    );
  }
}
