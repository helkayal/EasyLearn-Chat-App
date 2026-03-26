import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessagePlayerWidget extends StatefulWidget {
  final String url;

  const VideoMessagePlayerWidget({super.key, required this.url});

  @override
  State<VideoMessagePlayerWidget> createState() =>
      _VideoMessagePlayerWidgetState();
}

class _VideoMessagePlayerWidgetState extends State<VideoMessagePlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize()
          .then((_) {
            // Ensure the first frame is shown after the video is initialized
            if (mounted) setState(() => _isInitialized = true);
          })
          .catchError((_) {
            // ignore: avoid_print
            print("Video playback error");
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
        ],
      ),
    );
  }
}
