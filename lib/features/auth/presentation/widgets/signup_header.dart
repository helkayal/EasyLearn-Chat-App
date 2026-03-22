import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.signup_create_account.tr(),
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.signup_join_us_today.tr(),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Image.asset(
          "assets/images/signup_character.png",
          width: 120,
          height: 150,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
