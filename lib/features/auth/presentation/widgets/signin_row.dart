import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../screens/login_screen.dart';

class SigninRow extends StatelessWidget {
  const SigninRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.signup_already_have_account.tr(),
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          child: Text(
            LocaleKeys.signup_login.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
