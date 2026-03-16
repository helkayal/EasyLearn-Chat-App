import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_avatar.dart';
import '../../../auth/model/user_model.dart';

class ContactTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const ContactTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CustomAvatar(
              imageUrl: user.profilePic,
              name: user.name,
              radius: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (user.email.isNotEmpty)
                    Text(
                      user.email,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
