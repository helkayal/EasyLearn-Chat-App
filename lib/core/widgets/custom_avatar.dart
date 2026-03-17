import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double radius;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.avatarColor(name),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: Theme.of(
          context,
        ).textTheme.labelMedium!.copyWith(fontSize: radius * 0.6),
      ),
    );
  }
}
