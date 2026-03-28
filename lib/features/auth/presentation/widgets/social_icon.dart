import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';

class SocialIcon extends StatelessWidget {
  final String path;
  final String social;
  const SocialIcon({super.key, required this.path, required this.social});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return InkWell(
          onTap: isLoading
              ? null
              : social == "google"
              ? () {
                  context.read<LoginCubit>().signInWithGoogle();
                }
              : social == "apple"
              ? () {}
              : () {},
          child: Opacity(
            opacity: isLoading ? 0.5 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(path, height: 60),
            ),
          ),
        );
      },
    );
  }
}
