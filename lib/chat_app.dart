import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class ChatApp extends StatelessWidget {
  final Widget startWidget;
  const ChatApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: startWidget,
    );
  }
}
