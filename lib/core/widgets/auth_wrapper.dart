import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screen/onboarding_screen.dart';

class AuthWrapper extends StatelessWidget {
  final bool showLogin;

  const AuthWrapper({super.key, required this.showLogin});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in
          return const HomeScreen();
        }

        // User is not signed in
        if (showLogin) {
          return const LoginScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
