import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StreamPage extends StatefulWidget {
  final String streamId;
  final String streamUrl;
  final String title;
  final bool isLive;

  const StreamPage({
    Key? key,
    required this.streamId,
    required this.streamUrl,
    required this.title,
    required this.isLive,
  }) : super(key: key);

  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          if (widget.isLive) {
            _controller.setLooping(true);
          }
        });
      });

    if (widget.isLive) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              if (!widget.isLive) VideoProgressIndicator(_controller, allowScrubbing: true),
              if (!widget.isLive)
                _buildPlayPauseButton(),
            ],
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.black54,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
