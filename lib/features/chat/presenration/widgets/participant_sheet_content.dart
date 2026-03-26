import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
  final XFile? groupImageFile;
  final VoidCallback? onPickGroupImage;

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
    this.groupImageFile,
    this.onPickGroupImage,
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
          // ── Header row ─────────────────────────────────────────────────
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

          // ── New group fields ────────────────────────────────────────────
          if (!isGroup) ...[
            // Circular group image picker
            Center(
              child: GestureDetector(
                onTap: isAdding ? null : onPickGroupImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      backgroundImage: groupImageFile != null
                          ? FileImage(File(groupImageFile!.path))
                          : null,
                      child: groupImageFile == null
                          ? Icon(
                              Icons.group,
                              size: 40,
                              color: theme.colorScheme.onSurfaceVariant,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Group name field
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
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Search field ────────────────────────────────────────────────
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

          // ── User list ───────────────────────────────────────────────────
          SizedBox(
            height: 280,
            child: ParticipantUserList(state: state, searchQuery: searchQuery),
          ),

          // ── Action bar ──────────────────────────────────────────────────
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
