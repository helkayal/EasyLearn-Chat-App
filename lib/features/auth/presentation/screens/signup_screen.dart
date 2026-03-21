import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';
import '../widgets/signin_row.dart';
import '../widgets/signup_form.dart';
import '../widgets/signup_header.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              SnackbarHelper.show(
                context,
                "Account created! Please check your email to verify your account.",
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            } else if (state is SignupError) {
              SnackbarHelper.show(context, state.message, isError: true);
            }
          },
          child: const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  SignupHeader(),
                  SizedBox(height: 30),
                  SignupForm(),
                  SigninRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
