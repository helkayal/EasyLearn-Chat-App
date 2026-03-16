import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const Text('New chat'),
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
                hintText: 'Search by name or email',
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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is NewChatLoading || state is NewChatInitial) {
                  return const Center(child: CircularProgressIndicator());
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is NewChatLoaded) {
                  final users = state.filteredUsers;

                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        state.searchQuery.isEmpty
                            ? 'No other users yet.'
                            : 'No matches for "${state.searchQuery}"',
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
