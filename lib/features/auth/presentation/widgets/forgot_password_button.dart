import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _showResetDialog(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          LocaleKeys.login_forgot_password.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final emailController = TextEditingController();
    final cubit = context.read<LoginCubit>();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: cubit,
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is PasswordResetSuccess) {
                Navigator.of(ctx).pop();
                SnackbarHelper.show(
                  context,
                  LocaleKeys.login_password_reset_sent.tr(),
                );
              } else if (state is PasswordResetError) {
                SnackbarHelper.show(context, state.message, isError: true);
              }
            },
            builder: (context, state) {
              final isLoading = state is PasswordResetLoading;

              return AlertDialog(
                title: Text(LocaleKeys.login_reset_password_title.tr()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(LocaleKeys.login_reset_password_desc.tr()),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.login_email_hint.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(ctx).pop(),
                    child: Text(LocaleKeys.login_cancel.tr()),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (emailController.text.trim().isNotEmpty) {
                              cubit.sendPasswordResetEmail(
                                emailController.text.trim(),
                              );
                            } else {
                              SnackbarHelper.show(
                                context,
                                LocaleKeys.login_email_empty_error.tr(),
                                isError: true,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(LocaleKeys.login_send_link.tr()),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
