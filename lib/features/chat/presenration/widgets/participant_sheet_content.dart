import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../cubit/group_management_state.dart';
import 'participant_action_bar.dart';
import 'participant_user_list.dart';

class ParticipantSheetContent extends StatelessWidget {
  final GroupManagementState state;
  final bool isGroup;
  final bool isAdding;
  final TextEditingController groupNameController;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClose;
  final Function(Set<String>) onConfirm;

  const ParticipantSheetContent({
    super.key,
    required this.state,
    required this.isGroup,
    required this.isAdding,
    required this.groupNameController,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isGroup
                        ? LocaleKeys.chat_add_participants.tr()
                        : LocaleKeys.chat_create_group.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: onClose),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (!isGroup) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.chat_group_name_label.tr(),
                  hintText: LocaleKeys.chat_group_hint_example.tr(),
                  prefixIcon: const Icon(Icons.group),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 12),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: LocaleKeys.chat_search_by_name_or_email.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 320,
            child: ParticipantUserList(state: state, searchQuery: searchQuery),
          ),

          ParticipantActionBar(
            state: state,
            isGroup: isGroup,
            isAdding: isAdding,
            groupName: groupNameController.text.trim(),
            onConfirm: onConfirm,
          ),
        ],
      ),
    );
  }
}
