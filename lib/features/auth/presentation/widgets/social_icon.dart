import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String path;
  final String social;
  const SocialIcon({super.key, required this.path, required this.social});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: social == "google"
          ? () {}
          : social == "apple"
          ? () {}
          : () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.asset(path, height: 60),
      ),
    );
  }
}
