import 'package:flutter/material.dart';

import '../cubit/group_management_state.dart';

class ParticipantActionBar extends StatelessWidget {
  final GroupManagementState state;
  final bool isGroup;
  final bool isAdding;
  final String groupName;
  final Function(Set<String>) onConfirm;

  const ParticipantActionBar({
    super.key,
    required this.state,
    required this.isGroup,
    required this.isAdding,
    required this.groupName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final loadedState = state is GroupManagementLoaded
        ? state as GroupManagementLoaded
        : null;
    final selectedIds = loadedState?.selectedIds ?? <String>{};
    final canAdd =
        selectedIds.isNotEmpty && (isGroup || groupName.trim().isNotEmpty);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: (canAdd && !isAdding)
                ? () => onConfirm(selectedIds)
                : null,
            icon: isAdding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.person_add),
            label: Text(
              isGroup
                  ? 'Add ${selectedIds.isEmpty ? '' : '(${selectedIds.length})'}'
                  : 'Create group',
            ),
          ),
        ),
      ),
    );
  }
}
