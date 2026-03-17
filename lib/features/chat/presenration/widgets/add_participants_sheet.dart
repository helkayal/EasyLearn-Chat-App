import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../cubit/group_management_cubit.dart';
import '../cubit/group_management_state.dart';
import 'participant_sheet_content.dart';

class AddParticipantsSheet extends StatefulWidget {
  final String? chatId;
  final List<String> currentParticipantIds;
  final bool isGroup;

  const AddParticipantsSheet({
    super.key,
    this.chatId,
    required this.currentParticipantIds,
    required this.isGroup,
  });

  static Future<dynamic> show(
    BuildContext context, {
    String? chatId,
    required List<String> currentParticipantIds,
    required bool isGroup,
  }) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddParticipantsSheet(
        chatId: chatId,
        currentParticipantIds: currentParticipantIds,
        isGroup: isGroup,
      ),
    );
    return result;
  }

  @override
  State<AddParticipantsSheet> createState() => _AddParticipantsSheetState();
}

class _AddParticipantsSheetState extends State<AddParticipantsSheet> {
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GroupManagementCubit()
            ..loadNonParticipants(widget.currentParticipantIds),
      child: BlocConsumer<GroupManagementCubit, GroupManagementState>(
        listener: (context, state) {
          if (state is GroupManagementSuccess) {
            Navigator.of(context).pop(state.newChatId ?? true);
          } else if (state is GroupManagementError) {
            SnackbarHelper.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, GroupManagementState state) {
    return ParticipantSheetContent(
      state: state,
      isGroup: widget.isGroup,
      isAdding: state is GroupManagementAdding,
      groupNameController: _groupNameController,
      searchController: _searchController,
      searchQuery: _searchQuery,
      onSearchChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
      onClose: () => Navigator.of(context).pop(false),
      onConfirm: (selectedIds) => _confirm(context, selectedIds),
    );
  }

  void _confirm(BuildContext context, Set<String> selectedIds) {
    if (widget.chatId == null) {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      context.read<GroupManagementCubit>().createGroup(
        currentUserId: currentUserId,
        groupName: _groupNameController.text.trim(),
        newUserIds: selectedIds.toList(),
      );
    } else {
      context.read<GroupManagementCubit>().addParticipants(
        chatId: widget.chatId!,
        newUserIds: selectedIds.toList(),
        isCurrentlyIndividual: !widget.isGroup,
        groupName: widget.isGroup ? null : _groupNameController.text.trim(),
      );
    }
  }
}
