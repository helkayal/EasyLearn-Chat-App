import '../../../auth/model/user_model.dart';

abstract class GroupManagementState {}

class GroupManagementInitial extends GroupManagementState {}

class GroupManagementLoading extends GroupManagementState {}

class GroupManagementLoaded extends GroupManagementState {
  final List<UserModel> users;
  final Set<String> selectedIds;

  GroupManagementLoaded(this.users, {Set<String>? selectedIds})
    : selectedIds = selectedIds ?? {};
}

class GroupManagementAdding extends GroupManagementState {}

class GroupManagementSuccess extends GroupManagementState {
  final String? newChatId;
  GroupManagementSuccess({this.newChatId});
}

class GroupManagementError extends GroupManagementState {
  final String message;
  GroupManagementError(this.message);
}
