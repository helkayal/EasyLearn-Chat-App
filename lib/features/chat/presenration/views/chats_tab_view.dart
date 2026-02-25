import 'package:flutter/material.dart';
import '../../../auth/model/user_model.dart';
import '../widgets/chat_item_card.dart';
import '../widgets/search_bar.dart';
import 'chat_category_view.dart';

class ChatsTabView extends StatelessWidget {
  const ChatsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const ChatSearchBar(),
          ChatCategoryView(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyUsers.length,
              itemBuilder: (context, index) {
                final user = dummyUsers[index];
                return ChatItemCard(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }
}
