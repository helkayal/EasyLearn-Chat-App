import 'package:flutter/material.dart';

import '../../../auth/model/user_model.dart';

class ChatItemCard extends StatelessWidget {
  final UserModel user; //

  const ChatItemCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            user.profilePic.isNotEmpty
                ? user.profilePic
                : 'https://via.placeholder.com/150',
          ), //
        ),
        title: Text(
          user.name, //
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.status, //
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "15:43", // Static for now
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                user.uid,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
