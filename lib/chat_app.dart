import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/presenration/cubit/theme_cubit.dart';

class ChatApp extends StatelessWidget {
  final Widget startWidget;
  const ChatApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: startWidget,
        );
      },
    );
  }
}
