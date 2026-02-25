import 'package:flutter/material.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({super.key});

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
                color: theme.dividerTheme.color?.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  hintText: "Search Chat",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.dividerTheme.color?.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.qr_code_scanner,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
