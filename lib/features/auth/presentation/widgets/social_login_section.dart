import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import 'social_icon.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                LocaleKeys.login_or_login_with.tr(),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 30),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SocialIcon(path: 'assets/images/google_icon.png', social: "google"),
            SocialIcon(path: 'assets/images/apple_icon.png', social: "apple"),
            SocialIcon(
              path: 'assets/images/facebook_icon.png',
              social: "facebook",
            ),
          ],
        ),
      ],
    );
  }
}
