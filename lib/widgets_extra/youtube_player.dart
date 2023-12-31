import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MsYouTubePlayer extends StatefulWidget {
  final String videoId;
  const MsYouTubePlayer({super.key, required this.videoId});

  @override
  State<MsYouTubePlayer> createState() => _MsYouTubePlayerState();
}

class _MsYouTubePlayerState extends State<MsYouTubePlayer> {
  late YoutubePlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        enableCaption: false,
        showVideoAnnotations: false,
        playsInline: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller,
      gestureRecognizers: const {},
      enableFullScreenOnVerticalDrag: false,
      backgroundColor: Colors.black,
    );
  }
}
