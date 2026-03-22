import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../cubit/theme_cubit.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                LocaleKeys.settings_light.tr(),
                currentMode == ThemeMode.light,
                () => context.read<ThemeCubit>().updateTheme(ThemeMode.light),
              ),
              _toggleItem(
                context,
                LocaleKeys.settings_dark.tr(),
                currentMode == ThemeMode.dark,
                () => context.read<ThemeCubit>().updateTheme(ThemeMode.dark),
              ),
            ],
          );
        },
      ),
    );
  }
}
