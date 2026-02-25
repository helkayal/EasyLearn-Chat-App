import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';

class SignupRow extends StatelessWidget {
  const SignupRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
              (route) => false,
            );
          },
          child: Text(
            "Sign Up",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
