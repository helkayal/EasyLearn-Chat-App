// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart' as google;

// import 'login_states.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit() : super(LoginInitial());

//   Future<void> login(String email, String password) async {
//     emit(LoginLoading());
//     try {
//       // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//       //   email: email,
//       //   password: password,
//       // );
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // final user = credential.user;

//       // Check if email is verified
//       // if (user != null && !user.emailVerified) {
//       //   await FirebaseAuth.instance.signOut(); // Log them out immediately
//       //   emit(LoginError("Please verify your email address before logging in."));
//       //   return;
//       // }

//       emit(LoginSuccess());
//     } on FirebaseAuthException catch (e) {
//       emit(LoginError(e.message ?? "Authentication failed"));
//     }
//   }

//   Future<void> sendPasswordResetEmail(String email) async {
//     if (email.trim().isEmpty) return;

//     emit(PasswordResetLoading());
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
//       emit(PasswordResetSuccess());
//     } on FirebaseAuthException catch (e) {
//       emit(PasswordResetError(e.message ?? "Failed to send reset email"));
//     }
//   }

//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // 2. Use the prefix 'google' here
//       final google.GoogleSignIn googleSignIn = google.GoogleSignIn();

//       // 3. Trigger the flow
//       final google.GoogleSignInAccount? googleUser = await googleSignIn
//           .signIn();

//       if (googleUser == null) return;

//       // 4. Get auth details
//       final google.GoogleSignInAuthentication googleAuth =
//           googleUser.authentication;

//       // 5. Create Firebase credential
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken, // This will now be recognized
//         idToken: googleAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       // Success logic here...
//     } catch (e) {
//       emit(LoginError(e.toString()));
//     }
//     return null;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;

import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= EMAIL LOGIN =================
  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? "Login failed"));
    }
  }

  // ================= GOOGLE LOGIN =================
  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      final google.GoogleSignIn googleSignIn = google.GoogleSignIn.instance;

      await googleSignIn.initialize();

      final google.GoogleSignInAccount googleUser = await googleSignIn
          .authenticate();

      final google.GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        await _saveUserToFirestore(user);
      }

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> sendPasswordResetEmail(String email) async {
    emit(PasswordResetLoading());

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(PasswordResetSuccess());
    } on FirebaseAuthException catch (e) {
      emit(PasswordResetError(e.message ?? "Failed"));
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snapshot = await doc.get();

    // 👉 If user already exists → do nothing
    if (snapshot.exists) return;

    // 👉 Create new user document
    await doc.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photo': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    emit(LoginInitial());
  }
}
