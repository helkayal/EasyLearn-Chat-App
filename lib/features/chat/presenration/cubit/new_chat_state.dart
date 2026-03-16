import '../../../auth/model/user_model.dart';

abstract class NewChatState {}

class NewChatInitial extends NewChatState {}

class NewChatLoading extends NewChatState {}

class NewChatLoaded extends NewChatState {
  final List<UserModel> users;
  final String searchQuery;
  NewChatLoaded(this.users, {this.searchQuery = ''});

  List<UserModel> get filteredUsers {
    if (searchQuery.trim().isEmpty) return users;
    final q = searchQuery.trim().toLowerCase();
    return users
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();
  }
}

class NewChatError extends NewChatState {
  final String message;
  NewChatError(this.message);
}

class NewChatCreating extends NewChatState {}
