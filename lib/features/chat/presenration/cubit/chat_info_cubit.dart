import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/chat_model.dart';
import 'chat_info_state.dart';

class ChatInfoCubit extends Cubit<ChatInfoState> {
  ChatInfoCubit() : super(ChatInfoInitial());

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  final _firestore = FirebaseFirestore.instance;

  void watchChat(String chatId) {
    emit(ChatInfoLoading());
    _sub?.cancel();
    _sub = _firestore.collection('chats').doc(chatId).snapshots().listen((
      snap,
    ) {
      if (snap.exists && snap.data() != null) {
        emit(ChatInfoLoaded(ChatModel.fromMap(snap.data()!, snap.id)));
      }
    }, onError: (e) => emit(ChatInfoError(e.toString())));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
