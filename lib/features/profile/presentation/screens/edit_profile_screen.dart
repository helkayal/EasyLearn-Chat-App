import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/model/user_model.dart';
import '../../../onboarding/presentation/widgets/action_button.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _statusController = TextEditingController(text: widget.user.status);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.profile_edit_profile.tr())),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            SnackbarHelper.show(
              context,
              LocaleKeys.profile_profile_updated.tr(),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            SnackbarHelper.show(context, state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    if (_imageFile != null)
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_imageFile!),
                      )
                    else
                      CustomAvatar(
                        imageUrl: widget.user.profilePic,
                        name: widget.user.name,
                        radius: 60,
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        radius: 18,
                        child: Icon(
                          Icons.camera_alt,
                          color: theme.colorScheme.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: LocaleKeys.profile_display_name.tr(),
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: LocaleKeys.profile_status.tr(),
                controller: _statusController,
              ),
              const SizedBox(height: 40),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CustomLoadingIndicator();
                  }
                  return ActionButton(
                    label: LocaleKeys.profile_save_changes.tr(),
                    backgroundColor: theme.primaryColor,
                    textColor: theme.colorScheme.onPrimary,
                    onPressed: () {
                      final cubit = context.read<ProfileCubit>();
                      final updatedUser = UserModel(
                        uid: widget.user.uid,
                        name: _nameController.text.trim(),
                        email: widget.user.email,
                        status: _statusController.text.trim(),
                        profilePic: widget.user.profilePic,
                      );
                      if (_imageFile != null) {
                        cubit.uploadImageAndUpdate(
                          imageFile: _imageFile!,
                          user: updatedUser,
                        );
                      } else {
                        cubit.updateProfile(updatedUser);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
