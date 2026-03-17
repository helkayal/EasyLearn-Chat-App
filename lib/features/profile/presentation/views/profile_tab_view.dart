import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_tab_body.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    context.read<ProfileCubit>().getUserData();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const CustomLoadingIndicator();
        }

        final user = (state is ProfileLoaded)
            ? state.user
            : (state as ProfileSuccess).user;

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: theme.colorScheme.error),
                onPressed: () async {
                  await context.read<ProfileCubit>().logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: ProfileTabBody(user: user, theme: theme),
        );
      },
    );
  }
}
