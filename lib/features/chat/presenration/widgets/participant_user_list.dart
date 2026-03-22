import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../cubit/group_management_cubit.dart';
import '../cubit/group_management_state.dart';

class ParticipantUserList extends StatelessWidget {
  final GroupManagementState state;
  final String searchQuery;

  const ParticipantUserList({
    super.key,
    required this.state,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (state is GroupManagementLoading || state is GroupManagementInitial) {
      return const CustomLoadingIndicator();
    }
    if (state is GroupManagementError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            (state as GroupManagementError).message,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state is GroupManagementLoaded || state is GroupManagementAdding) {
      final loadedState = state is GroupManagementLoaded
          ? state as GroupManagementLoaded
          : null;
      final allUsers = loadedState?.users ?? [];
      final selectedIds = loadedState?.selectedIds ?? <String>{};

      final filtered = searchQuery.isEmpty
          ? allUsers
          : allUsers
                .where(
                  (u) =>
                      u.name.toLowerCase().contains(searchQuery) ||
                      u.email.toLowerCase().contains(searchQuery),
                )
                .toList();

      if (filtered.isEmpty) {
        return Center(
          child: Text(
            searchQuery.isEmpty
                ? LocaleKeys.chat_no_other_users_available.tr()
                : LocaleKeys.chat_no_matches_for.tr(args: [searchQuery]),
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final user = filtered[index];
          final isSelected = selectedIds.contains(user.uid);
          return CheckboxListTile(
            value: isSelected,
            onChanged: state is GroupManagementAdding
                ? null
                : (_) =>
                      context.read<GroupManagementCubit>().toggleUser(user.uid),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(user.email),
            secondary: CustomAvatar(
              imageUrl: user.profilePic,
              name: user.name,
              radius: 20,
            ),
            activeColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
