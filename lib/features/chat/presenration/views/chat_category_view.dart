import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

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
              onTap: () =>
                  context.read<ChatCategoryCubit>().setCategory(itemCategory),
              child: Text(
                label,
                style: (isActive ? theme.textTheme.bodyLarge : baseStyle)
                    ?.copyWith(
                      color: isActive
                          ? theme.primaryColor
                          : theme.textTheme.bodyMedium?.color,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildItem(LocaleKeys.chat_category_all.tr(), ChatCategory.all),
              buildItem(
                LocaleKeys.chat_category_unread.tr(),
                ChatCategory.unread,
              ),
              buildItem(
                LocaleKeys.chat_category_favorites.tr(),
                ChatCategory.favorites,
              ),
              buildItem(
                LocaleKeys.chat_category_groups.tr(),
                ChatCategory.groups,
              ),
            ],
          );
        },
      ),
    );
  }
}
