import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:nerdvalorant/pages/pixels/widgets/pixel_icon_item.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({Key? key, required this.videoId}) : super(key: key);

  final String videoId;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  bool onPlay = true;
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        loop: true,
        forceHD: true,
        autoPlay: true,
        hideControls: true,
        hideThumbnail: true,
      ),
    );

    _initScreenPosition();
  }

  Future<void> _initScreenPosition() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> interceptRollBack() async {
      SystemUiMode edgeToEdge = SystemUiMode.edgeToEdge;
      List<DeviceOrientation> orientation = [DeviceOrientation.portraitUp];

      SystemChrome.setPreferredOrientations(orientation);
      SystemChrome.setEnabledSystemUIMode(edgeToEdge, overlays: []);

      return true;
    }

    return WillPopScope(
      onWillPop: interceptRollBack,
      child: Stack(
        children: [
          YoutubePlayer(
            controller: controller,
            progressColors: ProgressBarColors(
              playedColor: greenColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: goBack,
                child: Container(
                  height: ScreenSize.screenHeight,
                  width: ScreenSize.screenWidth / 3,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: onPlay == false
                      ? const IconItem(
                          icon: Ionicons.play_skip_back_circle_outline,
                          size: 12,
                        )
                      : null,
                ),
              ),
              GestureDetector(
                onTap: playPause,
                child: Container(
                  height: ScreenSize.screenHeight,
                  width: ScreenSize.screenWidth / 3,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: onPlay == false
                      ? const IconItem(
                          icon: Ionicons.play_circle_outline,
                          size: 20,
                        )
                      : null,
                ),
              ),
              GestureDetector(
                onDoubleTap: goForward,
                child: Container(
                  height: ScreenSize.screenHeight,
                  width: ScreenSize.screenWidth / 3,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: onPlay == false
                      ? const IconItem(
                          icon: Ionicons.play_skip_forward_circle_outline,
                          size: 12,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void playPause() {
    !onPlay ? controller.play() : controller.pause();

    setState(() => onPlay = !onPlay);
  }

  void goForward({int seconds = 3}) {
    Duration time = controller.value.position;

    setState(() {
      controller.seekTo(time + Duration(seconds: seconds));
      onPlay = true;
    });
  }

  void goBack({int seconds = 3}) {
    Duration time = controller.value.position;

    setState(() {
      controller.seekTo(time - Duration(seconds: seconds));
      onPlay = true;
    });
  }
}
