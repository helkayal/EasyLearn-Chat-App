import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_avatar.dart';
import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';
import 'group_avatar_widget.dart';

class ChatListTile extends StatelessWidget {
  final ChatModel chat;
  final UserModel? otherUser;
  final int unreadCount;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ChatListTile({
    super.key,
    required this.chat,
    this.otherUser,
    this.unreadCount = 0,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  String get _displayName {
    if (chat.isGroup) return chat.groupName ?? 'Group';
    return otherUser?.name ?? 'Unknown';
  }

  Widget _buildAvatar() {
    if (chat.isGroup) {
      if (chat.groupImage != null && chat.groupImage!.isNotEmpty) {
        return CustomAvatar(
          imageUrl: chat.groupImage!,
          name: chat.groupName ?? 'Group',
          radius: 30,
        );
      }
      return GroupAvatarWidget(participantIds: chat.participantIds, radius: 30);
    }

    return CustomAvatar(
      imageUrl: otherUser?.profilePic ?? '',
      name: otherUser?.name ?? '?',
      radius: 30,
    );
  }

  String get _subtitle {
    if (chat.lastMessage != null && chat.lastMessage!.isNotEmpty) {
      return chat.lastMessage!;
    }
    if (chat.isGroup) {
      return 'Group · ${chat.participantIds.length} members';
    }
    return otherUser?.status ?? '';
  }

  String get _timeText {
    final at = chat.lastMessageAt;
    if (at == null) return '';
    final now = DateTime.now();
    if (at.day == now.day && at.month == now.month && at.year == now.year) {
      return '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
    }
    if (at.year == now.year) return '${at.day}/${at.month}';
    return '${at.day}/${at.month}/${at.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _buildAvatar(),
      title: Row(
        children: [
          if (chat.isGroup) ...[
            Icon(Icons.group, size: 14, color: theme.colorScheme.onTertiary),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              _displayName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        _subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onFavoriteToggle != null) ...[
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onTertiary,
                size: 20,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (_timeText.isNotEmpty)
            Text(
              _timeText,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12),
            ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
