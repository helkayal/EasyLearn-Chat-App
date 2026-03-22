import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../screens/signup_screen.dart';

class SignupRow extends StatelessWidget {
  const SignupRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.login_no_account.tr(),
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
              (route) => false,
            );
          },
          child: Text(
            LocaleKeys.login_signup.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
