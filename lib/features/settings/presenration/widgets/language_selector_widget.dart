import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../cubit/language_cubit.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  String _getLanguageName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.arabic:
        return "العربية";
      case AppLanguage.french:
        return "Français";
      case AppLanguage.spanish:
        return "Español";
      default:
        return "English";
    }
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
              return RadioGroup<AppLanguage>(
                groupValue: currentLang,
                onChanged: (AppLanguage? val) {
                  if (val != null) {
                    languageCubit.changeLanguage(context, val);
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: AppLanguage.values.map((lang) {
                    return RadioListTile<AppLanguage>(
                      title: Text(
                        _getLanguageName(lang),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      value: lang,
                      activeColor: Theme.of(context).colorScheme.primary,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LanguageCubit, AppLanguage>(
      builder: (context, currentLang) {
        return ListTile(
          title: Text(
            LocaleKeys.settings_language.tr(),
            style: theme.textTheme.bodyLarge,
          ),
          trailing: InkWell(
            onTap: () => _showLanguagePicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getLanguageName(currentLang),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
