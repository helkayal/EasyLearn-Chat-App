import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../model/message_model.dart';
import '../cubit/messages_cubit.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final String chatId;
  final String currentUserId;

  const ChatInput({
    super.key,
    required this.controller,
    required this.chatId,
    required this.currentUserId,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  void _sendText(BuildContext context) {
    final text = widget.controller.text;
    if (text.trim().isEmpty) return;
    widget.controller.clear();
    final user = FirebaseAuth.instance.currentUser;
    context.read<MessagesCubit>().sendMessage(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      senderName:
          user?.displayName ?? user?.email ?? LocaleKeys.chat_unknown.tr(),
      senderPic: user?.photoURL ?? '',
      text: text,
    );
  }

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final XFile? file = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source, imageQuality: 70);

    if (file == null) return;

    setState(() => _isUploading = true);

    try {
      final bytes = await file.readAsBytes();
      final extension = file.path.split('.').last;

      if (!mounted) return;
      await context.read<MessagesCubit>().sendMediaMessage(
        chatId: widget.chatId,
        senderId: widget.currentUserId,
        senderName:
            user.displayName ?? user.email ?? LocaleKeys.chat_unknown.tr(),
        senderPic: user.photoURL ?? '',
        type: isVideo ? MessageType.video : MessageType.image,
        bytes: bytes,
        extension: extension,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(LocaleKeys.chat_photo_gallery.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: Text(LocaleKeys.chat_video_gallery.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, isVideo: true);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.camera_alt),
              //   title: Text(LocaleKeys.chat_camera.tr()),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickMedia(ImageSource.camera);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                onPressed: () => _showAttachmentOptions(context),
                icon: const Icon(Icons.attach_file),
                color: Theme.of(context).colorScheme.primary,
              ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: LocaleKeys.chat_message_hint.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendText(context),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _sendText(context),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
