import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../onboarding/presentation/widgets/action_button.dart';
import '../cubit/signup_cubit.dart';
import '../cubit/signup_state.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
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
            label: LocaleKeys.signup_full_name_label.tr(),
            controller: _nameController,
            hintText: LocaleKeys.signup_name_hint.tr(),
            validator: (v) =>
                v!.isEmpty ? LocaleKeys.signup_name_empty_error.tr() : null,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: LocaleKeys.signup_email_address_label.tr(),
            controller: _emailController,
            hintText: "example@mail.com",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.signup_email_empty_error.tr();
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return LocaleKeys.signup_email_invalid_error.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: LocaleKeys.signup_password_label.tr(),
            controller: _passwordController,
            isPassword: true,
            hintText: "••••••••",
            validator: (v) => v!.length < 6
                ? LocaleKeys.signup_password_length_error.tr()
                : null,
          ),
          const SizedBox(height: 40),
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              if (state is SignupLoading) {
                return CustomLoadingIndicator(color: theme.primaryColor);
              }
              return ActionButton(
                label: LocaleKeys.signup_create_account.tr(),
                backgroundColor: theme.primaryColor,
                textColor: theme.colorScheme.onPrimary,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupCubit>().signUp(
                      _nameController.text.trim(),
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
