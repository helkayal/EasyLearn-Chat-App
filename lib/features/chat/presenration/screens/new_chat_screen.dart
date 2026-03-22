import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../cubit/new_chat_cubit.dart';
import '../cubit/new_chat_state.dart';
import '../widgets/contact_list.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (context) => NewChatCubit()..loadUsers(currentUserId),
      child: _NewChatView(currentUserId: currentUserId),
    );
  }
}

class _NewChatView extends StatefulWidget {
  final String currentUserId;

  const _NewChatView({required this.currentUserId});

  @override
  State<_NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<_NewChatView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.home_new_chat.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: LocaleKeys.chat_search_by_name_or_email.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  context.read<NewChatCubit>().setSearchQuery(value),
            ),
          ),
          Expanded(
            child: BlocConsumer<NewChatCubit, NewChatState>(
              listener: (context, state) {
                if (state is NewChatError) {
                  SnackbarHelper.show(context, state.message, isError: true);
                }
              },
              builder: (context, state) {
                if (state is NewChatLoading || state is NewChatInitial) {
                  return const CustomLoadingIndicator();
                }

                if (state is NewChatError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(state.message, textAlign: TextAlign.center),
                    ),
                  );
                }

                if (state is NewChatCreating) {
                  return const CustomLoadingIndicator();
                }

                if (state is NewChatLoaded) {
                  final users = state.filteredUsers;

                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        state.searchQuery.isEmpty
                            ? LocaleKeys.chat_no_other_users_yet.tr()
                            : LocaleKeys.chat_no_matches_for.tr(
                                args: [state.searchQuery],
                              ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ContactList(
                    users: users,
                    currentUserId: widget.currentUserId,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
