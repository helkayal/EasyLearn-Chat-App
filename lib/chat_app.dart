import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/presenration/cubit/language_cubit.dart';
import 'features/settings/presenration/cubit/theme_cubit.dart';

class ChatApp extends StatelessWidget {
  final Widget startWidget;
  const ChatApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    context.read<LanguageCubit>().initLocale(context);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: startWidget,
        );
      },
    );
  }
}
