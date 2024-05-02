import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final bool audioOnly;

  const VideoPlayerScreen(this.url, this.audioOnly, {super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) {
        setState(() {});
      });
    _controller.setVolume(1.0);
    _controller.addListener(() {setState(() {});});    
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: widget.audioOnly
              ? 5
              : _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                  }
                });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _controller.value.isPlaying
                     ? Icons.pause
                     : Icons.play_arrow,
                  ),
                )
              ),
              const SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  setState(() {
                  // If the video is playing, pause it.
                  if (_controller.value.volume == 0) {
                    _controller.setVolume(1.0);
                  } else {
                    // If the video is paused, play it.
                    _controller.setVolume(0);
                  }
                });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _controller.value.volume == 0
                     ? Icons.volume_off
                     : Icons.volume_up,
                  ),
                )
              )
            ],
          )
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator while video is loading
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}