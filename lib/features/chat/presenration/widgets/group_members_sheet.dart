import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../auth/model/user_model.dart';

class GroupMembersSheet extends StatefulWidget {
  final List<String> participantIds;

  const GroupMembersSheet({super.key, required this.participantIds});

  static Future<void> show(
    BuildContext context, {
    required List<String> participantIds,
  }) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => GroupMembersSheet(participantIds: participantIds),
    );
  }

  @override
  State<GroupMembersSheet> createState() => _GroupMembersSheetState();
}

class _GroupMembersSheetState extends State<GroupMembersSheet> {
  bool _isLoading = true;
  List<UserModel> _users = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final futures = widget.participantIds.map(
        (id) => FirebaseFirestore.instance.collection('users').doc(id).get(),
      );
      final docs = await Future.wait(futures);
      final users = docs
          .where((d) => d.exists && d.data() != null)
          .map((d) => UserModel.fromMap(d.data()!))
          .toList();

      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CustomLoadingIndicator()),
      );
    }
    if (_error != null) {
      return SizedBox(height: 200, child: Center(child: Text(_error!)));
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              LocaleKeys.chat_group_participants.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CustomAvatar(
                    imageUrl: user.profilePic,
                    name: user.name,
                    radius: 20,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
