import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/messages_cubit.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final String chatId;
  final String currentUserId;

  const ChatInput({
    super.key,
    required this.controller,
    required this.chatId,
    required this.currentUserId,
  });

  void _send(BuildContext context) {
    final text = controller.text;
    if (text.trim().isEmpty) return;
    controller.clear();
    final user = FirebaseAuth.instance.currentUser;
    context.read<MessagesCubit>().sendMessage(
      chatId: chatId,
      senderId: currentUserId,
      senderName: user?.displayName ?? user?.email ?? 'Unknown',
      senderPic: user?.photoURL ?? '',
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _send(context),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () => _send(context),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
