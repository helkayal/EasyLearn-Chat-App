import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
      appBar: AppBar(title: const Text("Edit Profile")),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
            Navigator.pop(context);
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
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : NetworkImage(widget.user.profilePic)
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        radius: 18,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Display Name",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(label: "Status", controller: _statusController),
              const SizedBox(height: 40),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ActionButton(
                    label: "Save Changes",
                    backgroundColor: theme.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      final updatedUser = UserModel(
                        uid: widget.user.uid,
                        name: _nameController.text.trim(),
                        email: widget.user.email,
                        status: _statusController.text.trim(),
                        profilePic: widget.user.profilePic,
                      );
                      context.read<ProfileCubit>().updateProfile(updatedUser);
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
