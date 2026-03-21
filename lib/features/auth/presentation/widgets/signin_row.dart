import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class SigninRow extends StatelessWidget {
  const SigninRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?", style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          child: Text(
            "Login",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
