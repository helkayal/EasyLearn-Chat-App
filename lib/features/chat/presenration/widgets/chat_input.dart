import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

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
  bool _isComposing = false;
  bool _isRecording = false;
  bool _isFilePickerActive = false;

  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isComposing = widget.controller.text.trim().isNotEmpty;
    if (_isComposing != isComposing) {
      setState(() => _isComposing = isComposing);
    }
  }

  void _sendText(BuildContext context) {
    if (_isUploading || _isRecording) return;
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;

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
        ? await _imagePicker.pickVideo(source: source)
        : await _imagePicker.pickImage(source: source, imageQuality: 70);

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

  Future<void> _pickAudioFile() async {
    if (_isFilePickerActive) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isFilePickerActive = true);

    try {
      // Delay prevents multiple pop interactions that cause multiple_request exceptions on desktop
      await Future.delayed(const Duration(milliseconds: 300));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav', 'aac', 'ogg'],
      );
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final file = File(path);
        final bytes = await file.readAsBytes();
        final extension = path.split('.').last;

        setState(() => _isUploading = true);
        if (!mounted) return;
        await context.read<MessagesCubit>().sendMediaMessage(
          chatId: widget.chatId,
          senderId: widget.currentUserId,
          senderName:
              user.displayName ?? user.email ?? LocaleKeys.chat_unknown.tr(),
          senderPic: user.photoURL ?? '',
          type: MessageType.audio,
          bytes: bytes,
          extension: extension,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick audio: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isFilePickerActive = false;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    if (_isUploading) return;
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), // m4a
          path: path,
        );
        setState(() => _isRecording = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        final file = File(path);
        final bytes = await file.readAsBytes();

        setState(() => _isUploading = true);
        if (!mounted) return;
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        await context.read<MessagesCubit>().sendMediaMessage(
          chatId: widget.chatId,
          senderId: widget.currentUserId,
          senderName:
              user.displayName ?? user.email ?? LocaleKeys.chat_unknown.tr(),
          senderPic: user.photoURL ?? '',
          type: MessageType.audio,
          bytes: bytes,
          extension: 'm4a',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to stop recording: $e')));
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
              ListTile(
                leading: const Icon(Icons.audio_file),
                title: Text(LocaleKeys.chat_audio_file.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickAudioFile();
                },
              ),
              // Camera might be disabled manually by designer, leaving commented out
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
            else if (!_isRecording)
              IconButton(
                onPressed: () => _showAttachmentOptions(context),
                icon: const Icon(Icons.attach_file),
                color: Theme.of(context).colorScheme.primary,
              ),
            Expanded(
              child: _isRecording
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Recording...',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : TextField(
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
            _isComposing && !_isRecording
                ? IconButton.filled(
                    onPressed: () => _sendText(context),
                    icon: const Icon(Icons.send),
                  )
                : GestureDetector(
                    onTap: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: _isRecording
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
