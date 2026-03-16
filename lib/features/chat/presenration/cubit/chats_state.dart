import '../../../auth/model/user_model.dart';
import '../../model/chat_model.dart';

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<ChatModel> chats;
  /// Other participant info for 1:1 chats. Key = participant uid.
  final Map<String, UserModel> otherUsers;
  ChatsLoaded(this.chats, {Map<String, UserModel>? otherUsers})
      : otherUsers = otherUsers ?? {};
}

class ChatsEmpty extends ChatsState {}

class ChatsError extends ChatsState {
  final String message;
  ChatsError(this.message);
}

