import 'package:flutter/material.dart';

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
              Text("Create Account", style: textTheme.displayLarge),
              const SizedBox(height: 10),
              Text(
                "Join us today! Please fill in your details to get started.",
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
