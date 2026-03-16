import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_category_cubit.dart';
import '../cubit/chats_cubit.dart';
import '../screens/chat_screen.dart';
import '../screens/new_chat_screen.dart';
import '../widgets/add_participants_sheet.dart';
import '../widgets/search_bar.dart';
import 'chat_category_view.dart';
import 'chat_tab_view_body.dart';

class ChatsTabView extends StatefulWidget {
  const ChatsTabView({super.key});

  @override
  State<ChatsTabView> createState() => _ChatsTabViewState();
}

class _ChatsTabViewState extends State<ChatsTabView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ChatsCubit()..watchChats(currentUserId: currentUser?.uid ?? ''),
          ),
          BlocProvider(create: (context) => ChatCategoryCubit()),
        ],
        child: Column(
          children: [
            Builder(
              builder: (innerContext) {
                return ChatSearchBar(
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  onAddPressed: () async {
                    final category = innerContext
                        .read<ChatCategoryCubit>()
                        .state;
                    if (category == ChatCategory.groups) {
                      final newChatId = await AddParticipantsSheet.show(
                        innerContext,
                        chatId: null,
                        currentParticipantIds: [
                          FirebaseAuth.instance.currentUser?.uid ?? '',
                        ],
                        isGroup: false,
                      );
                      if (newChatId is String && innerContext.mounted) {
                        Navigator.push(
                          innerContext,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: newChatId,
                              title: 'New Group',
                            ),
                          ),
                        );
                      }
                    } else {
                      Navigator.push(
                        innerContext,
                        MaterialPageRoute(
                          builder: (context) => const NewChatScreen(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            const ChatCategoryView(),
            Expanded(
              child: ChatViewBody(
                currentUser: currentUser,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
