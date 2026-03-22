import 'package:chat_app/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_app.dart';
import 'core/services/local_storage_services.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/onboarding/presentation/screen/onboarding_screen.dart';
import 'features/settings/presenration/cubit/language_cubit.dart';
import 'features/settings/presenration/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await EasyLocalization.ensureInitialized();

  final storage = LocalStorageService();
  final bool showLogin = await storage.isOnboardingComplete();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('es'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => LanguageCubit()),
        ],
        child: ChatApp(
          startWidget: showLogin ? LoginScreen() : OnboardingScreen(),
        ),
      ),
    ),
  );
}
