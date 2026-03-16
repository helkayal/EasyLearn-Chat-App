import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/user_model.dart';
import '../cubit/new_chat_cubit.dart';
import '../screens/chat_screen.dart';
import 'contact_tile.dart';

class ContactList extends StatelessWidget {
  final List<UserModel> users;
  final String currentUserId;

  const ContactList({
    super.key,
    required this.users,
    required this.currentUserId,
  });

  Future<void> _startChat(BuildContext context, UserModel other) async {
    final cubit = context.read<NewChatCubit>();
    final navigator = Navigator.of(context);
    try {
      final chatId = await cubit.createOrGetIndividualChat(
        currentUserId: currentUserId,
        otherUserId: other.uid,
      );
      navigator.pop();
      navigator.push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chatId,
            title: other.name,
            imageUrl: other.profilePic.isNotEmpty ? other.profilePic : null,
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ContactTile(user: user, onTap: () => _startChat(context, user));
      },
    );
  }
}
