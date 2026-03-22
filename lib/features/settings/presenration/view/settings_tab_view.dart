import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../widgets/language_selector_widget.dart';
import '../widgets/theme_toggle_widget.dart';

class SettingsTabView extends StatelessWidget {
  const SettingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_title.tr())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              LocaleKeys.settings_theme.tr(),
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const ThemeToggleWidget(),
            const SizedBox(height: 40),
            Text(
              LocaleKeys.settings_change_language.tr(),
              style: theme.textTheme.displayMedium,
            ),
            const LanguageSelectorWidget(),
          ],
        ),
      ),
    );
  }
}
