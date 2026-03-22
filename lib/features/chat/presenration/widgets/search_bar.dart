import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../screens/new_chat_screen.dart';

class ChatSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onAddPressed;

  const ChatSearchBar({super.key, this.onChanged, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: LocaleKeys.chat_search_chat_hint.tr(),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap:
                onAddPressed ??
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewChatScreen()),
                ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withValues(alpha: .5),
              child: Icon(Icons.add, color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
