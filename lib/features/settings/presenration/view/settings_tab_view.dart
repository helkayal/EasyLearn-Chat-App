import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/language_cubit.dart';
import '../cubit/theme_cubit.dart';

class SettingsTabView extends StatelessWidget {
  const SettingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Theme", style: theme.textTheme.displayMedium),
            const SizedBox(height: 16),

            // --- THEME TOGGLE ---
            Container(
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, currentMode) {
                  return Row(
                    children: [
                      _toggleItem(
                        context,
                        "light",
                        currentMode == ThemeMode.light,
                        () => context.read<ThemeCubit>().updateTheme(
                          ThemeMode.light,
                        ),
                      ),
                      _toggleItem(
                        context,
                        "dark",
                        currentMode == ThemeMode.dark,
                        () => context.read<ThemeCubit>().updateTheme(
                          ThemeMode.dark,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
            Text("Change Language", style: theme.textTheme.displayMedium),

            // --- LANGUAGE SELECTOR ---
            BlocBuilder<LanguageCubit, AppLanguage>(
              builder: (context, currentLang) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Language", style: theme.textTheme.bodyLarge),
                  trailing: InkWell(
                    onTap: () => _showLanguagePicker(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLang.name.toUpperCase(),
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final languageCubit = context.read<LanguageCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder<LanguageCubit, AppLanguage>(
            bloc: languageCubit,
            builder: (context, currentLang) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: AppLanguage.values.map((lang) {
                  return RadioListTile<AppLanguage>(
                    title: Text(
                      lang.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    value: lang,
                    groupValue: currentLang,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (AppLanguage? val) {
                      if (val != null) {
                        languageCubit.changeLanguage(val);
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
