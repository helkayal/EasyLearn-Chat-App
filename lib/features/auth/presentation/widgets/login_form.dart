import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../onboarding/presentation/widgets/action_button.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';
import 'forgot_password_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: "Email Address",
            controller: _emailController,
            hintText: "example@mail.com",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: "Password",
            controller: _passwordController,
            isPassword: true,
            hintText: "••••••••",
            validator: (v) =>
                v!.length < 6 ? "Password must be 6+ characters" : null,
          ),

          const ForgotPasswordButton(),
          const SizedBox(height: 30),

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return CircularProgressIndicator(color: theme.primaryColor);
              }
              return ActionButton(
                label: "Login",
                backgroundColor: theme.primaryColor,
                textColor: AppColors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginCubit>().login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
