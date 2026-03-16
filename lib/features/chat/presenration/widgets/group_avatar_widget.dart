import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class GroupAvatarWidget extends StatelessWidget {
  final List<String> participantIds;
  final double radius;

  const GroupAvatarWidget({
    super.key,
    required this.participantIds,
    this.radius = 28,
  });

  String _initial(String id) => id.isNotEmpty ? id[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final ids = participantIds.take(3).toList();
    if (ids.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF7B2CBF),
        child: Icon(Icons.group, color: Colors.white, size: radius),
      );
    }

    if (ids.length == 1) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.avatarColor(ids[0]),
        child: Text(
          _initial(ids[0]),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.7,
          ),
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
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: radius * 0.72,
                  backgroundColor: AppColors.avatarColor(ids[i]),
                  child: Text(
                    _initial(ids[i]),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: radius * 0.55,
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
