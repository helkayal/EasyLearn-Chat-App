import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_category_cubit.dart';

class ChatCategoryView extends StatelessWidget {
  const ChatCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<ChatCategoryCubit, ChatCategory>(
        builder: (context, category) {
          TextStyle? baseStyle = theme.textTheme.bodyMedium;

          Widget buildItem(String label, ChatCategory itemCategory) {
            final bool isActive = category == itemCategory;

            return GestureDetector(
              onTap: () => context
                  .read<ChatCategoryCubit>()
                  .setCategory(itemCategory),
              child: Text(
                label,
                style: (isActive ? theme.textTheme.bodyLarge : baseStyle)
                    ?.copyWith(
                  color: isActive
                      ? theme.primaryColor
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildItem("All", ChatCategory.all),
              buildItem("Unread", ChatCategory.unread),
              buildItem("Favorites", ChatCategory.favorites),
              buildItem("Groups", ChatCategory.groups),
            ],
          );
        },
      ),
    );
  }
}

