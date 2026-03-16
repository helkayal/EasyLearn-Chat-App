import '../../model/chat_model.dart';

abstract class ChatInfoState {}

class ChatInfoInitial extends ChatInfoState {}

class ChatInfoLoading extends ChatInfoState {}

class ChatInfoLoaded extends ChatInfoState {
  final ChatModel chat;
  ChatInfoLoaded(this.chat);
}

class ChatInfoError extends ChatInfoState {
  final String message;
  ChatInfoError(this.message);
}
