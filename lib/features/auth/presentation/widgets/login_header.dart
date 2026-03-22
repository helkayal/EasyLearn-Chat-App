import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.login_hello.tr(), style: textTheme.displayMedium),
              Text(
                LocaleKeys.login_welcome_back.tr(),
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.login_happy_to_see_you.tr(),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/login_character.png',
          width: 100,
          height: 150,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
