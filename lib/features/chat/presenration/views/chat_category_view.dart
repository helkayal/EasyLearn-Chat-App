import 'package:flutter/material.dart';

class ChatCategoryView extends StatelessWidget {
  const ChatCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Chats",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Friends", style: theme.textTheme.bodyMedium),
          Text("Calls", style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
