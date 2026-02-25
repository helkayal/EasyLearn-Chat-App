import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      // Check if email is verified
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut(); // Log them out immediately
        emit(LoginError("Please verify your email address before logging in."));
        return;
      }

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? "Authentication failed"));
    }
  }
}
