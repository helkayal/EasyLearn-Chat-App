import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../model/chat_model.dart';
import '../cubit/messages_state.dart';
import 'message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  final MessagesLoaded state;
  final ChatModel? chat;
  final String currentUserId;
  final ScrollController scrollController;

  const ChatMessagesList({
    super.key,
    required this.state,
    required this.chat,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final messages = state.messages;

    if (messages.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.chat_no_messages_yet.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isGroup = chat?.isGroup ?? false;

        final prevMsg = index > 0 ? messages[index - 1] : null;
        final isFirstInRun =
            prevMsg == null || prevMsg.senderId != msg.senderId;

        final nextMsg = index < messages.length - 1
            ? messages[index + 1]
            : null;
        final isLastInRun = nextMsg == null || nextMsg.senderId != msg.senderId;

        return MessageBubble(
          message: msg,
          isMe: msg.senderId == currentUserId,
          isGroup: isGroup,
          showSenderName: isFirstInRun,
          showAvatar: isLastInRun,
        );
      },
    );
  }
}
