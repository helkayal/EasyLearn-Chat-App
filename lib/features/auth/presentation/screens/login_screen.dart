import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_row.dart';
import '../widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        // body: BlocListener<LoginCubit, LoginState>(
        //   listener: (context, state) {
        //     if (state is LoginSuccess) {
        //       Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (context) => HomeScreen()),
        //         (route) => false,
        //       );
        //     } else if (state is LoginError) {
        //       SnackbarHelper.show(context, state.message, isError: true);
        //     }
        //   },
        //   child: const SafeArea(
        //     child: SingleChildScrollView(
        //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        //       child: Column(
        //         children: [
        //           LoginHeader(),
        //           SizedBox(height: 40),
        //           LoginForm(),
        //           SignupRow(),
        //           SizedBox(height: 50),
        //           SocialLoginSection(),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            } else if (state is LoginError) {
              SnackbarHelper.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                const SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      children: [
                        LoginHeader(),
                        SizedBox(height: 40),
                        LoginForm(),
                        SignupRow(),
                        SizedBox(height: 50),
                        SocialLoginSection(),
                      ],
                    ),
                  ),
                ),

                // 🔥 GLOBAL LOADING OVERLAY
                if (state is LoginLoading)
                  Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: .3),
                    child: const Center(child: CustomLoadingIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
