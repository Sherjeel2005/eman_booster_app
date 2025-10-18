import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/video_model.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoModel video;
  VideoPlayerPage({required this.video});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.video.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? GestureDetector(
          onTap: _toggleControls,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video
                VideoPlayer(_controller),

                // Controls Overlay
                if (_showControls)
                  _ControlsOverlay(
                    controller: _controller,
                    onPlayPause: _togglePlayPause,
                  ),

                // Progress bar (fixed at bottom inside video)
                if (_showControls)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(8),
                      colors: VideoProgressColors(
                        playedColor: Colors.tealAccent,
                        bufferedColor: Colors.white54,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

/// Overlay controls widget
class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onPlayPause;

  const _ControlsOverlay({
    Key? key,
    required this.controller,
    required this.onPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26, // semi-transparent overlay
      child: Center(
        child: IconButton(
          iconSize: 60,
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: onPlayPause,
        ),
      ),
    );
  }
}
