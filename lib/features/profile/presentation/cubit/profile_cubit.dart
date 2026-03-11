import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/model/user_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      emit(
        ProfileLoaded(UserModel.fromMap(doc.data() as Map<String, dynamic>)),
      );
    }
  }

  Future<void> updateProfile(UserModel user) async {
    emit(ProfileLoading());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(user.toMap());
      emit(ProfileLoaded(user));
      emit(ProfileSuccess(user));
    } catch (e) {
      emit(ProfileError("Failed to update profile: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // await GoogleSignIn().signOut();
  }
}
