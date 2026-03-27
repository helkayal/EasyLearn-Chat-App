import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../model/message_model.dart';
import 'video_message_player_widget.dart';
import 'audio_message_player_widget.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool isGroup;
  final bool showSenderName;
  final bool showAvatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isGroup = false,
    this.showSenderName = true,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter out unsupported message types
    if (![
      MessageType.text,
      MessageType.image,
      MessageType.video,
      MessageType.audio,
    ].contains(message.type)) {
      return const SizedBox.shrink();
    }

    final renderSenderName =
        isGroup && !isMe && message.senderName.isNotEmpty && showSenderName;

    final bubble = Container(
      margin: EdgeInsets.only(bottom: showAvatar ? 8.0 : 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.70,
      ),
      decoration: BoxDecoration(
        color: isMe
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (renderSenderName) ...[
            Text(
              message.senderName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.avatarColor(message.senderName),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
          ],
          if (message.type == MessageType.image &&
              message.attachmentUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: message.attachmentUrl!,
                placeholder: (context, url) => const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  height: 150,
                  child: Center(child: Icon(Icons.error)),
                ),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (message.type == MessageType.video &&
              message.attachmentUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: VideoMessagePlayerWidget(url: message.attachmentUrl!),
            ),
            const SizedBox(height: 4),
          ],
          if (message.type == MessageType.audio &&
              message.attachmentUrl != null) ...[
            AudioMessagePlayerWidget(
              audioUrl: message.attachmentUrl!,
              isMe: isMe,
            ),
            const SizedBox(height: 4),
          ],
          if (message.text != null && message.text!.isNotEmpty)
            Text(
              message.text!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isMe ? theme.colorScheme.onPrimary : null,
              ),
            ),
          if (message.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: isMe
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );

    if (isGroup && !isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showAvatar)
              CustomAvatar(
                imageUrl: message.senderPic,
                name: message.senderName,
                radius: 14,
              )
            else
              const SizedBox(width: 28),
            const SizedBox(width: 8),
            bubble,
          ],
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: showAvatar ? 0 : 6.0),
        child: bubble,
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
