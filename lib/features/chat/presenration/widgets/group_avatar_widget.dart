import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_avatar.dart';

class GroupAvatarWidget extends StatelessWidget {
  final List<String> participantIds;
  final double radius;
  final String? groupImage;

  const GroupAvatarWidget({
    super.key,
    required this.participantIds,
    this.radius = 28,
    this.groupImage,
  });

  String _initial(String id) => id.isNotEmpty ? id[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ── If the group has an image, show it ──────────────────────────────
    if (groupImage != null && groupImage!.isNotEmpty) {
      return CustomAvatar(
        imageUrl: groupImage!,
        name: participantIds.isNotEmpty ? participantIds.first : 'G',
        radius: radius,
      );
    }

    // ── Fallback: initials / stacked avatars ────────────────────────────
    final ids = participantIds.take(3).toList();
    if (ids.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          Icons.group,
          color: theme.colorScheme.onPrimary,
          size: radius,
        ),
      );
    }

    if (ids.length == 1) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.avatarColor(ids[0]),
        child: Text(
          _initial(ids[0]),
          style: theme.textTheme.labelMedium!.copyWith(fontSize: radius * .7),
        ),
      );
    }

    final double totalWidth = radius * 2 + (ids.length - 1) * radius * 0.7;
    return SizedBox(
      width: totalWidth,
      height: radius * 2,
      child: Stack(
        children: [
          for (int i = 0; i < ids.length; i++)
            Positioned(
              left: i * radius * 0.7,
              child: CircleAvatar(
                radius: radius * 0.75,
                backgroundColor: theme.colorScheme.onPrimary,
                child: CircleAvatar(
                  radius: radius * 0.72,
                  backgroundColor: AppColors.avatarColor(ids[i]),
                  child: Text(
                    _initial(ids[i]),
                    style: theme.textTheme.labelMedium!.copyWith(
                      fontSize: radius * .55,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
