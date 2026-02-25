import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_app.dart';
import 'core/services/local_storage_services.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/onboarding/presentation/screen/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = LocalStorageService();
  final bool showLogin = await storage.isOnboardingComplete();

  runApp(
    ChatApp(
      startWidget: showLogin ? const LoginScreen() : const OnboardingScreen(),
    ),
  );
}
