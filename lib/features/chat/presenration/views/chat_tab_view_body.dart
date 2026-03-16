import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_category_cubit.dart';
import '../cubit/chats_cubit.dart';
import '../cubit/chats_state.dart';
import '../screens/new_chat_screen.dart';
import '../widgets/chats_list.dart';

void _openNewChat(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NewChatScreen()),
  );
}

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({
    super.key,
    required this.currentUser,
    required String searchQuery,
  }) : _searchQuery = searchQuery;

  final User? currentUser;
  final String _searchQuery;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        if (state is ChatsLoading || state is ChatsInitial) {
          return _buildLoading();
        }

        if (state is ChatsError) {
          return _buildError(state.message);
        }

        if (state is ChatsEmpty) {
          return _buildEmpty(context);
        }

        if (state is ChatsLoaded) {
          return _buildLoaded(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Something went wrong while loading chats.\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No chats yet.\nStart a new conversation!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openNewChat(context),
              icon: const Icon(Icons.add_comment),
              label: const Text('Start new chat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ChatsLoaded state) {
    final category = context.watch<ChatCategoryCubit>().state;

    var visibleChats = state.chats;
    final otherUsers = state.otherUsers;

    final currentUserId = currentUser?.uid ?? '';
    switch (category) {
      case ChatCategory.all:
        break;
      case ChatCategory.groups:
        visibleChats = visibleChats.where((chat) => chat.isGroup).toList();
        break;
      case ChatCategory.favorites:
        visibleChats = visibleChats
            .where((chat) => chat.favoritedByUserIds.contains(currentUserId))
            .toList();
        break;
      case ChatCategory.unread:
        visibleChats = visibleChats
            .where((chat) => chat.unreadCountFor(currentUserId) > 0)
            .toList();
        break;
    }

    if (visibleChats.isEmpty) {
      return const Center(
        child: Text(
          "No chats in this category yet.",
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      visibleChats = visibleChats.where((chat) {
        final otherUser = chat.isGroup
            ? null
            : otherUsers[chat.participantIds
                  .where((id) => id != currentUserId)
                  .firstOrNull];
        final title = chat.isGroup
            ? (chat.groupName ?? 'Group')
            : (otherUser?.name ?? 'Unknown');

        return title.toLowerCase().contains(q);
      }).toList();

      if (visibleChats.isEmpty) {
        return Center(
          child: Text(
            "No chats match '$_searchQuery'",
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    return ChatsList(
      visibleChats: visibleChats,
      currentUserId: currentUserId,
      otherUsers: otherUsers,
    );
  }
}
