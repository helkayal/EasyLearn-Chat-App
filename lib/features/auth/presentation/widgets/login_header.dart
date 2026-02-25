import 'package:flutter/material.dart';

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
              Text("Hello, ", style: textTheme.displayMedium),
              Text("Welcome Back", style: textTheme.displayMedium),
              const SizedBox(height: 10),
              Text(
                "Happy to see you again, to use your account please login first.",
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
