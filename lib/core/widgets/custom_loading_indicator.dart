import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color? color;

  const CustomLoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
