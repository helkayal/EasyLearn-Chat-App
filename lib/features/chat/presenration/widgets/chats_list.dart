import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';
import '../cubit/chats_cubit.dart';
import '../screens/chat_screen.dart';
import 'chat_item_card.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({
    super.key,
    required this.visibleChats,
    required this.currentUserId,
    required this.otherUsers,
  });

  final List<ChatModel> visibleChats;
  final Map<String, UserModel> otherUsers;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: visibleChats.length,
      itemBuilder: (context, index) {
        final chat = visibleChats[index];
        final otherUser = chat.isGroup
            ? null
            : otherUsers[chat.participantIds
                  .where((id) => id != currentUserId)
                  .firstOrNull];
        final title = chat.isGroup
            ? (chat.groupName ?? LocaleKeys.chat_group.tr())
            : (otherUser?.name ?? LocaleKeys.chat_unknown.tr());
        final imageUrl = chat.isGroup ? chat.groupImage : otherUser?.profilePic;
        return Dismissible(
          key: Key(chat.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            try {
              await context.read<ChatsCubit>().deleteChat(
                chat: chat,
                currentUserId: currentUserId,
              );
              return true;
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete chat: $e')),
                );
              }
              return false;
            }
          },
          onDismissed: (_) {
            // Action completes upon confirmDismiss resolving true
          },
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatId: chat.id,
                    title: title,
                    imageUrl: imageUrl?.isNotEmpty == true ? imageUrl : null,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: ChatItemCard(
              chat: chat,
              otherUser: otherUser,
              unreadCount: chat.unreadCountFor(currentUserId),
              isFavorite: chat.favoritedByUserIds.contains(currentUserId),
              onFavoriteToggle: () {
                context.read<ChatsCubit>().toggleFavorite(
                  chatId: chat.id,
                  currentUserId: currentUserId,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
