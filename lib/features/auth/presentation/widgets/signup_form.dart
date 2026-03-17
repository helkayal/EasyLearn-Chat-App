import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            label: "Full Name",
            controller: _nameController,
            hintText: "Enter your name",
            validator: (v) => v!.isEmpty ? "Name is required" : null,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: "Email Address",
            controller: _emailController,
            hintText: "example@mail.com",
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return "Invalid email format";
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
                v!.length < 6 ? "Minimum 6 characters required" : null,
          ),
          const SizedBox(height: 40),
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              if (state is SignupLoading) {
                return CustomLoadingIndicator(color: theme.primaryColor);
              }
              return ActionButton(
                label: "Create Account",
                backgroundColor: theme.primaryColor,
                textColor: Colors.white,
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
