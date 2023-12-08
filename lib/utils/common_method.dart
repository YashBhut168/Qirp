
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:audio_service/audio_service.dart';
// import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ControlButtons extends StatefulWidget {
  final AudioPlayer audioPlayer;
  double? size;

  ControlButtons(
    this.audioPlayer, {
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  MainScreenController controller = Get.put(MainScreenController());
  bool isMusicPlaying = false;
  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          isMusicPlaying = playerState.playing;
          isMusicPlaying == true
              ? controller.musicPlay.value = true
              : controller.musicPlay.value = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  // strokeWidth: 1,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_circle_outline_rounded),
                iconSize: widget.size ?? 80.0,
                onPressed: widget.audioPlayer.play,
                color: AppColors.white,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_outline),
                iconSize: widget.size ?? 80.0,
                onPressed: widget.audioPlayer.pause,
                color: AppColors.white,
              );
            } else {
              return IconButton(
                color: AppColors.white,
                icon: const Icon(Icons.replay),
                iconSize: widget.size ?? 80.0,
                onPressed: () => widget.audioPlayer.seek(Duration.zero),
              );
            }
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  bool? isTrackTimeShow;

  SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.isTrackTimeShow,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  // bool isTrackTimeShow = true;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: HiddenThumbComponentShape(),
              activeTrackColor: Colors.blue.shade100,
              inactiveTrackColor: Colors.grey.shade300,
            ),
            child: ExcludeSemantics(
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SliderTheme(
            data: _sliderThemeData.copyWith(
              inactiveTrackColor: Colors.transparent,
            ),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        widget.isTrackTimeShow == true
            ? Positioned(
                left: 20.0,
                bottom: -5.0,
                child: Text(
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch("$_currentPossion")
                            ?.group(1) ??
                        '$_currentPossion',
                    style: TextStyle(color: AppColors.white)),
              )
            : const SizedBox(),
        widget.isTrackTimeShow == true
            ? Positioned(
                right: 20.0,
                bottom: -5.0,
                child: Text(
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch("$_remaining")
                            ?.group(1) ??
                        '$_remaining',
                    style: TextStyle(color: AppColors.white)),
              )
            : const SizedBox(),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
  Duration get _currentPossion => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}
// audio_player_handler.dart

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> onPlay() async {
    await _audioPlayer.play();
    mediaItem.add(_mediaItem);
  }

  Future<void> onPause() async {
    await _audioPlayer.pause();
  }

  Future<void> onSkipToNext() async {
    // Implement logic to skip to the next track
  }

  Future<void> onSkipToPrevious() async {
    // Implement logic to skip to the previous track
  }

  // Add other playback control methods as needed

  Future<void> onCustomAction(String name, Map<String, dynamic> extras) async {
    // Implement custom actions, if needed
  }

  final MediaItem _mediaItem = MediaItem(
    id: 'your_media_item_id',
    title: 'Your Song Title',
    artist: 'Artist Name',
    album: 'Album Name',
    duration: const Duration(milliseconds: 0), // Update with actual duration
    artUri: Uri.parse('your_art_uri'), // Update with the artwork URI
  );
}

// // ignore: must_be_immutable
// class ContentScreen extends StatefulWidget {
//   final String src;
//   // ignore: prefer_typing_uninitialized_variables
//   var reelData;
//   // ignore: prefer_typing_uninitialized_variables
//   var index;

//   ContentScreen({Key? key, required this.src, this.reelData, this.index})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ContentScreenState createState() => _ContentScreenState();
// }

// class _ContentScreenState extends State<ContentScreen> {
//   ReelsScreenController reelsScreenController =
//       Get.put(ReelsScreenController());
//   MainScreenController controller = Get.put(MainScreenController());
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? chewieController;

//   // bool _liked = false;
//   @override
//   void initState() {
//     super.initState();
//     // print("userid>>>>> ${widget.reelData.userId}");
//     // print("reelid>>>>> ${widget.reelData.id}");
//     reelsScreenController.viewReels(
//       reelId: "${widget.reelData.id}",
//       userId: "${widget.reelData.userId}",
//     );

//     GlobVar.reelIndex = widget.index;
//     if (kDebugMode) {
//       print('GlobVar.reelIndex-----> ${GlobVar.reelIndex}');
//     }
//     // viewReel();

//     // controller.currentIndex.value == 2 ?
//     initializePlayer();
//     //  : null;
//   }

//   //  viewReel() {
//   //   print("userid>>>>> ${widget.reelData.userId}");
//   //   print("reelid>>>>> ${widget.reelData.id}");
//   //   reelsScreenController.viewReels(
//   //     reelId: widget.reelData.id,
//   //     userId: widget.reelData.userId,
//   //   );
//   // }

//   Future initializePlayer() async {
//     // ignore: deprecated_member_use
//     setState(() {
//             GlobVar.reelVideoList = List.generate(
//                           reelsScreenController.reelsData.length,
//                           (index) =>
//                               reelsScreenController.reelsData[index].postPic!,
//                         );
//             if (kDebugMode) {
//               print("GlobVar.reelVideoList IN COMMON ${GlobVar.reelVideoList}");
//             }
//             if (kDebugMode) {
//               print("GlobVar.reelVideoList length IN COMMON ${GlobVar.reelVideoList.length}");
//             }
//             // reelsScreenController.allReelsVideo[0];
//       _videoPlayerController = VideoPlayerController.network(GlobVar.reelVideoList[widget.index])
//         ..initialize().then((_) {
//           setState(() {
//             controller.currentIndex.value == 2
//                 ? _videoPlayerController!.play()
//                 : null;
//           });
//         });
//       _videoPlayerController!.addListener(() {
//         if (_videoPlayerController!.value.hasError) {
//           if (kDebugMode) {
//             print(
//               'video player controller Error: ${_videoPlayerController!.value.errorDescription}');
//           }
//         }
//       });
//     });
//     // await Future.wait([_videoPlayerController.initialize()]);
//     chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController!,
//       autoPlay: true,
//       showControls: false,
//       allowFullScreen: false,
//       looping: true,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: const TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//     setState(() {});
//   }

//   @override
//   void dispose() {  
//     if (_videoPlayerController != null) {
//       _videoPlayerController!.dispose();
//     }
//     if (chewieController != null) {
//       chewieController!.dispose();
//       chewieController!.setVolume(0);
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           chewieController != null &&
//                   chewieController!.videoPlayerController.value.isInitialized
//               ?
//               // GestureDetector(
//               //     onDoubleTap: () {
//               //       setState(() {
//               //         _liked = !_liked;
//               //       });
//               //     },
//               // child:
//               AspectRatio(
//                   aspectRatio: _videoPlayerController!.value.aspectRatio,
//                   child: Chewie(
//                     controller: chewieController!,
//                   ),
//                 )
//               // )
//               : const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     // SizedBox(height: 10),
//                     // Text('Loading...')
//                   ],
//                 ),
//           // if (_liked)
//           //   Center(
//           //     child: LikeIcon(),
//           //   ),
//           OptionsScreen(
//             reelData: widget.reelData,
//             index: widget.index,
//           )
//         ],
//       ),
//     );
//   }
// }











////---------> usable comman vido method

// // ignore: must_be_immutable
// class ContentScreen extends StatefulWidget {
//   final String src;
//   // ignore: prefer_typing_uninitialized_variables
//   var reelData;
//   // ignore: prefer_typing_uninitialized_variables
//   var index;

//   ContentScreen({Key? key, required this.src, this.reelData, this.index})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ContentScreenState createState() => _ContentScreenState();
// }



// // with video player


// class _ContentScreenState extends State<ContentScreen> {
//   ReelsScreenController reelsScreenController =
//       Get.put(ReelsScreenController());
//   MainScreenController controller = Get.put(MainScreenController());
//   late VideoPlayerController _videoPlayerController;
//   // ChewieController? chewieController;

//   // bool _liked = false;
//   @override
//   void initState() {
//     super.initState();
//     // print("userid>>>>> ${widget.reelData.userId}");
//     // print("reelid>>>>> ${widget.reelData.id}");
//     reelsScreenController.viewReels(
//       reelId: "${widget.reelData.id}",
//       userId: "${widget.reelData.userId}",
//     );

//     GlobVar.reelIndex = widget.index;
//     if (kDebugMode) {
//       print('GlobVar.reelIndex-----> ${GlobVar.reelIndex}');
//     }
//     // viewReel();

//      initializePlayer();
//   }

//   //  viewReel() {
//   //   print("userid>>>>> ${widget.reelData.userId}");
//   //   print("reelid>>>>> ${widget.reelData.id}");
//   //   reelsScreenController.viewReels(
//   //     reelId: widget.reelData.id,
//   //     userId: widget.reelData.userId,
//   //   );
//   // }

//   Future initializePlayer() async {
//     // ignore: deprecated_member_use
//     _videoPlayerController = VideoPlayerController.network(widget.src)
//       ..initialize().then((_) {
//           setState(() {});
//           // _showBottomSheet(context);
//           controller.currentIndex.value == 2 ?  _videoPlayerController.play() : null;
//         });
//     // await Future.wait([_videoPlayerController.initialize()]);
//     // chewieController = ChewieController(
//     //   videoPlayerController: _videoPlayerController,
//     //   autoPlay: true,
//     //   showControls: false,
//     //   allowFullScreen: true,
//     //   looping: true,
//     // );
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//          _videoPlayerController.value.isInitialized
//               ?
//               // GestureDetector(
//               //     onDoubleTap: () {
//               //       setState(() {
//               //         _liked = !_liked;
//               //       });
//               //     },
//               // child:
//               AspectRatio(
//                   aspectRatio: _videoPlayerController.value.aspectRatio,
//                   child: VideoPlayer(
//                   _videoPlayerController,
                  
//                 )
//               )
//               : const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     // SizedBox(height: 10),
//                     // Text('Loading...')
//                   ],
//                 ),
//           // if (_liked)
//           //   Center(
//           //     child: LikeIcon(),
//           //   ),
//           OptionsScreen(
//             reelData: widget.reelData,
//             index: widget.index,
//           )
//         ],
//       ),
//     );
//   }
// }

// class LikeIcon extends StatelessWidget {
//   Future<int> tempFuture() async {
//     return Future.delayed(Duration(seconds: 1));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FutureBuilder(
//         future: tempFuture(),
//         builder: (context, snapshot) =>
//             snapshot.connectionState != ConnectionState.done
//                 ? Icon(Icons.favorite, size: 110)
//                 : SizedBox(),
//       ),
//     );
//   }
// }

// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'dart:math';

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer audioPlayer;

//   const ControlButtons(this.audioPlayer, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         StreamBuilder<PlayerState>(
//           stream: audioPlayer.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 45.0,
//                 height: 45.0,
//                 child: CircularProgressIndicator(
//                   color: AppColors.white,
//                   // strokeWidth: 1,
//                 ),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: audioPlayer.play,
//                 color: AppColors.white,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: audioPlayer.pause,
//                 color: AppColors.white,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.replay),
//                 iconSize: 64.0,
//                 color: AppColors.white,
//                 onPressed: () => audioPlayer.seek(Duration.zero),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// class SeekBar extends StatefulWidget {
//   final Duration duration;
//   final Duration position;
//   final Duration bufferedPosition;
//   final ValueChanged<Duration>? onChanged;
//   final ValueChanged<Duration>? onChangeEnd;

//   const SeekBar({
//     Key? key,
//     required this.duration,
//     required this.position,
//     required this.bufferedPosition,
//     this.onChanged,
//     this.onChangeEnd,
//   }) : super(key: key);

//   @override
//   SeekBarState createState() => SeekBarState();
// }

// class SeekBarState extends State<SeekBar> {
//   double? _dragValue;
//   late SliderThemeData _sliderThemeData;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//      _sliderThemeData = SliderTheme.of(context).copyWith(
//       trackHeight: 2.0,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//                     .firstMatch("$_currentPossion")
//                     ?.group(1) ??
//                 '$_currentPossion',
//             style: TextStyle(color: AppColors.white),
//           ),
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 2),
//                 child: SliderTheme(
//                   data: _sliderThemeData.copyWith(
//                     thumbShape: HiddenThumbComponentShape(),
//                     activeTrackColor: Colors.blue.shade100,
//                     inactiveTrackColor: Colors.grey.shade300,
//                     trackHeight: 2.0,
//                   ),
//                   child: ExcludeSemantics(
//                     child: Slider(
//                       min: 0.0,
//                       max: widget.duration.inMilliseconds.toDouble(),
//                       value: min(
//                           widget.bufferedPosition.inMilliseconds.toDouble(),
//                           widget.duration.inMilliseconds.toDouble()),
//                       onChanged: (value) {
//                         setState(() {
//                           _dragValue = value;
//                         });
//                         if (widget.onChanged != null) {
//                           widget
//                               .onChanged!(Duration(milliseconds: value.round()));
//                         }
//                       },
//                       onChangeEnd: (value) {
//                         if (widget.onChangeEnd != null) {
//                           widget.onChangeEnd!(
//                               Duration(milliseconds: value.round()));
//                         }
//                         _dragValue = null;
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SliderTheme(
//                 data: _sliderThemeData.copyWith(
//                   inactiveTrackColor: Colors.transparent,
//                 ),
//                 child: Slider(
//                   min: 0.0,
//                   max: widget.duration.inMilliseconds.toDouble(),
//                   value: min(
//                       _dragValue ?? widget.position.inMilliseconds.toDouble(),
//                       widget.duration.inMilliseconds.toDouble()),
//                   onChanged: (value) {
//                     setState(() {
//                       _dragValue = value;
//                     });
//                     if (widget.onChanged != null) {
//                       widget.onChanged!(Duration(milliseconds: value.round()));
//                     }
//                   },
//                   onChangeEnd: (value) {
//                     if (widget.onChangeEnd != null) {
//                       widget.onChangeEnd!(Duration(milliseconds: value.round()));
//                     }
//                     _dragValue = null;
//                   },
//                 ),
//               ),

//               // Positioned(
//               //   right: 16.0,
//               //   bottom: 0.0,
//               //   child: Text(
//               //       RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//               //               .firstMatch("$_remaining")
//               //               ?.group(1) ??
//               //           '$_remaining',
//               //       style: TextStyle(color: AppColors.white)),
//               // ),
//               // Positioned(
//               //   left: 16.0,
//               //   bottom: 0.0,
//               //   child: Text(
//               //       RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//               //               .firstMatch("$_currentPossion")
//               //               ?.group(1) ??
//               //           '$_currentPossion',
//               //       style: TextStyle(color: AppColors.white)),
//               // ),
//             ],
//           ),
//           Text(
//             RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//                     .firstMatch("$_remaining")
//                     ?.group(1) ??
//                 '$_remaining',
//             style: TextStyle(color: AppColors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Duration get _remaining => widget.duration - widget.position;
//   Duration get _currentPossion => widget.position;
// }

// class HiddenThumbComponentShape extends SliderComponentShape {
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {}
// }

// class PositionData {
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;

//   PositionData(this.position, this.bufferedPosition, this.duration);
// }
