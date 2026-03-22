import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_avatar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/model/user_model.dart';
import '../cubit/profile_cubit.dart';
import '../screens/edit_profile_screen.dart';

class ProfileTabBody extends StatelessWidget {
  const ProfileTabBody({super.key, required this.user, required this.theme});

  final UserModel user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: CustomAvatar(
            imageUrl: user.profilePic,
            name: user.name,
            radius: 60,
          ),
        ),
        const SizedBox(height: 20),
        Text(user.name, style: theme.textTheme.displayMedium),
        Text(user.email, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.dividerTheme.color?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: theme.primaryColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(user.status, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              side: BorderSide(color: theme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (innerContext) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: EditProfileScreen(user: user),
                  ),
                ),
              );
            },
            child: Text(
              LocaleKeys.profile_edit_profile.tr(),
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
