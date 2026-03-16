import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_info_cubit.dart';
import '../cubit/messages_cubit.dart';
import '../views/chat_view.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String title;
  final String? imageUrl;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MessagesCubit()
                ..watchMessages(chatId, currentUserId: currentUserId),
        ),
        BlocProvider(create: (_) => ChatInfoCubit()..watchChat(chatId)),
      ],
      child: ChatView(
        chatId: chatId,
        currentUserId: currentUserId,
        fallbackTitle: title,
        fallbackImageUrl: imageUrl,
      ),
    );
  }
}
