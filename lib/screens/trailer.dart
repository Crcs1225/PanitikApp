import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayTrailerScreen extends StatefulWidget {
  final String videoUrl;

  const PlayTrailerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<PlayTrailerScreen> createState() => _PlayTrailerScreenState();
}

class _PlayTrailerScreenState extends State<PlayTrailerScreen> {
  late YoutubePlayerController _controller;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
    print(widget.videoUrl);
    _isVideoLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: _isVideoLoading
            ? CircularProgressIndicator()
            : YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () => debugPrint('Ready'),
                bottomActions: [
                  CurrentPosition(),
                  FullScreenButton(),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                      playedColor: Colors.brown,
                      handleColor: Colors.brown,
                    ),
                  ),
                  const PlaybackSpeedButton(),
                ],
              ),
      ),
    );
  }
}
