// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
// import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  final int index;
  final String type;
  Duration? duration;
  Duration? position;
  Duration? bufferedPosition;
  // ignore: prefer_typing_uninitialized_variables
  var positionStream;
  // ignore: prefer_typing_uninitialized_variables
  var bufferedPositionStream;
  // ignore: prefer_typing_uninitialized_variables
  var durationStream;
  AudioPlayer? audioPlayer;

  DetailScreen(
      {required this.index,
      required this.type,
      this.duration,
      this.position,
      this.bufferedPosition,
      this.positionStream,
      this.bufferedPositionStream,
      this.durationStream,
      this.audioPlayer,
      super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with WidgetsBindingObserver {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  ProfileController profileController = Get.put(ProfileController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  final TextEditingController playlistNameController = TextEditingController();

  GlobalKey<FormState> myKey4 = GlobalKey<FormState>();

  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool downloading = false;
  double downloadProgress = 0.0;
  bool isLoding = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    fetchData();
    _initAudioPlayer();
    log(detailScreenController.message.toString());
    fetchMyPlaylistData();
    cheackInMyPlaylistSongAvailable();
    downloadSongScreenController.downloadSongsList();
    audioPlayer.play();
    if (widget.position != null) {
      audioPlayer.seek(position);
    }
    widget.type == 'allSongs'
        ? allSongsScreenController.allSongsListModel != null
        : null;
    log(widget.type, name: 'type');
  }

  // String formatTime(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return [
  //     if (duration.inHours > 0) hours,
  //     minutes,
  //     seconds,
  //   ].join(':');
  // }

  void _initAudioPlayer() async {
    final url = widget.type == 'download song'
        ? downloadSongScreenController
            .allSongsListModel!.data![widget.index].audio
        : widget.type == 'playlist'
            ? playlistScreenController
                .allSongsListModel!.data![widget.index].audio
            : widget.type == 'allSongs'
                ? allSongsScreenController
                    .allSongsListModel!.data![widget.index].audio
                : homeScreenController
                    .categoryData.value.data![widget.index].audio;

    if (url != null) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      audioPlayer.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace stackTrace) {
        if (kDebugMode) {
          print('A stream error occurred: $e');
        }
      });
      // final localFilePath = widget.type == 'download song'
      //     ? '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![widget.index].id}.mp3'
      //     : widget.type == 'playlist'
      //         ? '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![widget.index].id}.mp3'
      //         : widget.type == 'allSongs'
      //             ? '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel!.data![widget.index].id}.mp3'
      //             : '${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3';

      // final file = File(localFilePath);

      // if (file.existsSync()) {
      //   try {
      //     // audioPlayer.dispose();
      //     log('locally playing.');
      //     detailScreenController.songExistsLocally.value = true;
      //     // await audioPlayer.setFilePath(localFilePath);
      //     MediaItem mediaItem = MediaItem(
      //       id: widget.type == 'download song'
      //           ? '${downloadSongScreenController.allSongsListModel!.data![widget.index].id}'
      //           : widget.type == 'playlist'
      //               ? '${playlistScreenController.allSongsListModel!.data![widget.index].id}'
      //               : widget.type == 'allSongs'
      //                   ? '${allSongsScreenController.allSongsListModel!.data![widget.index].id}'
      //                   : '${homeScreenController.categoryData.value.data![widget.index].id}',
      //       album: "Album name",
      //       title: widget.type == 'download song'
      //           ? "${downloadSongScreenController.allSongsListModel!.data![widget.index].title}"
      //           : widget.type == 'playlist'
      //               ? "${playlistScreenController.allSongsListModel!.data![widget.index].title}"
      //               : widget.type == 'allSongs'
      //                   ? '${allSongsScreenController.allSongsListModel!.data![widget.index].title}'
      //                   : "${homeScreenController.categoryData.value.data![widget.index].title}",
      //       artUri: widget.type == 'download song'
      //           ? Uri.parse(
      //               "${downloadSongScreenController.allSongsListModel!.data![widget.index].image}")
      //           : widget.type == 'playlist'
      //               ? Uri.parse(
      //                   "${playlistScreenController.allSongsListModel!.data![widget.index].image}")
      //               : widget.type == 'allSongs'
      //                   ? Uri.parse(
      //                       "${allSongsScreenController.allSongsListModel!.data![widget.index].image}")
      //                   : Uri.parse(
      //                       "${homeScreenController.categoryData.value.data![widget.index].image}"),
      //     );
      //     await audioPlayer.setAudioSource(
      //       AudioSource.uri(
      //         Uri.parse(localFilePath),
      //         tag: mediaItem,
      //       ),
      //     );
      //   } catch (e) {
      //     if (kDebugMode) {
      //       print("Error initializing audio player: $e");
      //     }
      //   }
      // } else {
      try {
        // audioPlayer.dispose();
        log('plying with internet.');
        MediaItem mediaItem = MediaItem(
          id: widget.type == 'download song'
              ? '${downloadSongScreenController.allSongsListModel!.data![widget.index].id}'
              : widget.type == 'playlist'
                  ? '${playlistScreenController.allSongsListModel!.data![widget.index].id}'
                  : widget.type == 'allSongs'
                      ? '${allSongsScreenController.allSongsListModel!.data![widget.index].id}'
                      : '${homeScreenController.categoryData.value.data![widget.index].id}',
          album: "Album name",
          title: widget.type == 'download song'
              ? "${downloadSongScreenController.allSongsListModel!.data![widget.index].title}"
              : widget.type == 'playlist'
                  ? "${playlistScreenController.allSongsListModel!.data![widget.index].title}"
                  : widget.type == 'allSongs'
                      ? '${allSongsScreenController.allSongsListModel!.data![widget.index].title}'
                      : "${homeScreenController.categoryData.value.data![widget.index].title}",
          artUri: widget.type == 'download song'
              ? Uri.parse(
                  "${downloadSongScreenController.allSongsListModel!.data![widget.index].image}")
              : widget.type == 'playlist'
                  ? Uri.parse(
                      "${playlistScreenController.allSongsListModel!.data![widget.index].image}")
                  : widget.type == 'allSongs'
                      ? Uri.parse(
                          "${allSongsScreenController.allSongsListModel!.data![widget.index].image}")
                      : Uri.parse(
                          "${homeScreenController.categoryData.value.data![widget.index].image}"),
        );
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
            tag: mediaItem,
          ),
        );

        if (widget.position != null) {
          audioPlayer.positionStream.listen((position) {
            setState(() {
              // if (mounted) {
              widget.position = position;
              // }
            });
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error initializing audio player: $e");
        }
      }
    }
    // }
  }

  final apiHelper = ApiHelper();

  bool isLoading = false;
  MyPlaylistDataModel? myPlaylistDataModel;
  MyPlaylistDataModel? myPlaylistDataModel1;

  Future<void> fetchMyPlaylistData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

      myPlaylistDataModel =
          MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading = false;
      }
    }
  }

  Future<void> cheackInMyPlaylistSongAvailable() async {
    setState(() {
      isLoading = true;
    });

    try {
      final myPlaylistDataModel1Json = await apiHelper
          .cheackInMyPlaylistSongAvailable(widget.type == 'download song'
              ? (downloadSongScreenController
                  .allSongsListModel!.data![widget.index].id)!
              : widget.type == 'playlist'
                  ? (playlistScreenController
                      .allSongsListModel!.data![widget.index].id)!
                  : widget.type == 'allSongs'
                      ? (allSongsScreenController
                          .allSongsListModel!.data![widget.index].id)!
                      : (homeScreenController
                              .categoryData.value.data![widget.index].id) ??
                          '');

      myPlaylistDataModel1 =
          MyPlaylistDataModel.fromJson(myPlaylistDataModel1Json);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    // (widget.audioPlayer) != null ?
    // (widget.audioPlayer)!.dispose() :
    // audioPlayer.dispose();
    super.dispose();
  }

  Future<void> downloadAudio() async {
    final url = widget.type == 'download song'
        ? downloadSongScreenController
            .allSongsListModel!.data![widget.index].audio
        : widget.type == 'playlist'
            ? playlistScreenController
                .allSongsListModel!.data![widget.index].audio
            : widget.type == 'allSongs'
                ? allSongsScreenController
                    .allSongsListModel!.data![widget.index].audio
                : homeScreenController
                    .categoryData.value.data![widget.index].audio;
    final id = widget.type == 'download song'
        ? downloadSongScreenController.allSongsListModel!.data![widget.index].id
        : widget.type == 'playlist'
            ? playlistScreenController.allSongsListModel!.data![widget.index].id
            : widget.type == 'allSongs'
                ? allSongsScreenController
                    .allSongsListModel!.data![widget.index].id
                : homeScreenController
                    .categoryData.value.data![widget.index].id;

    final directory = await getExternalStorageDirectory();

    if (directory != null) {
      final filePath = '${directory.path}/$id.mp3';
      log(filePath, name: 'file path audio');

      try {
        setState(() {
          downloading = true;
        });
        final dio = Dio();
        final response = await dio.download(
          url!,
          filePath,
          onReceiveProgress: (received, total) {
            setState(() {
              downloadProgress = received / total;
            });
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            downloading = false;
          });
          detailScreenController.addSongInDownloadlist(
              musicId: widget.type == 'download song'
                  ? downloadSongScreenController
                      .allSongsListModel!.data![widget.index].id
                  : widget.type == 'playlist'
                      ? playlistScreenController
                          .allSongsListModel!.data![widget.index].id
                      : widget.type == 'allSongs'
                          ? allSongsScreenController
                              .allSongsListModel!.data![widget.index].id
                          : homeScreenController
                              .categoryData.value.data![widget.index].id);
          detailScreenController.songExistsLocally.value = true;
          snackBar(AppStrings.audioDownloadSuccessfully);
        } else {
          setState(() {
            downloading = false;
          });
          snackBar('Failed to download audio');
        }
      } on DioException catch (_) {
        setState(() {
          downloading = false;
        });
        snackBar(AppStrings.internetNotAvailable);
      } catch (e) {
        setState(() {
          downloading = false;
        });
        if (kDebugMode) {
          print(e);
        }
        snackBar('Error :$e');
      }
    }
  }

  // bool isLoading = false;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final login = prefs.getBool('isLoggedIn') ?? '';
      if (kDebugMode) {
        print(login);
      }
      final categoryData1Json = login == false
          ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory1')
          : await apiHelper.fetchHomeCategoryData('category1');
      final categoryData2Json = login == false
          ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory2')
          : await apiHelper.fetchHomeCategoryData('category2');
      final categoryData3Json = login == false
          ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory3')
          : await apiHelper.fetchHomeCategoryData('category3');

      categoryData1 = CategoryData.fromJson(categoryData1Json);
      categoryData2 = CategoryData.fromJson(categoryData2Json);
      categoryData3 = CategoryData.fromJson(categoryData3Json);

      setState(() {
        if (mounted) {
          isLoading = false;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // final localFilePath = widget.type == 'download song'
    //     ? '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![widget.index].id}.mp3'
    //     : widget.type == 'playlist'
    //         ? '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![widget.index].id}.mp3'
    //         : widget.type == 'allSongs'
    //             ? '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel!.data![widget.index].id}.mp3'
    //             : '${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3';

    // final file = File(localFilePath);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: lable(
          text: AppStrings.nowPlaying,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          onPressed: () {
            (widget.audioPlayer) != null
                ? Get.back()
                : Get.offAll(MainScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 21,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: h * 0.03,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.type == 'download song'
                  ? downloadSongScreenController
                          .allSongsListModel!.data![widget.index].image ??
                      'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                  : widget.type == 'playlist'
                      ? playlistScreenController
                              .allSongsListModel!.data![widget.index].image ??
                          'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                      : widget.type == 'allSongs'
                          ? allSongsScreenController.allSongsListModel!
                                  .data![widget.index].image ??
                              'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                          : homeScreenController.categoryData.value
                                  .data![widget.index].image ??
                              'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
              height: h * 0.3,
              width: w,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
          SizedBox(
            height: h * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Align(
              alignment: Alignment.center,
              child: lable(
                  text: widget.type == 'download song'
                      ? (downloadSongScreenController
                          .allSongsListModel!.data![widget.index].title)!
                      : widget.type == 'playlist'
                          ? (playlistScreenController
                              .allSongsListModel!.data![widget.index].title)!
                          : widget.type == 'allSongs'
                              ? (allSongsScreenController.allSongsListModel!
                                  .data![widget.index].title)!
                              : homeScreenController.categoryData.value
                                      .data![widget.index].title ??
                                  AppStrings.noTitle,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            height: h * 0.01,
          ),
          // lable(text: AppStrings.unknown),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: lable(
                text: widget.type == 'download song'
                    ? (downloadSongScreenController
                        .allSongsListModel!.data![widget.index].description)!
                    : widget.type == 'playlist'
                        ? (playlistScreenController.allSongsListModel!
                            .data![widget.index].description)!
                        : widget.type == 'allSongs'
                            ? (allSongsScreenController.allSongsListModel!
                                .data![widget.index].description)!
                            : homeScreenController.categoryData.value
                                    .data![widget.index].description ??
                                AppStrings.unknown,
                maxLines: 2,
                textAlign: TextAlign.center),
          ),
          SizedBox(
            height: h * 0.055,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (categoryData1 == null ||
                        categoryData2 == null ||
                        categoryData3 == null)
                    ? Center(
                        child: SizedBox(
                          height: 15,
                          width: 14,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            detailScreenController.likedUnlikedSongs(
                                musicId: widget.type == 'download song'
                                    ? (downloadSongScreenController
                                        .allSongsListModel!
                                        .data![widget.index]
                                        .id)!
                                    : widget.type == 'playlist'
                                        ? (playlistScreenController
                                            .allSongsListModel!
                                            .data![widget.index]
                                            .id)!
                                        : widget.type == 'allSongs'
                                            ? (allSongsScreenController
                                                .allSongsListModel!
                                                .data![widget.index]
                                                .id)!
                                            : widget.type == 'home' &&
                                                    controller.category1AudioUrl
                                                        .isNotEmpty
                                                ? (categoryData1!
                                                    .data![widget.index].id)!
                                                : widget.type == 'home' &&
                                                        controller
                                                            .category2AudioUrl
                                                            .isNotEmpty
                                                    ? (categoryData2!
                                                        .data![widget.index]
                                                        .id)!
                                                    : widget.type == 'home' &&
                                                            controller
                                                                .category3AudioUrl
                                                                .isNotEmpty
                                                        ? (categoryData3!
                                                            .data![widget.index]
                                                            .id)!
                                                        //  (homeScreenController.categoryData
                                                        //     .value.data![widget.index].id)!
                                                        // : (homeScreenController.categoryData
                                                        //     .value.data![widget.index].id)!
                                                        // );
                                                        : (homeScreenController
                                                            .categoryData
                                                            .value
                                                            .data![widget.index]
                                                            .id)!);
                            downloadSongScreenController.downloadSongsList();
                            playlistScreenController.songsInPlaylist(
                                playlistId: '');
                            allSongsScreenController.allSongsList();
                            fetchData();
                          });
                        },
                        child: ((widget.type == 'download song')
                                ? downloadSongScreenController
                                            .allSongsListModel!
                                            .data![widget.index]
                                            .isLiked ==
                                        true
                                    ? downloadSongScreenController
                                        .allSongsListModel!
                                        .data![widget.index]
                                        .isLiked = true
                                    : downloadSongScreenController
                                        .allSongsListModel!
                                        .data![widget.index]
                                        .isLiked = false
                                : (widget.type == 'playlist')
                                    ? playlistScreenController
                                                .allSongsListModel!
                                                .data![widget.index]
                                                .isLiked ==
                                            true
                                        ? playlistScreenController
                                            .allSongsListModel!
                                            .data![widget.index]
                                            .isLiked = true
                                        : playlistScreenController
                                            .allSongsListModel!
                                            .data![widget.index]
                                            .isLiked = false
                                    : widget.type == 'allSongs'
                                        ? allSongsScreenController
                                                    .allSongsListModel!
                                                    .data![widget.index]
                                                    .isLiked ==
                                                true
                                            ? allSongsScreenController.allSongsListModel!.data![widget.index].isLiked = true
                                            : allSongsScreenController.allSongsListModel!.data![widget.index].isLiked = false
                                        : widget.type == 'home' && controller.category1AudioUrl.isNotEmpty
                                            ? categoryData1!.data![widget.index].isLiked == true
                                                ? categoryData1!.data![widget.index].isLiked = false
                                                : categoryData1!.data![widget.index].isLiked = true
                                            : widget.type == 'home' && controller.category2AudioUrl.isNotEmpty
                                                ? categoryData2!.data![widget.index].isLiked == true
                                                    ? categoryData2!.data![widget.index].isLiked = false
                                                    : categoryData2!.data![widget.index].isLiked = true
                                                : widget.type == 'home' && controller.category3AudioUrl.isNotEmpty
                                                    ? categoryData3!.data![widget.index].isLiked == true
                                                        ? categoryData3!.data![widget.index].isLiked = false
                                                        : categoryData3!.data![widget.index].isLiked = true

                                                    // ? homeScreenController.categoryData.value.data![widget.index].isLiked = true
                                                    : homeScreenController.categoryData.value.data![widget.index].isLiked = false)
                            ? AnimatedContainer(
                                duration: const Duration(milliseconds: 2000),
                                curve: Curves.fastEaseInToSlowEaseOut,
                                height: 55,
                                width: 55,
                                child: containerIcon(
                                    icon: Icons.favorite,
                                    iconColor: AppColors.white,
                                    containerColor: Colors.red.shade200),
                              )
                            : containerIcon(
                                icon: Icons.favorite,
                              ),
                      ),
                containerIcon(icon: Icons.shuffle),
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final login = prefs.getBool('isLoggedIn') ?? '';
                    if (login == true) {
                      if (kDebugMode) {
                        print(downloadProgress);
                      }
                      detailScreenController.songExistsLocally.value == true &&
                              (categoryData1 == null ||
                                  categoryData2 == null ||
                                  categoryData3 == null)
                          ? null
                          : downloadAudio();
                    } else {
                      noLoginBottomSheet();
                    }
                  },
                  child: downloading
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 56,
                              width: 56,
                              child: CircularProgressIndicator(
                                value: downloadProgress,
                                color: Colors.blue,
                              ),
                            ),
                            Positioned.fill(
                              child: containerIcon(icon: Icons.download),
                            ),
                            Positioned.fill(
                              bottom: 5,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: lable(
                                  text:
                                      '${(downloadProgress * 100).toStringAsFixed(0)}%',
                                  color: AppColors.backgroundColor,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        )
                      :
                      //  Obx(
                      //     () =>
                      // detailScreenController.songExistsLocally.value ==
                      //         true
                      categoryData1 == null ||
                              categoryData2 == null ||
                              categoryData3 == null
                          ? Center(
                              child: SizedBox(
                                height: 15,
                                width: 14,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : (widget.type == 'download song'
                                  ? controller.downloadSongsUrl.contains(
                                          '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![widget.index].id}.mp3') ==
                                      true
                                  : widget.type == 'playlist'
                                      ? controller.playlisSongAudioUrl.contains(
                                              '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![widget.index].id}.mp3') ==
                                          true
                                      : widget.type == 'allSongs'
                                          ? controller.allSongsUrl.contains(
                                                  '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel!.data![widget.index].id}.mp3') ==
                                              true
                                          : widget.type == 'home'
                                              ? controller.category1AudioUrl
                                                      .isNotEmpty
                                                  ? controller.category1AudioUrl
                                                          .contains(
                                                              '${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3') ==
                                                      true
                                                  : controller.category2AudioUrl
                                                          .isNotEmpty
                                                      ? controller
                                                              .category2AudioUrl
                                                              .contains('${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3') ==
                                                          true
                                                      : controller.category3AudioUrl.isNotEmpty
                                                          ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3') == true
                                                          : controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3') == true
                                              : controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3') == true)
                              ? containerIcon(icon: Icons.check, containerColor: Colors.green, iconColor: Colors.white)
                              : containerIcon(icon: Icons.download),
                  // ),
                ),
              ],
            ),
          ),
          sizeBoxHeight(10),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                isTrackTimeShow: true,
                duration: widget.duration != null
                    ? widget.duration!
                    : positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                // widget.position != null
                //     ? widget.position!
                //     : positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                //  widget.bufferedPosition != null
                //     ? widget.bufferedPosition!
                //     : positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  widget.audioPlayer != null
                      ? (widget.audioPlayer!).seek(newPosition)
                      : audioPlayer.seek(newPosition);
                },
                onChanged: (newPosition) {
                  audioPlayer.seek(newPosition);
                },
              );
            },
          ),
          sizeBoxHeight(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final login = prefs.getBool('isLoggedIn') ?? '';
                      if (login == true) {
                        // ignore: use_build_context_synchronously
                        addToPlaylist(context);
                      } else {
                        noLoginBottomSheet();
                      }
                    },
                    child: customIcon(
                      icon: Icons.playlist_add,
                    )),
                customIcon(icon: Icons.skip_previous),
                ControlButtons(widget.audioPlayer != null
                    ? (widget.audioPlayer!)
                    : audioPlayer),
                customIcon(icon: Icons.skip_next),
                customIcon(icon: Icons.volume_up),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
        ],
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.positionStream != null
            ? widget.positionStream!
            : audioPlayer.positionStream,
        widget.bufferedPositionStream != null
            ? widget.bufferedPositionStream!
            : audioPlayer.bufferedPositionStream,
        widget.durationStream != null
            ? widget.durationStream!
            : audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  addToPlaylist(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      builder: (context) {
        return myPlaylistDataModel == null || isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.white,
              ))
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(children: [
                  SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          width: double.infinity,
                          color: AppColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonIconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.backgroundColor,
                                ),
                                onPressed: () {
                                  Get.back();
                                  playlistNameController.text = '';
                                },
                              ),
                              lable(
                                text: AppStrings.addToPlaylist,
                                color: AppColors.backgroundColor,
                              ),
                            ],
                          ),
                        ),
                        isLoading || myPlaylistDataModel! == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              )
                            : SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: myPlaylistDataModel!.data!.length,
                                  itemBuilder: (context, index) {
                                    if (kDebugMode) {
                                      print(
                                          "${(myPlaylistDataModel!.data![index].inPlayList)!}");
                                    }
                                    return myPlaylistDataModel!
                                            .data![index].plTitle!.isEmpty
                                        ? SizedBox(
                                            height: 300,
                                            child: Row(
                                              children: [
                                                sizeBoxHeight(30),
                                                lable(
                                                    text: AppStrings
                                                        .emptyPlaylist,
                                                    color: Colors.white),
                                                Icon(
                                                  Icons.playlist_add,
                                                  color: AppColors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                sizeBoxHeight(20),
                                                InkWell(
                                                  onTap: () {
                                                    detailScreenController
                                                        .addSongInPlaylist(
                                                            playlistId:
                                                                (myPlaylistDataModel!
                                                                    .data![
                                                                        index]
                                                                    .id)!,
                                                            songsId: widget
                                                                        .type !=
                                                                    'home'
                                                                ? (playlistScreenController
                                                                    .allSongsListModel!
                                                                    .data![widget
                                                                        .index]
                                                                    .id)!
                                                                : (homeScreenController
                                                                    .categoryData
                                                                    .value
                                                                    .data![widget
                                                                        .index]
                                                                    .id)!)
                                                        .then((value) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      fetchMyPlaylistData();
                                                      cheackInMyPlaylistSongAvailable();

                                                      detailScreenController
                                                                  .success ==
                                                              "true"
                                                          ? snackBar(
                                                              '${AppStrings.songAddedInPlaylistSuccessfully} ${(myPlaylistDataModel!.data![index].plTitle)!}')
                                                          : snackBar(
                                                              (detailScreenController
                                                                  .message)!);
                                                    });
                                                  },
                                                  child: ListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                        horizontal: 0,
                                                        vertical: -4,
                                                      ),
                                                      leading: Icon(
                                                        Icons.music_note,
                                                        color: AppColors.white,
                                                      ),
                                                      title: lable(
                                                          text:
                                                              (myPlaylistDataModel!
                                                                  .data![index]
                                                                  .plTitle)!),
                                                      subtitle: lable(
                                                        text:
                                                            "${(myPlaylistDataModel!.data![index].tracks)!} • ${AppStrings.tracks}",
                                                      ),
                                                      trailing:
                                                          (myPlaylistDataModel1!
                                                                      .data![
                                                                          index]
                                                                      .inPlayList)! ==
                                                                  true
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                )
                                                              : null),
                                                ),
                                              ],
                                            ),
                                          );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  myPlaylistDataModel!.data!.isEmpty &&
                          myPlaylistDataModel!.data != null
                      ? Positioned.fill(
                          bottom: 10,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                lable(text: AppStrings.emptyPlaylist),
                                Icon(
                                  Icons.playlist_add,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Positioned.fill(
                    bottom: 25,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: () {
                          Get.back();
                          createPlaylist();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(color: AppColors.white),
                          child: Row(
                            children: [
                              commonIconButton(
                                icon: const Icon(Icons.add),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              lable(
                                  text: AppStrings.createPlaylist,
                                  color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              );
      },
    );
  }

  createPlaylist() {
    return showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: AlertDialog(
                  backgroundColor: AppColors.backgroundColor,
                  title: lable(
                      text: AppStrings.addPlaylistName,
                      fontWeight: FontWeight.w600),
                  content: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: myKey4,
                      child: Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                style: TextStyle(color: AppColors.white),
                                controller: playlistNameController,
                                validator: (value) =>
                                    AppValidation.validateName(value!),
                                decoration: InputDecoration(
                                  hintText: AppStrings.enterPlaylistName,
                                  hintStyle: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (myKey4.currentState!.validate()) {
                                    snackBar(
                                        '${playlistNameController.text} ${AppStrings.added}');
                                    detailScreenController
                                        .addPlaylist(
                                            playlistTitle:
                                                playlistNameController.text)
                                        .then((value) {
                                      fetchMyPlaylistData();
                                      FocusScope.of(context).unfocus();
                                      Get.offAll(DetailScreen(
                                        index: 0,
                                        type: '',
                                      ));
                                    });
                                    playlistNameController.text = '';
                                  } else {
                                    snackBar(AppStrings.enterPlaylistName);
                                  }
                                },
                                child: lable(
                                    text: AppStrings.addToPlaylist,
                                    color: AppColors.backgroundColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  noLoginBottomSheet() {
    // ignore: deprecated_member_use, unused_field
    return showModalBottomSheet(
        backgroundColor: const Color(0xFF2a2d36),
        context: context,
        builder: (context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sizeBoxHeight(60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: lable(
                    text: AppStrings.signUpOrLogin,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                sizeBoxHeight(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: lable(
                    text: AppStrings.pleaseLoginToUseThisFeature,
                  ),
                ),
                sizeBoxHeight(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: InkWell(
                    onTap: () {
                      Get.offAll(const MobileLoginScreen(),
                          transition: Transition.downToUp);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF43464d),
                          ),
                          child: CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              setState(() {});
                            },
                            initialSelection: 'IN',
                            textStyle:
                                const TextStyle(color: Color(0xFF8e8e94)),
                            showCountryOnly: false,
                            showFlag: false,
                            showOnlyCountryWhenClosed: false,
                            dialogTextStyle:
                                const TextStyle(color: Colors.grey),
                            dialogBackgroundColor:
                                AppColors.backgroundColor.withOpacity(0.9),
                            barrierColor: Colors.transparent,
                            alignLeft: false,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF4c4f56),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                // controller: phoneNumber,
                                enabled: false,
                                autofocus: false,
                                validator: (value) =>
                                    AppValidation.validatePhone(value!),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade400),
                                cursorColor: Colors.grey.shade400,
                                decoration: const InputDecoration(
                                  hintText: AppStrings.continueWithMobileNumber,
                                  errorText: null,
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                sizeBoxHeight(50),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 3,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    lable(
                      text: '  Or  ',
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                        child: Divider(
                      height: 3,
                      color: Colors.grey.shade600,
                    )),
                  ],
                ),
                sizeBoxHeight(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    containerIcon(
                      onTap: () {
                        googleSignIn();
                      },
                      image: Image.asset(
                        AppAsstes.google,
                        height: 30,
                      ),
                      border: Border.all(color: Colors.orange),
                      containerColor: AppColors.backgroundColor,
                      iconColor: AppColors.white,
                      height: 50,
                      width: 50,
                    ),
                    containerIcon(
                      onTap: () {
                        Get.offAll(const LogInScreen(),
                            transition: Transition.downToUp);
                      },
                      icon: Icons.mail_outline_outlined,
                      border: Border.all(color: Colors.white),
                      containerColor: AppColors.backgroundColor,
                      iconColor: AppColors.white,
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
                sizeBoxHeight(30),
              ],
            ),
          );
        });
  }

  googleSignIn() async {
    setState(() {
      isLoding = true;
    });
    if (kDebugMode) {
      print("googleLogin method Called");
    }
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var reslut = await googleSignIn.signIn();
      if (reslut == null) {
        setState(() {
          isLoding = false;
        });
        return;
      } else {
        Get.offAll(MainScreen());
        setState(() {
          isLoding = false;
        });
        snackBar('Login Succesfully');
      }
    } catch (error) {
      setState(() {
        isLoding = false;
      });
      if (kDebugMode) {
        print(error);
      }
    }
  }
}