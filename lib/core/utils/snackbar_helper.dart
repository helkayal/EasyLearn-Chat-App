import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;

    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : null,
      ),
    );
  }
}
