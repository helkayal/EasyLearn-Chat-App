import 'package:flutter_bloc/flutter_bloc.dart';

enum ChatCategory {
  all,
  unread,
  favorites,
  groups,
}

class ChatCategoryCubit extends Cubit<ChatCategory> {
  ChatCategoryCubit() : super(ChatCategory.all);

  void setCategory(ChatCategory category) {
    if (state != category) {
      emit(category);
    }
  }
}

