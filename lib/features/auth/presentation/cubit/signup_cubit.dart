import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signUp(String name, String email, String password) async {
    emit(SignupLoading());

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = credential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          status: 'Online',
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());

        await user.sendEmailVerification();

        emit(SignupSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(SignupError(e.message ?? "Registration failed"));
    } catch (e) {
      emit(SignupError("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
