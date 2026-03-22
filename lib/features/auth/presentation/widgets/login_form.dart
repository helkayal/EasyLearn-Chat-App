import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
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
            label: LocaleKeys.login_email_address_label.tr(),
            controller: _emailController,
            hintText: "example@mail.com",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.login_email_empty_error.tr();
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return LocaleKeys.login_email_invalid_error.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: LocaleKeys.login_password_label.tr(),
            controller: _passwordController,
            isPassword: true,
            hintText: "••••••••",
            validator: (v) => v!.length < 6
                ? LocaleKeys.login_password_length_error.tr()
                : null,
          ),

          const ForgotPasswordButton(),
          const SizedBox(height: 30),

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return CustomLoadingIndicator(color: theme.primaryColor);
              }
              return ActionButton(
                label: LocaleKeys.login_login_button.tr(),
                backgroundColor: theme.primaryColor,
                textColor: theme.colorScheme.onPrimary,
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
