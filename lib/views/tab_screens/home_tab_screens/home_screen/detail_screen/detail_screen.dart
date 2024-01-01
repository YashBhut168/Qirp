// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
// import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/album_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/artist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/search_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/without_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/queue_screen/queue_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  final int index;
  final String type;
  // Duration? duration;
  // Duration? position;
  // Duration? bufferedPosition;
  // // ignore: prefer_typing_uninitialized_variables
  // var positionStream;
  // // ignore: prefer_typing_uninitialized_variables
  // var bufferedPositionStream;
  // // ignore: prefer_typing_uninitialized_variables
  // var durationStream;
  AudioPlayer? audioPlayer;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;
  DetailScreen(
      {required this.index,
      required this.type,
      // this.duration,
      // this.position,
      // this.bufferedPosition,
      // this.positionStream,
      // this.bufferedPositionStream,
      // this.durationStream,
      this.audioPlayer,
      this.categoryData1,
      this.categoryData2,
      this.categoryData3,
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
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());
  SearchScreenController searchScreenController =
      Get.put(SearchScreenController());

  final TextEditingController playlistNameController = TextEditingController();

  GlobalKey<FormState> myKey4 = GlobalKey<FormState>();

  late AudioPlayer audioPlayer = AudioPlayer();

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
    log(detailScreenController.message.toString());
    fetchMyPlaylistData();
    cheackInMyPlaylistSongAvailable();
    downloadSongScreenController.downloadSongsList();
    audioPlayer.play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (allSongsScreenController.allSongsListModel!.data != null) {
        allSongsScreenController.filteredAllSongsTitles = List.generate(
          allSongsScreenController.allSongsListModel!.data!.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].title) ??
              '',
        );
        allSongsScreenController.filteredAllSongsIds = List.generate(
          allSongsScreenController.allSongsListModel!.data!.length,
          (index) =>
              (allSongsScreenController.allSongsListModel!.data![index].id) ??
              '',
        );
        allSongsScreenController.filteredAllSongsAudios = List.generate(
          allSongsScreenController.allSongsListModel!.data!.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].audio) ??
              '',
        );
        allSongsScreenController.filteredAllSongsDesc = List.generate(
          allSongsScreenController.allSongsListModel!.data!.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].description) ??
              '',
        );
        allSongsScreenController.filteredAllSongsLikes = List.generate(
          allSongsScreenController.isLikeAllSongData.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].isLiked) ??
              false,
        );
        allSongsScreenController.filteredAllSongsQueues = List.generate(
          allSongsScreenController.isLikeAllSongData.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].is_queue) ??
              false,
        );
        allSongsScreenController.filteredAllSongsImage = List.generate(
          allSongsScreenController.allSongsListModel!.data!.length,
          (index) =>
              (allSongsScreenController
                  .allSongsListModel!.data![index].image) ??
              '',
        );
      } else {
        allSongsScreenController.filteredAllSongsTitles = [];
      }
    });

    // if (widget.position != null) {
    //   audioPlayer.seek(position);
    // }
    widget.type == 'allSongs'
        ? allSongsScreenController.allSongsListModel != null
        : null;
    log(widget.type, name: 'type');
  }

  // ignore: unused_element
  void _initAudioPlayer() async {
    final url = widget.type == 'admin playlist'
        ? playlistScreenController.adminPlaylistSongModel!.data![widget.index].audio
        : widget.type == 'album song'
        ? albumScreenController.allSongsListModel!.data![widget.index].audio
        : widget.type == 'artist song'
            ? artistScreenController.currentPlayingAudio.value
            : widget.type == 'favorite song'
                ? favoriteSongScreenController
                    .allSongsListModel!.data![widget.index].audio
                : widget.type == 'queue song'
                    ? queueSongsScreenController
                        .allSongsListModel!.data![widget.index].audio
                    : widget.type == 'download song'
                        ? downloadSongScreenController
                            .allSongsListModel!.data![widget.index].audio
                        : widget.type == 'search'
                            ? searchScreenController
                                .allSearchModel!.data![widget.index].audio
                            : widget.type == 'playlist'
                                ? playlistScreenController.allSongsListModel!
                                    .data![widget.index].audio
                                : widget.type == 'allSongs'
                                    ? allSongsScreenController
                                        .allSongsListModel!
                                        .data![widget.index]
                                        .audio
                                    : widget.type == 'home cat song'
                                        ? homeScreenController
                                            .homeCategoryData[controller
                                                .currentListTileIndexCategory
                                                .value]
                                            .categoryData[widget.index]
                                            .audio
                                        : homeScreenController.categoryData
                                            .value.data![widget.index].audio;

    if (url != null) {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      audioPlayer.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace stackTrace) {
        if (kDebugMode) {
          print('A stream error occurred: $e');
        }
      });

      try {
        log('plying with internet.');
        MediaItem mediaItem = MediaItem(
          id: widget.type == 'admin playlist'
              ? '${playlistScreenController.adminPlaylistSongModel!.data![widget.index].id}'
              : widget.type == 'album song'
              ? '${albumScreenController.allSongsListModel!.data![widget.index].id}'
              : widget.type == 'artist song'
                  ? artistScreenController.currentPlayingId.value
                  : widget.type == 'favorite song'
                      ? '${favoriteSongScreenController.allSongsListModel!.data![widget.index].id}'
                      : widget.type == 'queue song'
                          ? '${queueSongsScreenController.allSongsListModel!.data![widget.index].id}'
                          : widget.type == 'download song'
                              ? '${downloadSongScreenController.allSongsListModel!.data![widget.index].id}'
                              : widget.type == 'search'
                                  ? '${searchScreenController.allSearchModel!.data![widget.index].id}'
                                  : widget.type == 'playlist'
                                      ? '${playlistScreenController.allSongsListModel!.data![widget.index].id}'
                                      : widget.type == 'allSongs'
                                          ? '${allSongsScreenController.allSongsListModel!.data![widget.index].id}'
                                          : '${homeScreenController.categoryData.value.data![widget.index].id}',
          album: "Album name",
          title: widget.type == 'admin playlist'
              ? '${playlistScreenController.adminPlaylistSongModel!.data![widget.index].title}'
              : widget.type == 'album song'
              ? '${albumScreenController.allSongsListModel!.data![widget.index].title}'
              : widget.type == 'artist song'
                  ? artistScreenController.currentPlayingTitle.value
                  : widget.type == 'favorite song'
                      ? "${favoriteSongScreenController.allSongsListModel!.data![widget.index].title}"
                      : widget.type == 'queue song'
                          ? "${queueSongsScreenController.allSongsListModel!.data![widget.index].title}"
                          : widget.type == 'download song'
                              ? "${downloadSongScreenController.allSongsListModel!.data![widget.index].title}"
                              : widget.type == 'search'
                                  ? '${searchScreenController.allSearchModel!.data![widget.index].title}'
                                  : widget.type == 'playlist'
                                      ? "${playlistScreenController.allSongsListModel!.data![widget.index].title}"
                                      : widget.type == 'allSongs'
                                          ? '${allSongsScreenController.allSongsListModel!.data![widget.index].title}'
                                          : "${homeScreenController.categoryData.value.data![widget.index].title}",
          artUri: widget.type == 'admin playlist'
              ? Uri.parse(
                  "${playlistScreenController.adminPlaylistSongModel!.data![widget.index].image}")
              : widget.type == 'album song'
              ? Uri.parse(
                  "${albumScreenController.allSongsListModel!.data![widget.index].image}")
              : widget.type == 'artist song'
                  ? Uri.parse(artistScreenController.currentPlayingImage.value)
                  : widget.type == 'queue song'
                      ? Uri.parse(
                          "${queueSongsScreenController.allSongsListModel!.data![widget.index].image}")
                      : widget.type == 'download song'
                          ? Uri.parse(
                              "${downloadSongScreenController.allSongsListModel!.data![widget.index].image}")
                          : widget.type == 'search'
                              ? Uri.parse(
                                  "${searchScreenController.allSearchModel!.data![widget.index].image}")
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

        // if (widget.position != null) {
        //   audioPlayer.positionStream.listen((position) {
        //     // setState(() {
        //     //   if (mounted) {
        //     widget.position = position;
        //     //   }
        //     // });
        //   });
        // }
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
          .cheackInMyPlaylistSongAvailable(widget.type == 'admin playlist'
              ? (playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id)!
              : widget.type == 'album song'
              ? (albumScreenController
                  .allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id)!
              : widget.type == 'artist song'
                  ? (artistScreenController.currentPlayingId.value)
                  : widget.type == 'favorite song'
                      ? (favoriteSongScreenController
                          .allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id)!
                      : widget.type == 'queue song'
                          ? (queueSongsScreenController
                              .allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id)!
                          : widget.type == 'download song'
                              ? (downloadSongScreenController
                                  .allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id)!
                              : widget.type == 'search'
                                  ? (searchScreenController
                                      .allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].id)!
                                  : widget.type == 'playlist'
                                      ? (playlistScreenController
                                          .allSongsListModel!
                                          .data![controller.currentListTileIndex.value]
                                          .id)!
                                      : widget.type == 'allSongs'
                                          ? (allSongsScreenController
                                              .allSongsListModel!
                                              .data![controller.currentListTileIndexAllSongs.value]
                                              .id)!
                                          : widget.type == 'home cat song'
                                              ? (homeScreenController
                                                  .homeCategoryData[controller
                                                      .currentListTileIndexCategory
                                                      .value]
                                                  .categoryData[controller.currentListTileIndexCategoryData.value]
                                                  .id)!
                                              : (homeScreenController
                                                      .categoryData
                                                      .value
                                                      .data![widget.index]
                                                      .id) ??
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
    super.dispose();
  }

  Future<void> downloadAudio() async {
    final url = widget.type == 'admin playlist'
        ? (playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].audio)!
        : widget.type == 'album song'
        ? (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].audio)!
        : widget.type == 'artist song'
            ? (artistScreenController.currentPlayingAudio.value)
            : widget.type == 'favorite song'
                ? favoriteSongScreenController
                    .allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].audio
                : widget.type == 'queue song'
                    ? queueSongsScreenController
                        .allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].audio
                    : widget.type == 'download song'
                        ? downloadSongScreenController
                            .allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].audio
                        : widget.type == 'search'
                            ? searchScreenController
                                .allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].audio
                            : widget.type == 'playlist'
                                ? playlistScreenController.allSongsListModel!
                                    .data![controller.currentListTileIndex.value].audio
                                : widget.type == 'allSongs'
                                    ? allSongsScreenController
                                        .filteredAllSongsAudios[controller.currentListTileIndexAllSongs.value]
                                    : widget.type == 'home cat song'
                                        ? homeScreenController
                                            .homeCategoryModel!
                                            .data![controller
                                                .currentListTileIndexCategory
                                                .value]
                                            .categoryData![controller.currentListTileIndexCategoryData.value]
                                            .audio
                                        : widget.type == 'home' &&
                                                controller.category1AudioUrl
                                                    .isNotEmpty
                                            ? (categoryData1!
                                                .data![widget.index].audio)
                                            : widget.type == 'home' &&
                                                    controller.category2AudioUrl
                                                        .isNotEmpty
                                                ? (categoryData2!
                                                    .data![widget.index].audio)
                                                : widget.type == 'home' &&
                                                        controller
                                                            .category3AudioUrl
                                                            .isNotEmpty
                                                    ? (categoryData3!
                                                        .data![widget.index]
                                                        .audio)
                                                    : null;
    // homeScreenController
    // .categoryData.value.data![widget.index].audio;
    final id = widget.type == 'admin playlist'
        ? (playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id)!
        : widget.type == 'album song'
        ? (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id)!
        : widget.type == 'artist song'
            ? (artistScreenController.currentPlayingId.value)
            : widget.type == 'favorite song'
                ? favoriteSongScreenController
                    .allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id
                : widget.type == 'queue song'
                    ? queueSongsScreenController
                        .allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id
                    : widget.type == 'download song'
                        ? downloadSongScreenController
                            .allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id
                        : widget.type == 'search'
                            ? searchScreenController
                                .allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].id
                            : widget.type == 'playlist'
                                ? playlistScreenController
                                    .allSongsListModel!.data![controller.currentListTileIndex.value].id
                                : widget.type == 'allSongs'
                                    ? allSongsScreenController
                                        .filteredAllSongsIds[controller.currentListTileIndexAllSongs.value]
                                    : widget.type == 'home cat song'
                                        ? homeScreenController
                                            .homeCategoryModel!
                                            .data![controller
                                                .currentListTileIndexCategory
                                                .value]
                                            .categoryData![controller.currentListTileIndexCategoryData.value]
                                            .id
                                        : widget.type == 'home' &&
                                                controller.category1AudioUrl
                                                    .isNotEmpty
                                            ? (categoryData1!
                                                .data![widget.index].id)
                                            : widget.type == 'home' &&
                                                    controller.category2AudioUrl
                                                        .isNotEmpty
                                                ? (categoryData2!
                                                    .data![widget.index].id)
                                                : widget.type == 'home' &&
                                                        controller
                                                            .category3AudioUrl
                                                            .isNotEmpty
                                                    ? (categoryData3!
                                                        .data![widget.index].id)
                                                    : null;

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
            if (mounted) {
              setState(() {
                downloadProgress = received / total;
              });
            }
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            downloading = false;
          });
          detailScreenController.addSongInDownloadlist(
              musicId: widget.type == 'admin playlist'
                  ? (playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id)!
                  : widget.type == 'album song'
                  ? (albumScreenController
                      .allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id)!
                  : widget.type == 'artist song'
                      ? (artistScreenController.currentPlayingId.value)
                      : widget.type == 'favorite song'
                          ? favoriteSongScreenController
                              .allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id
                          : widget.type == 'queue song'
                              ? queueSongsScreenController
                                  .allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id
                              : widget.type == 'download song'
                                  ? downloadSongScreenController
                                      .allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id
                                  : widget.type == 'search'
                                      ? searchScreenController.allSearchModel!
                                          .data![controller.currentListTileIndexSearchSongs.value].id
                                      : widget.type == 'playlist'
                                          ? playlistScreenController
                                              .allSongsListModel!
                                              .data![controller.currentListTileIndex.value]
                                              .id
                                          : widget.type == 'allSongs'
                                              ? allSongsScreenController
                                                      .filteredAllSongsIds[
                                                  controller.currentListTileIndexAllSongs.value]
                                              : widget.type == 'home cat song'
                                                  ? homeScreenController
                                                      .homeCategoryModel!
                                                      .data![controller
                                                          .currentListTileIndexCategory
                                                          .value]
                                                      .categoryData![controller.currentListTileIndexCategoryData.value]
                                                      .id
                                                  : homeScreenController
                                                      .categoryData
                                                      .value
                                                      .data![widget.index]
                                                      .id);
          widget.type == 'home cat song' &&
                  controller.isMiniPlayerOpenHome.value == true
              ? controller.categoryAudioUrl[controller.currentListTileIndexCategoryData.value] =
                  '${AppStrings.localPathMusic}/${homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].id}.mp3'
              : widget.type == 'home' &&
                      controller.isMiniPlayerOpenHome1.value == true
                  ? controller.category1AudioUrl[widget.index] =
                      '${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3'
                  : widget.type == 'home' &&
                          controller.isMiniPlayerOpenHome2.value == true
                      ? controller.category2AudioUrl[widget.index] =
                          '${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3'
                      : widget.type == 'home' &&
                              controller.isMiniPlayerOpenHome3.value == true
                          ? controller.category3AudioUrl[widget.index] =
                              '${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3'
                          // : null;
                          : widget.type == 'playlist' &&
                                  controller.isMiniPlayerOpen.value == true
                              ? controller.playlisSongAudioUrl[controller.currentListTileIndex.value] =
                                  '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].id}.mp3'
                              : widget.type == 'allSongs' &&
                                      controller.isMiniPlayerOpenAllSongs.value ==
                                          true
                                  ? controller.allSongsUrl[controller.currentListTileIndexAllSongs.value] =
                                      '${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[controller.currentListTileIndexAllSongs.value]}.mp3'
                                  : widget.type == 'album song' &&
                                          controller.isMiniPlayerOpenAlbumSongs.value ==
                                              true
                                      ? controller.albumSongsUrl[controller.currentListTileIndexAlbumSongs.value] =
                                          '${AppStrings.localPathMusic}/${albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id}.mp3'
                                      : widget.type == 'admin playlist' &&
                                          controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                              true
                                      ? controller.adminPlaylistSongsUrl[controller.currentListTileIndexAdminPlaylistSongs.value] =
                                          '${AppStrings.localPathMusic}/${playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id}.mp3'
                                      : widget.type == 'artist song' &&
                                              controller.isMiniPlayerOpenArtistSongs.value ==
                                                  true
                                          ? controller.artistSongsUrl[controller.currentListTileIndexArtistSongs.value] =
                                              '${AppStrings.localPathMusic}/${artistScreenController.currentPlayingId.value}.mp3'
                                          : widget.type == 'download song' &&
                                                  controller.isMiniPlayerOpenDownloadSongs.value ==
                                                      true
                                              ? controller.downloadSongsUrl[controller.currentListTileIndexDownloadSongs.value] =
                                                  '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id}.mp3'
                                              : widget.type == 'favorite song' &&
                                                  controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                      true
                                              ? controller.favoriteSongsUrl[controller.currentListTileIndexFavoriteSongs.value] =
                                                  '${AppStrings.localPathMusic}/${favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id}.mp3'
                                              : widget.type == 'search' &&
                                                      controller
                                                              .isMiniPlayerOpenSearchSongs
                                                              .value ==
                                                          true
                                                  ? controller.searchSongsUrl[controller.currentListTileIndexSearchSongs.value] =
                                                      '${AppStrings.localPathMusic}/${searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].id}.mp3'
                                                  : widget.type == 'queue song' &&
                                                          controller.isMiniPlayerOpenQueueSongs.value == true
                                                      ? controller.queueSongsUrl[controller.currentListTileIndexQueueSongs.value] = '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id}.mp3'
                                                      : widget.type == 'queue song' && controller.isMiniPlayerOpenQueueSongs.value == true
                                                          ? controller.favoriteSongsUrl[widget.index] = '${AppStrings.localPathMusic}/${favoriteSongScreenController.allSongsListModel!.data![widget.index].id}.mp3'
                                                          : '';
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

  var isLikeHomeData1 = [].obs;
  var isLikeHomeData2 = [].obs;
  var isLikeHomeData3 = [].obs;
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
        isLikeHomeData1.value = categoryData1!.data!;
        isLikeHomeData2.value = categoryData2!.data!;
        isLikeHomeData3.value = categoryData3!.data!;
      });

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
      body:
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h * 0.03,
            ),
            Obx(
              () => ClipRRect(
                // borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.type == 'home cat song'
                      ? homeScreenController
                              .homeCategoryData[
                                  controller.currentListTileIndexCategory.value]
                              .categoryData[controller
                                  .currentListTileIndexCategoryData.value]
                              .image ??
                          'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                      : widget.type == 'favorite song'
                          ? favoriteSongScreenController
                                  .allSongsListModel!
                                  .data![controller
                                      .currentListTileIndexFavoriteSongs.value]
                                  .image ??
                              'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                          : widget.type == 'admin playlist'
                          ? playlistScreenController.adminPlaylistSongModel!
                                  .data![controller
                                      .currentListTileIndexAdminPlaylistSongs.value]
                                  .image ??
                              'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                          : widget.type == 'queue song'
                              ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ??
                                  'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                              : widget.type == 'download song'
                                  ? downloadSongScreenController
                                          .allSongsListModel!
                                          .data![controller
                                              .currentListTileIndexDownloadSongs
                                              .value]
                                          .image ??
                                      'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                  : widget.type == 'search'
                                      ? searchScreenController
                                          .allSearchModel!
                                          .data![controller.currentListTileIndexSearchSongs.value]
                                          .image!
                                      : widget.type == 'playlist'
                                          ? playlistScreenController.currentPlayingImage.value
                                          //     ??
                                          // 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                          : widget.type == 'artist song'
                                              ? artistScreenController.currentPlayingImage.value
                                              : widget.type == 'album song'
                                                  ? albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].image
                                                  : widget.type == 'allSongs'
                                                      ? allSongsScreenController.filteredAllSongsImage[controller.currentListTileIndexAllSongs.value]
                                                      : homeScreenController.categoryData.value.data![widget.index].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                  height: h * 0.3,
                  width: w * 0.75,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.035,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.5,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => lable(
                              text: widget.type == 'home cat song'
                                  ? (homeScreenController
                                      .homeCategoryData[controller
                                          .currentListTileIndexCategory.value]
                                      .categoryData[controller
                                          .currentListTileIndexCategoryData
                                          .value]
                                      .title)!
                                  : widget.type == 'album song'
                                      ? (albumScreenController
                                          .allSongsListModel!
                                          .data![controller
                                              .currentListTileIndexAlbumSongs
                                              .value]
                                          .title)!
                                      : widget.type == 'admin playlist'
                                      ? (playlistScreenController.adminPlaylistSongModel!
                                          .data![controller
                                              .currentListTileIndexAdminPlaylistSongs
                                              .value]
                                          .title)!
                                      : widget.type == 'artist song'
                                          ? artistScreenController
                                              .currentPlayingTitle.value
                                          : widget.type == 'favorite song'
                                              ? (favoriteSongScreenController
                                                  .allSongsListModel!
                                                  .data![controller
                                                      .currentListTileIndexFavoriteSongs
                                                      .value]
                                                  .title)!
                                              : widget.type == 'queue song'
                                                  ? (queueSongsScreenController
                                                      .allSongsListModel!
                                                      .data![controller
                                                          .currentListTileIndexQueueSongs
                                                          .value]
                                                      .title)!
                                                  : widget.type ==
                                                          'download song'
                                                      ? (downloadSongScreenController
                                                          .allSongsListModel!
                                                          .data![controller
                                                              .currentListTileIndexDownloadSongs
                                                              .value]
                                                          .title)!
                                                      : widget.type == 'search'
                                                          ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title)!
                                                          : widget.type == 'playlist'
                                                              ? playlistScreenController.currentPlayingTitle.value
                                                              // (playlistScreenController
                                                              //     .allSongsListModel!
                                                              //     .data![widget
                                                              //         .index]
                                                              //     .title)!
                                                              : widget.type == 'allSongs'
                                                                  ? (allSongsScreenController.filteredAllSongsTitles[controller.currentListTileIndexAllSongs.value])
                                                                  : homeScreenController.categoryData.value.data![widget.index].title ?? AppStrings.noTitle,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.005,
                      ),
                      // lable(text: AppStrings.unknown),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => lable(
                              text: widget.type == 'home cat song'
                                  ? (homeScreenController
                                      .homeCategoryData[controller
                                          .currentListTileIndexCategory.value]
                                      .categoryData[controller
                                          .currentListTileIndexCategoryData
                                          .value]
                                      .description)!
                                  : widget.type == 'album song'
                                      ? (albumScreenController
                                          .allSongsListModel!
                                          .data![controller
                                              .currentListTileIndexAlbumSongs
                                              .value]
                                          .description)!
                                      : widget.type == 'admin playlist'
                                      ? (playlistScreenController.adminPlaylistSongModel!
                                          .data![controller
                                              .currentListTileIndexAdminPlaylistSongs
                                              .value]
                                          .description)!
                                      : widget.type == 'artist song'
                                          ? artistScreenController
                                              .currentPlayingDesc.value
                                          : widget.type == 'favorite song'
                                              ? (favoriteSongScreenController
                                                  .allSongsListModel!
                                                  .data![controller
                                                      .currentListTileIndexFavoriteSongs
                                                      .value]
                                                  .description)!
                                              : widget.type == 'queue song'
                                                  ? (queueSongsScreenController
                                                      .allSongsListModel!
                                                      .data![controller
                                                          .currentListTileIndexQueueSongs
                                                          .value]
                                                      .description)!
                                                  : widget.type ==
                                                          'download song'
                                                      ? (downloadSongScreenController
                                                          .allSongsListModel!
                                                          .data![controller
                                                              .currentListTileIndexDownloadSongs
                                                              .value]
                                                          .description)!
                                                      : widget.type == 'search'
                                                          ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].description)!
                                                          : widget.type == 'playlist'
                                                              ? playlistScreenController.currentPlayingDesc.value
                                                              // (playlistScreenController
                                                              //     .allSongsListModel!
                                                              //     .data![widget
                                                              //         .index]
                                                              //     .description)!
                                                              : widget.type == 'allSongs'
                                                                  ? (allSongsScreenController.filteredAllSongsDesc[controller.currentListTileIndexAllSongs.value])
                                                                  : homeScreenController.categoryData.value.data![widget.index].description ?? AppStrings.unknown,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (GlobVar.login == true) {
                                  widget.type == 'favorite song'
                                      ? null
                                      // (favoriteSongScreenController
                                      //             .allSongsListModel!
                                      //             .data![widget.index]
                                      //             .isLiked)! ==
                                      //         true
                                      //     ? favoriteSongScreenController
                                      //         .allSongsListModel!
                                      //         .data![widget.index]
                                      //         .isLiked = false
                                      //     : favoriteSongScreenController
                                      //         .allSongsListModel!
                                      //         .data![widget.index]
                                      //         .isLiked = true
                                      : widget.type == 'home cat song'
                                          ? (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].isLiked)! ==
                                                  true
                                              ? homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].isLiked =
                                                  false
                                              : homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].isLiked =
                                                  true
                                          : widget.type == 'album song'
                                              ? (albumScreenController
                                                          .allSongsListModel!
                                                          .data![controller.currentListTileIndexAlbumSongs.value]
                                                          .isLiked)! ==
                                                      true
                                                  ? albumScreenController
                                                      .allSongsListModel!
                                                      .data![controller.currentListTileIndexAlbumSongs.value]
                                                      .isLiked = false
                                                  : albumScreenController
                                                      .allSongsListModel!
                                                      .data![controller.currentListTileIndexAlbumSongs.value]
                                                      .isLiked = true
                                              : widget.type == 'artist song'
                                                  ? (artistScreenController
                                                              .currentPlayingIsLiked
                                                              .value) ==
                                                          true
                                                      ? artistScreenController
                                                          .allSongsListModel!
                                                          .data![controller.currentListTileIndexArtistSongs.value]
                                                          .isLiked = false
                                                      : artistScreenController
                                                          .allSongsListModel!
                                                          .data![controller.currentListTileIndexArtistSongs.value]
                                                          .isLiked = true
                                                  : widget.type == 'queue song'
                                                      ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].isLiked)! == true
                                                          ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].isLiked = false
                                                          : queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].isLiked = true
                                                      : widget.type == 'download song'
                                                          ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].isLiked)! == true
                                                              ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].isLiked = false
                                                              : downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].isLiked = true
                                                          : widget.type == 'admin playlist'
                                                          ? (playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].isLiked)! == true
                                                              ? playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].isLiked = false
                                                              : playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].isLiked = true
                                                          : widget.type == 'search'
                                                              ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].isLiked)! == true
                                                                  ? searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].isLiked = false
                                                                  : searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].isLiked = true
                                                              : widget.type == 'playlist'
                                                                  ? (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].isLiked)! == true
                                                                      ? playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].isLiked = false
                                                                      : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].isLiked = true
                                                                  : widget.type == 'allSongs'
                                                                      ? (allSongsScreenController.filteredAllSongsLikes[controller.currentListTileIndexAllSongs.value]) == true
                                                                          ? allSongsScreenController.filteredAllSongsLikes[controller.currentListTileIndexAllSongs.value] = false
                                                                          : allSongsScreenController.filteredAllSongsLikes[controller.currentListTileIndexAllSongs.value] = true
                                                                      : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true
                                                                          ? (isLikeHomeData1[widget.index].isLiked == true)
                                                                              ? isLikeHomeData1[widget.index].isLiked = false
                                                                              : isLikeHomeData1[widget.index].isLiked = true
                                                                          : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                              ? (isLikeHomeData2[widget.index].isLiked == true)
                                                                                  ? isLikeHomeData2[widget.index].isLiked = false
                                                                                  : isLikeHomeData2[widget.index].isLiked = true
                                                                              : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                                  ? (isLikeHomeData3[widget.index].isLiked == true)
                                                                                      ? isLikeHomeData3[widget.index].isLiked = false
                                                                                      : isLikeHomeData3[widget.index].isLiked = true
                                                                                  : null;
                                  // (homeScreenController.categoryData.value.data![widget.index].isLiked)! == true
                                  //     ? homeScreenController.categoryData.value.data![widget.index].isLiked = false
                                  //     : homeScreenController.categoryData.value.data![widget.index].isLiked = true;
                                  detailScreenController.likedUnlikedSongs(
                                      musicId: widget.type == 'favorite song'
                                          ? null
                                          : widget.type == 'home cat song'
                                              ? (homeScreenController
                                                  .homeCategoryData[controller
                                                      .currentListTileIndexCategory
                                                      .value]
                                                  .categoryData[controller.currentListTileIndexCategoryData.value]
                                                  .id)!
                                              : widget.type == 'album song'
                                                  ? (albumScreenController
                                                      .allSongsListModel!
                                                      .data![controller.currentListTileIndexAlbumSongs.value]
                                                      .id)!
                                                  : widget.type == 'admin playlist'
                                                  ? (playlistScreenController.adminPlaylistSongModel!
                                                      .data![controller.currentListTileIndexAdminPlaylistSongs.value]
                                                      .id)!
                                                  : widget.type == 'artist song'
                                                      ? (artistScreenController
                                                          .currentPlayingId
                                                          .value)
                                                      : widget.type ==
                                                              'queue song'
                                                          ? (queueSongsScreenController
                                                              .allSongsListModel!
                                                              .data![controller.currentListTileIndexQueueSongs.value]
                                                              .id)!
                                                          : widget.type ==
                                                                  'download song'
                                                              ? (downloadSongScreenController
                                                                  .allSongsListModel!
                                                                  .data![controller.currentListTileIndexDownloadSongs.value]
                                                                  .id)!
                                                              : widget.type ==
                                                                      'search'
                                                                  ? (searchScreenController
                                                                      .allSearchModel!
                                                                      .data![controller.currentListTileIndexSearchSongs.value]
                                                                      .id)!
                                                                  : widget.type ==
                                                                          'playlist'
                                                                      ? (playlistScreenController
                                                                          .allSongsListModel!
                                                                          .data![controller.currentListTileIndex.value]
                                                                          .id)!
                                                                      : widget.type == 'allSongs'
                                                                          ? (allSongsScreenController.filteredAllSongsIds[controller.currentListTileIndexAllSongs.value])
                                                                          : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true
                                                                              ? (categoryData1!.data![widget.index].id)!
                                                                              : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                                  ? (isLikeHomeData2[widget.index].id)!
                                                                                  : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                                      ? (categoryData3!.data![widget.index].id)!
                                                                                      : null
                                      );
                                  // });
                                  if (widget.type == 'download song') {
                                    downloadSongScreenController
                                        .downloadSongsList();
                                  }
                                  if (widget.type == 'search') {
                                    searchScreenController.allSearchList(
                                        searchText: GlobVar.searchText);
                                  }
                                  if (widget.type == 'home') {
                                    fetchData();
                                  }
                                  if (widget.type == 'queue song') {
                                    queueSongsScreenController
                                        .queueSongsListWithoutPlaylist();
                                  }
                                  if (widget.type == 'favorite song') {
                                    favoriteSongScreenController
                                        .favoriteSongsList();
                                  }
                                  if (widget.type == 'playlist' || widget.type == 'admin playlist') {
                                    playlistScreenController.songsInPlaylist(
                                        playlistId: GlobVar.playlistId);
                                  }

                                  if (widget.type == 'allSongs') {
                                    allSongsScreenController.allSongsList();
                                  }
                                  if (widget.type == 'album song') {
                                    albumScreenController.albumsSongsList(
                                        albumId: GlobVar.albumId);
                                  }
                                  if (widget.type == 'artist song') {
                                    artistScreenController.artistsSongsList(
                                        artistId: GlobVar.artistId);
                                  }
                                  if (widget.type == 'home cat song') {
                                    homeScreenController.homeCategories();
                                  }
                                } else {
                                  Get.to(const WitoutLogginScreen(),
                                      transition: Transition.downToUp);
                                }
                              });
                            },
                            child: ((widget.type == 'favorite song')
                                        // &&
                                        //             controller.favoriteSongsUrl.isNotEmpty
                                        ? favoriteSongScreenController
                                                .isLikeFavData[controller.currentListTileIndexFavoriteSongs.value]
                                                .isLiked ==
                                            false
                                        : widget.type == 'home cat song'
                                            ? homeScreenController
                                                    .homeCategoryData[controller
                                                        .currentListTileIndexCategory
                                                        .value]
                                                    .categoryData[controller.currentListTileIndexCategoryData.value]
                                                    .isLiked ==
                                                false
                                            : (widget.type == 'album song')
                                                ? albumScreenController.albumSongsData[controller.currentListTileIndexAlbumSongs.value].isLiked ==
                                                    false
                                                : (widget.type == 'artist song')
                                                    ? artistScreenController
                                                            .artistSongsData[controller.currentListTileIndexArtistSongs.value]
                                                            .isLiked ==
                                                        false
                                                    : (widget.type == 'admin playlist')
                                                    ? playlistScreenController.isLikePlaylistData[controller.currentListTileIndexAdminPlaylistSongs.value]
                                                            .isLiked ==
                                                        false
                                                    : (widget.type ==
                                                            'queue song')
                                                        ? queueSongsScreenController
                                                                .isLikeQueueData[controller.currentListTileIndexQueueSongs.value]
                                                                .isLiked ==
                                                            false
                                                        : (widget.type == 'download song') && controller.isMiniPlayerOpenDownloadSongs.value == true
                                                            ? downloadSongScreenController.isLikeDownloadData[controller.currentListTileIndexDownloadSongs.value].isLiked == false
                                                            : (widget.type == 'search') && controller.isMiniPlayerOpenSearchSongs.value == true
                                                                ? searchScreenController.allSearchData[controller.currentListTileIndexSearchSongs.value].isLiked == false
                                                                : (widget.type == 'playlist') && controller.isMiniPlayerOpen.value == true
                                                                    ? playlistScreenController.isLikePlaylistData[controller.currentListTileIndex.value].isLiked == false
                                                                    : widget.type == 'allSongs' && controller.isMiniPlayerOpenAllSongs.value == true
                                                                        ? allSongsScreenController.filteredAllSongsLikes[controller.currentListTileIndexAllSongs.value] == false
                                                                        :
                                                                        // (homeScreenController
                                                                        //           .categoryData
                                                                        //           .value
                                                                        //           .data![widget
                                                                        //               .index]
                                                                        //           .id)!
                                                                        widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true
                                                                            ? (isLikeHomeData1[widget.index].isLiked == false)
                                                                            : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                                ? isLikeHomeData2[widget.index].isLiked == false
                                                                                : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                                    ? isLikeHomeData3[widget.index].isLiked == false
                                                                                    // ignore: unrelated_type_equality_checks
                                                                                    : "" == true) ||
                                    GlobVar.login == false
                                ? const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : Icon(
                                    Icons.favorite_outlined,
                                    color: Colors.red.shade200,
                                    size: 35,
                                  )),
                      ),
                      sizeBoxWidth(23),
                      InkWell(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final login = prefs.getBool('isLoggedIn') ?? '';
                          if (login == true) {
                            if (kDebugMode) {
                              print(downloadProgress);
                            }
                                    (widget.type == 'favorite song'
                                        ? controller.favoriteSongsUrl.contains(
                                                '${AppStrings.localPathMusic}/${favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id}.mp3') ==
                                            true
                                        : widget.type == 'home cat song'
                                            ? controller.categoryAudioUrl.contains(
                                                    '${AppStrings.localPathMusic}/${homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![widget.index].id}.mp3') ==
                                                true
                                            : widget.type == 'queue song'
                                                ? controller.queueSongsUrl.contains(
                                                        '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id}.mp3') ==
                                                    true
                                                : widget.type == 'admin playlist'
                                                ? controller.adminPlaylistSongsUrl.contains(
                                                        '${AppStrings.localPathMusic}/${playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id}.mp3') ==
                                                    true
                                                : widget.type == 'album song'
                                                    ? controller.albumSongsUrl.contains(
                                                            '${AppStrings.localPathMusic}/${albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id}.mp3') ==
                                                        true
                                                    : widget.type ==
                                                            'download song'
                                                        ? controller.downloadSongsUrl
                                                                .contains(
                                                                    '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id}.mp3') ==
                                                            true
                                                        : widget.type ==
                                                                'artist song'
                                                            ? controller
                                                                    .artistSongsUrl
                                                                    .contains('${AppStrings.localPathMusic}/${artistScreenController.currentPlayingId.value}.mp3') ==
                                                                true
                                                            : widget.type == 'search'
                                                                ? controller.searchSongsUrl.contains('${AppStrings.localPathMusic}/${searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].id}.mp3') == true
                                                                : widget.type == 'playlist'
                                                                    ? controller.playlisSongAudioUrl.contains('${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].id}.mp3') == true
                                                                    : widget.type == 'allSongs'
                                                                        ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[controller.currentListTileIndexAllSongs.value]}.mp3') == true
                                                                        : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true && controller.category1AudioUrl.isNotEmpty
                                                                            ? controller.category1AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3') == true
                                                                            : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true && controller.category2AudioUrl.isNotEmpty
                                                                                ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3') == true
                                                                                : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
                                                                                    ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3') == true
                                                                                    // ignore: unrelated_type_equality_checks
                                                                                    : '' == true)
                                ? null
                                : downloadAudio();
                          } else {
                            // noLoginBottomSheet();
                            Get.to(const WitoutLogginScreen(),
                                transition: Transition.downToUp);
                          }
                        },
                        child: downloading
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: CircularProgressIndicator(
                                      value: downloadProgress,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: containerIcon(
                                      icon: Icons.download,
                                      iconSize: 20,
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 3,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: lable(
                                        text:
                                            '${(downloadProgress * 100).toStringAsFixed(0)}%',
                                        color: Colors.black,
                                        fontSize: 6,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : 
                            (widget.type == 'favorite song'
                                    ? controller.favoriteSongsUrl.contains(
                                            '${AppStrings.localPathMusic}/${favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].id}.mp3') ==
                                        true
                                    : widget.type == 'queue song'
                                        ? controller.queueSongsUrl.contains(
                                                '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].id}.mp3') ==
                                            true
                                        : widget.type == 'admin playlist'
                                        ? controller.adminPlaylistSongsUrl.contains(
                                                '${AppStrings.localPathMusic}/${playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].id}.mp3') ==
                                            true
                                        : widget.type == 'album song'
                                            ? controller.albumSongsUrl.contains(
                                                    '${AppStrings.localPathMusic}/${albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].id}.mp3') ==
                                                true
                                            : widget.type == 'artist song'
                                                ? controller.artistSongsUrl.contains(
                                                        '${AppStrings.localPathMusic}/${artistScreenController.currentPlayingId.value}.mp3') ==
                                                    true
                                                : widget.type == 'download song'
                                                    ? controller
                                                            .downloadSongsUrl
                                                            .contains(
                                                                '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id}.mp3') ==
                                                        true
                                                    : widget.type == 'search'
                                                        ? controller
                                                                .searchSongsUrl
                                                                .contains(
                                                                    '${AppStrings.localPathMusic}/${searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].id}.mp3') ==
                                                            true
                                                        : widget.type == 'playlist'
                                                            ? controller.playlisSongAudioUrl.contains('${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].id}.mp3') == true
                                                            : widget.type == 'allSongs'
                                                                ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[controller.currentListTileIndexAllSongs.value]}.mp3') == true
                                                                : widget.type == 'home cat song'
                                                                    ? controller.categoryAudioUrl.contains('${AppStrings.localPathMusic}/${homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].id}.mp3') == true
                                                                    : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true && controller.category1AudioUrl.isNotEmpty
                                                                        ? controller.category1AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData1!.data![widget.index].id}.mp3') == true
                                                                        : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true && controller.category2AudioUrl.isNotEmpty
                                                                            ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData2!.data![widget.index].id}.mp3') == true
                                                                            : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
                                                                                ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData3!.data![widget.index].id}.mp3') == true
                                                                                // ignore: unrelated_type_equality_checks
                                                                                : '' == true)
                                ? containerIcon(
                                    icon: Icons.check,
                                    containerColor: Colors.green,
                                    iconColor: Colors.white,
                                    height: 35,
                                    width: 35,
                                    iconSize: 20,
                                  )
                                : containerIcon(
                                    icon: Icons.download,
                                    iconSize: 20,
                                    height: 35,
                                    width: 35,
                                  ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // SizedBox(
            //   height: h * 0.055,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       // (categoryData1 == null ||
            //       //         categoryData2 == null ||
            //       //         categoryData3 == null)
            //       //     ? Center(
            //       //         child: SizedBox(
            //       //           height: 15,
            //       //           width: 14,
            //       //           child: CircularProgressIndicator(
            //       //             color: AppColors.white,
            //       //             strokeWidth: 2,
            //       //           ),
            //       //         ),
            //       //       )
            //       //     :
            //       Obx(
            //         () =>
            //          GestureDetector(
            //           onTap: () {
            //             // log((queueSongsScreenController
            //             //     .allSongsListModel.value.data![widget.index].id)!,name: 'queue');
            //             // log((downloadSongScreenController
            //             //     .allSongsListModel.value.data![widget.index].id)!,name: 'download');
            //             // log((playlistScreenController
            //             //     .allSongsListModel.value.data![widget.index].id)!,name: 'playlist');
            //             // log((allSongsScreenController
            //             //     .allSongsListModel.value.data![widget.index].id)!,name: 'all song');
            //             // log((categoryData1!.data![widget.index].id)!,name: 'cate1');
            //             // log((categoryData2!.data![widget.index].id)!,name: 'cate2');
            //             // log((categoryData3!.data![widget.index].id)!,name: 'cate3');

            //             if(GlobVar.login == true) {
            //             setState(() {
            //               detailScreenController.likedUnlikedSongs(
            //                   musicId: widget.type == 'queue song'
            //                       ? (queueSongsScreenController
            //                           .allSongsListModel!
            //                           .data![widget.index]
            //                           .id)!
            //                       : widget.type == 'download song'
            //                           ? (downloadSongScreenController
            //                               .allSongsListModel!
            //                               .data![widget.index]
            //                               .id)!
            //                           : widget.type == 'playlist'
            //                               ? (playlistScreenController
            //                                   .allSongsListModel!
            //                                   .data![widget.index]
            //                                   .id)!
            //                               : widget.type == 'allSongs'
            //                                   ? (allSongsScreenController
            //                                       .filteredAllSongsIds[widget.index])
            //                                   // : widget.type == 'home' &&
            //                                   //         controller
            //                                   //             .category1AudioUrl
            //                                   //             .isNotEmpty
            //                                   //     ? (widget.categoryData1!
            //                                   //         .data![widget.index]
            //                                   //         .id)!
            //                                   //     : widget.type == 'home' &&
            //                                   //             controller
            //                                   //                 .category2AudioUrl
            //                                   //                 .isNotEmpty
            //                                   //         ? (widget.categoryData2!
            //                                   //             .data![widget
            //                                   //                 .index]
            //                                   //             .id)!
            //                                   //         : widget.type == 'home' &&
            //                                   //                 controller
            //                                   //                     .category3AudioUrl
            //                                   //                     .isNotEmpty
            //                                   //             ? (widget.categoryData3!
            //                                   //                 .data![widget
            //                                   //                     .index]
            //                                   //                 .id)!
            //                                               //  (homeScreenController.categoryData
            //                                               //     .value.data![widget.index].id)!
            //                                               : (homeScreenController.categoryData
            //                                                   .value.data![widget.index].id)!
            //                                               // );
            //                                               // : ''
            //                                               );
            //             });
            //             downloadSongScreenController.downloadSongsList();
            //             fetchData();
            //             queueSongsScreenController
            //                 .queueSongsListWithoutPlaylist();
            //             playlistScreenController.songsInPlaylist(
            //                 playlistId: GlobVar.playlistId);
            //             allSongsScreenController.allSongsList();} else {
            //               Get.to(const WitoutLogginScreen(),transition: Transition.downToUp);
            //             }
            //           },
            //           child:
            //               ((widget.type == 'queue song')
            //                       // &&
            //                       //             controller.queueSongsUrl.isNotEmpty
            //                       ? queueSongsScreenController.isLikeQueueData[widget.index].isLiked ==
            //                           false
            //                       : (widget.type == 'download song') &&
            //                               controller.isMiniPlayerOpenDownloadSongs.value == true
            //                           ? downloadSongScreenController.isLikeDownloadData[widget.index].isLiked ==
            //                               false
            //                           : (widget.type == 'playlist') &&
            //                                   controller.isMiniPlayerOpen.value == true
            //                               ? playlistScreenController
            //                                       .isLikePlaylistData[widget.index]
            //                                       .isLiked ==
            //                                   false
            //                               : widget.type == 'allSongs' &&
            //                                       controller.isMiniPlayerOpenAllSongs.value == true
            //                                   ? allSongsScreenController.isLikeAllSongData[widget.index]
            //                                           .isLiked ==
            //                                       false
            //                                   : widget.type == 'home'
            //                                   &&
            //                                           controller.isMiniPlayerOpenHome1.value == true
            //                                       ? categoryData1!.data![widget.index].isLiked ==
            //                                           false
            //                                       : widget.type == 'home' &&
            //                                               controller.isMiniPlayerOpenHome2.value == true
            //                                           ? categoryData2!
            //                                                   .data![widget.index]
            //                                                   .isLiked ==
            //                                               false
            //                                           : widget.type == 'home' &&
            //                                                   controller.isMiniPlayerOpenHome3.value == true
            //                                               ? categoryData3!.data![widget.index].isLiked == false

            //                                               //  ? homeScreenController.categoryData.value.data![widget.index].isLiked == false
            //                                               // ignore: unrelated_type_equality_checks
            //                                               : "" == true
            //                                               ) || GlobVar.login == false
            //                   ? containerIcon(
            //                       icon: Icons.favorite,
            //                     )
            //                   : AnimatedContainer(
            //                       duration: const Duration(milliseconds: 2000),
            //                       curve: Curves.fastEaseInToSlowEaseOut,
            //                       height: 55,
            //                       width: 55,
            //                       child: containerIcon(
            //                           icon: Icons.favorite,
            //                           iconColor: AppColors.white,
            //                           containerColor: Colors.red.shade200),
            //                     ),
            //               // ((widget.type == 'queue song') &&
            //               //             controller.queueSongsUrl.isNotEmpty
            //               //         ? queueSongsScreenController.isLikeQueueData[widget.index].isLiked ==
            //               //                 true
            //               //             ? queueSongsScreenController
            //               //                 .isLikeQueueData[widget.index]
            //               //                 .isLiked = true
            //               //             : queueSongsScreenController
            //               //                 .isLikeQueueData[widget.index]
            //               //                 .isLiked = false
            //               //         : (widget.type == 'download song') &&
            //               //                 controller
            //               //                     .downloadSongsUrl.isNotEmpty
            //               //             ? downloadSongScreenController.isLikeDownloadData[widget.index].isLiked ==
            //               //                     true
            //               //                 ? downloadSongScreenController
            //               //                         .isLikeDownloadData[widget.index].isLiked =
            //               //                     true
            //               //                 : downloadSongScreenController
            //               //                         .isLikeDownloadData[widget.index].isLiked =
            //               //                     false
            //               //             : (widget.type == 'playlist') &&
            //               //                     controller
            //               //                         .playlisSongAudioUrl
            //               //                         .isNotEmpty
            //               //                 ? playlistScreenController.isLikePlaylistData[widget.index].isLiked ==
            //               //                         true
            //               //                     ? playlistScreenController.isLikePlaylistData[widget.index].isLiked =
            //               //                         true
            //               //                     : playlistScreenController
            //               //                         .isLikePlaylistData[widget.index]
            //               //                         .isLiked = false
            //               //                 : widget.type == 'allSongs' && controller.allSongsUrl.isNotEmpty
            //               //                     ? allSongsScreenController.isLikeAllSongData[widget.index].isLiked == true
            //               //                         ? allSongsScreenController.isLikeAllSongData[widget.index].isLiked = true
            //               //                         : allSongsScreenController.isLikeAllSongData[widget.index].isLiked = false
            //               //                     : widget.type == 'home' && controller.category1AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome1.value == true
            //               //                         ? widget.categoryData1!.data![widget.index].isLiked! == true
            //               //                             ? widget.categoryData1!.data![widget.index].isLiked = true
            //               //                             : widget.categoryData1!.data![widget.index].isLiked = false
            //               //                         : widget.type == 'home' && controller.category2AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome2.value == true
            //               //                             ? widget.categoryData2!.data![widget.index].isLiked! == true
            //               //                                 ? widget.categoryData2!.data![widget.index].isLiked = true
            //               //                                 : widget.categoryData2!.data![widget.index].isLiked = false
            //               //                             : widget.type == 'home' && controller.category3AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome3.value == true
            //               //                                 ? widget.categoryData3!.data![widget.index].isLiked! == true
            //               //                                     ? widget.categoryData3!.data![widget.index].isLiked = true
            //               //                                     : widget.categoryData3!.data![widget.index].isLiked = false

            //               //                                 // ? homeScreenController.categoryData.value.data![widget.index].isLiked = true
            //               //                                 : '' == true)
            //               //     ? AnimatedContainer(
            //               //         duration:
            //               //             const Duration(milliseconds: 2000),
            //               //         curve: Curves.fastEaseInToSlowEaseOut,
            //               //         height: 55,
            //               //         width: 55,
            //               //         child: containerIcon(
            //               //             icon: Icons.favorite,
            //               //             iconColor: AppColors.white,
            //               //             containerColor:
            //               //                 Colors.red.shade200),
            //               //       )
            //               //     : containerIcon(
            //               //         icon: Icons.favorite,
            //               //       ),
            //         ),
            //       ),
            //       containerIcon(icon: Icons.shuffle),
            //       InkWell(
            //         onTap: () async {
            //           final prefs = await SharedPreferences.getInstance();
            //           final login = prefs.getBool('isLoggedIn') ?? '';
            //           if (login == true) {
            //             if (kDebugMode) {
            //               print(downloadProgress);
            //             }
            //             // detailScreenController.songExistsLocally.value == true &&
            //             (categoryData1 == null ||
            //                         categoryData2 == null ||
            //                         categoryData3 == null) ||
            //                     (widget.type == 'queue song'
            //                         ? controller.queueSongsUrl.contains(
            //                                 '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                             true
            //                         : widget.type == 'download song'
            //                             ? controller.downloadSongsUrl.contains(
            //                                     '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                                 true
            //                             : widget.type == 'playlist'
            //                                 ? controller.playlisSongAudioUrl.contains(
            //                                         '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                                     true
            //                                 : widget.type == 'allSongs'
            //                                     ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[widget.index]}.mp3') ==
            //                                         true
            //                                     : widget.type == 'home' &&
            //                                             controller.isMiniPlayerOpenHome1.value ==
            //                                                 true &&
            //                                             controller
            //                                                 .category1AudioUrl
            //                                                 .isNotEmpty
            //                                         ? controller.category1AudioUrl
            //                                                 .contains(
            //                                                     '${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3') ==
            //                                             true
            //                                         : widget.type == 'home' &&
            //                                                 controller.isMiniPlayerOpenHome2.value == true &&
            //                                                 controller.category2AudioUrl.isNotEmpty
            //                                             ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3') == true
            //                                             : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
            //                                                 ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3') == true
            //                                                 // ignore: unrelated_type_equality_checks
            //                                                 : '' == true)
            //                 //         ||
            //                 // (playlistScreenController.allSongsListModel ==
            //                 //     null) ||
            //                 // (downloadSongScreenController.allSongsListModel ==
            //                 //     null) ||
            //                 // (allSongsScreenController.allSongsListModel ==
            //                 //     null) ||
            //                 // (queueSongsScreenController.allSongsListModel ==
            //                 //     null)
            //                 ? null
            //                 : downloadAudio();
            //           } else {
            //             // noLoginBottomSheet();
            //               Get.to(const WitoutLogginScreen(),transition: Transition.downToUp);
            //           }
            //         },
            //         child: downloading
            //             ? Stack(
            //                 alignment: Alignment.center,
            //                 children: [
            //                   SizedBox(
            //                     height: 56,
            //                     width: 56,
            //                     child: CircularProgressIndicator(
            //                       value: downloadProgress,
            //                       color: Colors.blue,
            //                     ),
            //                   ),
            //                   Positioned.fill(
            //                     child:
            //                         containerIcon(icon: Icons.download),
            //                   ),
            //                   Positioned.fill(
            //                     bottom: 5,
            //                     child: Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: lable(
            //                         text:
            //                             '${(downloadProgress * 100).toStringAsFixed(0)}%',
            //                         color: AppColors.backgroundColor,
            //                         fontSize: 8,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               )
            //             :
            //             //  Obx(
            //             //     () =>
            //             // detailScreenController.songExistsLocally.value ==
            //             //         true
            //             // categoryData1 == null ||
            //             //         categoryData2 == null ||
            //             //         categoryData3 == null
            //             //     //  || (playlistScreenController.allSongsListModel == null) ||
            //             //     //     (downloadSongScreenController.allSongsListModel == null) ||
            //             //     //     (allSongsScreenController.allSongsListModel == null) ||
            //             //     //     (queueSongsScreenController.allSongsListModel == null)
            //             //     ? Center(
            //             //         child: SizedBox(
            //             //           height: 15,
            //             //           width: 14,
            //             //           child: CircularProgressIndicator(
            //             //             color: AppColors.white,
            //             //             strokeWidth: 2,
            //             //           ),
            //             //         ),
            //             //       )
            //             //     :
            //                 (widget.type == 'queue song'
            //                         ? controller.queueSongsUrl.contains(
            //                                 '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                             true
            //                         : widget.type == 'download song'
            //                             ? controller.downloadSongsUrl.contains(
            //                                     '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                                 true
            //                             : widget.type == 'playlist'
            //                                 ? controller.playlisSongAudioUrl.contains(
            //                                         '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
            //                                     true
            //                                 : widget.type == 'allSongs'
            //                                     ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[widget.index]}.mp3') ==
            //                                         true
            //                                     : widget.type == 'home' &&
            //                                             controller.isMiniPlayerOpenHome1.value ==
            //                                                 true &&
            //                                             controller
            //                                                 .category1AudioUrl
            //                                                 .isNotEmpty
            //                                         ? controller.category1AudioUrl
            //                                                 .contains(
            //                                                     '${AppStrings.localPathMusic}/${widget.categoryData1!.data![widget.index].id}.mp3') ==
            //                                             true
            //                                         : widget.type == 'home' &&
            //                                                 controller.isMiniPlayerOpenHome2.value == true &&
            //                                                 controller.category2AudioUrl.isNotEmpty
            //                                             ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData2!.data![widget.index].id}.mp3') == true
            //                                             : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
            //                                                 ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData3!.data![widget.index].id}.mp3') == true
            //                                                 // ignore: unrelated_type_equality_checks
            //                                                 : '' == true
            //                     // : controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3') == true
            //                     )
            //                     ? containerIcon(
            //                         icon: Icons.check,
            //                         containerColor: Colors.green,
            //                         iconColor: Colors.white,
            //                       )
            //                     : containerIcon(
            //                         icon: Icons.download,
            //                       ),
            //         // ),
            //       ),
            //     ],
            //   ),
            // ),
            // sizeBoxHeight(10),
            sizeBoxHeight(35),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                // setState(() {
                // seekBarData();
                // });
                final positionData = snapshot.data;
                return SeekBar(
                  isTrackTimeShow: true,
                  // ignore: prefer_if_null_operators
                  duration: positionData?.duration ?? Duration.zero,
                  // ignore: prefer_if_null_operators
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
            sizeBoxHeight(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                          // noLoginBottomSheet();
                          Get.to(const WitoutLogginScreen(),
                              transition: Transition.downToUp);
                        }
                      },
                      child: customIcon(
                        icon: Icons.playlist_add,
                      )),
                  GestureDetector(onTap: () {
                    controller.isMiniPlayerOpenHome.value == true ? 
                    controller.currentListTileIndexCategoryData.value == 0 ? null :
                    controller.currentListTileIndexCategoryData.value =  controller.currentListTileIndexCategoryData.value - 1 :
                    controller.isMiniPlayerOpenAllSongs.value == true ? 
                    controller.currentListTileIndexAllSongs.value == 0 ? null :
                    controller.currentListTileIndexAllSongs.value =  controller.currentListTileIndexAllSongs.value - 1 : 
                    controller.isMiniPlayerOpenSearchSongs.value == true ? 
                    controller.currentListTileIndexSearchSongs.value == 0 ? null :
                    controller.currentListTileIndexSearchSongs.value =  controller.currentListTileIndexSearchSongs.value - 1 : 
                    controller.isMiniPlayerOpenAlbumSongs.value == true ? 
                    controller.currentListTileIndexAlbumSongs.value == 0 ? null :
                    controller.currentListTileIndexAlbumSongs.value =  controller.currentListTileIndexAlbumSongs.value - 1 : 
                    controller.isMiniPlayerOpenArtistSongs.value == true ? 
                    controller.currentListTileIndexArtistSongs.value == 0 ? null :
                    controller.currentListTileIndexArtistSongs.value =  controller.currentListTileIndexArtistSongs.value - 1 :
                    controller.isMiniPlayerOpenAdminPlaylistSongs.value == true ? 
                    controller.currentListTileIndexAdminPlaylistSongs.value == 0 ? null :
                    controller.currentListTileIndexAdminPlaylistSongs.value = controller.currentListTileIndexAdminPlaylistSongs.value - 1 :
                    controller.isMiniPlayerOpenDownloadSongs.value == true ? 
                    controller.currentListTileIndexDownloadSongs.value == 0 ? null :
                    controller.currentListTileIndexDownloadSongs.value = controller.currentListTileIndexDownloadSongs.value - 1 :
                    controller.isMiniPlayerOpenQueueSongs.value == true ? 
                    controller.currentListTileIndexQueueSongs.value == 0 ? null :
                    controller.currentListTileIndexQueueSongs.value = controller.currentListTileIndexQueueSongs.value - 1 :
                    controller.isMiniPlayerOpenFavoriteSongs.value == true ? 
                    controller.currentListTileIndexFavoriteSongs.value == 0 ? null :
                    controller.currentListTileIndexFavoriteSongs.value = controller.currentListTileIndexFavoriteSongs.value - 1 :
                    controller.isMiniPlayerOpen.value == true ? 
                    controller.currentListTileIndex.value == 0 ? null :
                    controller.currentListTileIndex.value = controller.currentListTileIndex.value - 1 :
                    null;
                    controller.initAudioPlayer();
                  },child: customIcon(icon: Icons.skip_previous, size: 35)),
                  ControlButtons(widget.audioPlayer != null
                      ? (widget.audioPlayer!)
                      : audioPlayer),
                  GestureDetector(onTap: () {
                    controller.isMiniPlayerOpenHome.value == true ? 
                    controller.categoryAudioUrl.length == controller.currentListTileIndexCategoryData.value + 1 ? null :
                    controller.currentListTileIndexCategoryData.value = controller.currentListTileIndexCategoryData.value + 1 : 
                    controller.isMiniPlayerOpenAllSongs.value == true ?
                    controller.allSongsUrl.length == controller.currentListTileIndexAllSongs.value + 1 ? null :
                    controller.currentListTileIndexAllSongs.value =  controller.currentListTileIndexAllSongs.value + 1 :
                    controller.isMiniPlayerOpenSearchSongs.value == true ?
                    controller.searchSongsUrl.length == controller.currentListTileIndexSearchSongs.value + 1 ? null :
                    controller.currentListTileIndexSearchSongs.value =  controller.currentListTileIndexSearchSongs.value + 1 : 
                    controller.isMiniPlayerOpenAlbumSongs.value == true ?
                    controller.albumSongsUrl.length == controller.currentListTileIndexAlbumSongs.value + 1 ? null :
                    controller.currentListTileIndexAlbumSongs.value =  controller.currentListTileIndexAlbumSongs.value + 1 : 
                    controller.isMiniPlayerOpenArtistSongs.value == true ?
                    controller.artistSongsUrl.length == controller.currentListTileIndexArtistSongs.value + 1 ? null :
                    controller.currentListTileIndexArtistSongs.value =  controller.currentListTileIndexArtistSongs.value + 1 :
                    controller.isMiniPlayerOpenAdminPlaylistSongs.value == true ?
                    controller.adminPlaylistSongsUrl.length == controller.currentListTileIndexAdminPlaylistSongs.value + 1 ? null :
                    controller.currentListTileIndexAdminPlaylistSongs.value = controller.currentListTileIndexAdminPlaylistSongs.value + 1 :
                    controller.isMiniPlayerOpenDownloadSongs.value == true ?
                    controller.downloadSongsUrl.length == controller.currentListTileIndexDownloadSongs.value + 1 ? null :
                    controller.currentListTileIndexDownloadSongs.value = controller.currentListTileIndexDownloadSongs.value + 1 : 
                    controller.isMiniPlayerOpenQueueSongs.value == true ?
                    controller.queueSongsUrl.length == controller.currentListTileIndexQueueSongs.value + 1 ? null :
                    controller.currentListTileIndexQueueSongs.value = controller.currentListTileIndexQueueSongs.value + 1 : 
                    controller.isMiniPlayerOpenFavoriteSongs.value == true ?
                    controller.favoriteSongsUrl.length == controller.currentListTileIndexFavoriteSongs.value + 1 ? null :
                    controller.currentListTileIndexFavoriteSongs.value = controller.currentListTileIndexFavoriteSongs.value + 1 : 
                    controller.isMiniPlayerOpen.value == true ?
                    controller.playlisSongAudioUrl.length == controller.currentListTileIndex.value + 1 ? null :
                    controller.currentListTileIndex.value = controller.currentListTileIndex.value + 1 :
                    null;
                    controller.initAudioPlayer();
                  },child: customIcon(icon: Icons.skip_next, size: 35)),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (GlobVar.login == true) {
                            widget.type == 'album song'
                                ? (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].is_queue)! ==
                                        true
                                    ? albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].is_queue =
                                        false
                                    : albumScreenController.allSongsListModel!
                                        .data![controller.currentListTileIndexAlbumSongs.value].is_queue = true
                                : widget.type == 'artist song'
                                    ? artistScreenController.currentPlayingIsQueue.value ==
                                            true
                                        ? artistScreenController
                                            .allSongsListModel!
                                            .data![controller.currentListTileIndexArtistSongs.value]
                                            .is_queue = false
                                        : artistScreenController
                                            .allSongsListModel!
                                            .data![controller.currentListTileIndexArtistSongs.value]
                                            .is_queue = true
                                    : widget.type == 'favorite song'
                                        ? (favoriteSongScreenController
                                                    .allSongsListModel!
                                                    .data![controller.currentListTileIndexFavoriteSongs.value]
                                                    .is_queue)! ==
                                                true
                                            ? favoriteSongScreenController
                                                .allSongsListModel!
                                                .data![controller.currentListTileIndexFavoriteSongs.value]
                                                .is_queue = false
                                            : favoriteSongScreenController
                                                .allSongsListModel!
                                                .data![controller.currentListTileIndexFavoriteSongs.value]
                                                .is_queue = true
                                        : widget.type == 'admin playlist'
                                        ? (playlistScreenController.adminPlaylistSongModel!
                                                    .data![controller.currentListTileIndexAdminPlaylistSongs.value]
                                                    .is_queue)! ==
                                                true
                                            ? playlistScreenController.adminPlaylistSongModel!
                                                .data![controller.currentListTileIndexAdminPlaylistSongs.value]
                                                .is_queue = false
                                            : playlistScreenController.adminPlaylistSongModel!
                                                .data![controller.currentListTileIndexAdminPlaylistSongs.value]
                                                .is_queue = true
                                        : widget.type == 'home cat song'
                                            ? (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].is_queue)! == true
                                                ? homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].is_queue = false
                                                : homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].is_queue = true
                                            : widget.type == 'queue song'
                                                ? null
                                                : widget.type == 'download song'
                                                    ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].is_queue)! == true
                                                        ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].is_queue = false
                                                        : downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].is_queue = true
                                                    : widget.type == 'search'
                                                        ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].is_queue)! == true
                                                            ? searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].is_queue = false
                                                            : searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].is_queue = true
                                                        : widget.type == 'playlist'
                                                            ? (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].is_queue)! == true
                                                                ? playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].is_queue = false
                                                                : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].is_queue = true
                                                            : widget.type == 'allSongs'
                                                                ? (allSongsScreenController.filteredAllSongsQueues[controller.currentListTileIndexAllSongs.value]) == true
                                                                    ? allSongsScreenController.filteredAllSongsQueues[controller.currentListTileIndexAllSongs.value] = false
                                                                    : allSongsScreenController.filteredAllSongsQueues[controller.currentListTileIndexAllSongs.value] = true
                                                                : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true
                                                                    ? (isLikeHomeData1[widget.index].is_queue == true)
                                                                        ? isLikeHomeData1[widget.index].is_queue = false
                                                                        : isLikeHomeData1[widget.index].is_queue = true
                                                                    : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                        ? (isLikeHomeData2[widget.index].is_queue == true)
                                                                            ? isLikeHomeData2[widget.index].is_queue = false
                                                                            : isLikeHomeData2[widget.index].is_queue = true
                                                                        : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                            ? (isLikeHomeData3[widget.index].is_queue == true)
                                                                                ? isLikeHomeData3[widget.index].is_queue = false
                                                                                : isLikeHomeData3[widget.index].is_queue = true
                                                                            : null;
                            playlistScreenController.addQueueSong(
                              musicId: widget.type == 'favorite song'
                                  ? (favoriteSongScreenController
                                      .allSongsListModel!
                                      .data![controller.currentListTileIndexFavoriteSongs.value]
                                      .id)!
                                  : widget.type == 'home cat song'
                                      ? (homeScreenController
                                          .homeCategoryData[controller
                                              .currentListTileIndexCategory
                                              .value]
                                          .categoryData[controller.currentListTileIndexCategoryData.value]
                                          .id)!
                                      : widget.type == 'queue song'
                                          ? null
                                          : widget.type == 'album song'
                                              ? (albumScreenController
                                                  .allSongsListModel!
                                                  .data![controller.currentListTileIndexAlbumSongs.value]
                                                  .id)!
                                              : widget.type == 'admin playlist'
                                              ? (playlistScreenController.adminPlaylistSongModel!
                                                  .data![controller.currentListTileIndexAdminPlaylistSongs.value]
                                                  .id)!
                                              : widget.type == 'artist song'
                                                  ? artistScreenController
                                                      .currentPlayingId.value
                                                  : widget.type ==
                                                          'download song'
                                                      ? (downloadSongScreenController
                                                          .allSongsListModel!
                                                          .data![controller.currentListTileIndexDownloadSongs.value]
                                                          .id)!
                                                      : widget.type == 'search'
                                                          ? (searchScreenController
                                                              .allSearchModel!
                                                              .data![controller.currentListTileIndexSearchSongs.value]
                                                              .id)!
                                                          : widget.type ==
                                                                  'playlist'
                                                              ? (playlistScreenController
                                                                  .allSongsListModel!
                                                                  .data![controller.currentListTileIndex.value]
                                                                  .id)!
                                                              : widget.type ==
                                                                      'allSongs'
                                                                  ? (allSongsScreenController
                                                                          .filteredAllSongsIds[
                                                                      controller.currentListTileIndexAllSongs.value])
                                                                  : widget.type == 'home' &&
                                                                          controller.isMiniPlayerOpenHome1.value ==
                                                                              true
                                                                      ? (isLikeHomeData1[widget.index].id)!
                                                                      : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                          ? (isLikeHomeData2[widget.index].id)!
                                                                          : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                              ? (isLikeHomeData3[widget.index].id)!
                                                                              : null,
                            );
                            if (widget.type == 'download song') {
                              downloadSongScreenController.downloadSongsList();
                            }
                            if (widget.type == 'search') {
                              searchScreenController.allSearchList(
                                  searchText: GlobVar.searchText);
                            }
                            if (widget.type == 'home') {
                              fetchData();
                            }
                            if (widget.type == 'queue song') {
                              queueSongsScreenController
                                  .queueSongsListWithoutPlaylist();
                            }
                            if (widget.type == 'favorite song') {
                              favoriteSongScreenController.favoriteSongsList();
                            }
                            if (widget.type == 'playlist' || widget.type == 'admin playlist') {
                              playlistScreenController.songsInPlaylist(
                                  playlistId: GlobVar.playlistId);
                            }
                            if (widget.type == 'allSongs') {
                              allSongsScreenController.allSongsList();
                            }
                            if (widget.type == 'album song') {
                              albumScreenController.albumsSongsList(
                                  albumId: GlobVar.albumId);
                            }
                            if (widget.type == 'artist song') {
                              artistScreenController.artistsSongsList(
                                  artistId: GlobVar.artistId);
                            }
                            if (widget.type == 'home cat song') {
                              homeScreenController.homeCategories();
                            }
                          } else {
                            Get.to(const WitoutLogginScreen(),
                                transition: Transition.downToUp);
                          }
                        });
                      },
                      child: ((widget.type == 'favorite song')
                                  // &&
                                  //             controller.favoriteSongsUrl.isNotEmpty
                                  ? favoriteSongScreenController
                                          .isLikeFavData[controller.currentListTileIndexFavoriteSongs.value]
                                          .is_queue ==
                                      false
                                  : widget.type == 'home cat song'
                                      ? homeScreenController
                                              .homeCategoryData[controller
                                                  .currentListTileIndexCategory
                                                  .value]
                                              .categoryData[controller.currentListTileIndexCategoryData.value]
                                              .is_queue ==
                                          false
                                      : (widget.type == 'queue song')
                                          // &&
                                          //             controller.queueSongsUrl.isNotEmpty
                                          ? queueSongsScreenController
                                                  .isLikeQueueData[controller.currentListTileIndexQueueSongs.value]
                                                  .is_queue ==
                                              false
                                          : (widget.type == 'download song') &&
                                                  controller
                                                          .isMiniPlayerOpenDownloadSongs
                                                          .value ==
                                                      true
                                              ? downloadSongScreenController
                                                      .isLikeDownloadData[
                                                          controller.currentListTileIndexDownloadSongs.value]
                                                      .is_queue ==
                                                  false
                                              : (widget.type == 'admin playlist') &&
                                                  controller
                                                          .isMiniPlayerOpenAdminPlaylistSongs
                                                          .value ==
                                                      true
                                              ? playlistScreenController.isLikePlaylistData[controller.currentListTileIndexAdminPlaylistSongs.value]
                                                      .is_queue ==
                                                  false
                                              : (widget.type == 'search') &&
                                                      controller.isMiniPlayerOpenSearchSongs.value == true
                                                  ? searchScreenController.allSearchData[controller.currentListTileIndexSearchSongs.value].is_queue == false
                                                  : (widget.type == 'playlist') && controller.isMiniPlayerOpen.value == true
                                                      ? playlistScreenController.isLikePlaylistData[controller.currentListTileIndex.value].is_queue == false
                                                      : widget.type == 'allSongs' && controller.isMiniPlayerOpenAllSongs.value == true
                                                          ? allSongsScreenController.filteredAllSongsQueues[controller.currentListTileIndexAllSongs.value] == false
                                                          : widget.type == 'album song' && controller.isMiniPlayerOpenAlbumSongs.value == true
                                                              ? albumScreenController.albumSongsData[controller.currentListTileIndexAlbumSongs.value].is_queue == false
                                                              : widget.type == 'artist song' && controller.isMiniPlayerOpenArtistSongs.value == true
                                                                  ? artistScreenController.artistSongsData[controller.currentListTileIndexArtistSongs.value].is_queue == false
                                                                  : widget.type == 'home' && controller.isMiniPlayerOpenHome1.value == true
                                                                      ? (isLikeHomeData1[widget.index].is_queue == false)
                                                                      : widget.type == 'home' && controller.isMiniPlayerOpenHome2.value == true
                                                                          ? isLikeHomeData2[widget.index].is_queue == false
                                                                          : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true
                                                                              ? isLikeHomeData3[widget.index].is_queue == false
                                                                              // ignore: unrelated_type_equality_checks
                                                                              : "" == true) ||
                              GlobVar.login == false
                          ? customIcon(icon: Icons.repeat)
                          : customIcon(icon: Icons.repeat_on),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            GestureDetector(
              onTap: () {
                if (GlobVar.login == true) {
                  queueSongsScreenController.queueSongsListWithoutPlaylist();
                  Get.to(QueueSongsScreen(),
                      transition: Transition.leftToRight);
                } else {
                  Get.to(const WitoutLogginScreen(),
                      transition: Transition.downToUp);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                  sizeBoxWidth(5),
                  lable(text: 'Playing Queue'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        controller.isMiniPlayerOpenDownloadSongs.value == true ||
                controller.isMiniPlayerOpen.value == true ||
                controller.isMiniPlayerOpenHome.value == true ||
                controller.isMiniPlayerOpenHome1.value == true ||
                controller.isMiniPlayerOpenHome2.value == true ||
                controller.isMiniPlayerOpenHome3.value == true ||
                controller.isMiniPlayerOpenAllSongs.value == true ||
                controller.isMiniPlayerOpenQueueSongs.value == true ||
                (controller.isMiniPlayerOpenFavoriteSongs.value) == true ||
                (controller.isMiniPlayerOpenAlbumSongs.value) == true ||
                (controller.isMiniPlayerOpenArtistSongs.value) == true ||
                (controller.isMiniPlayerOpenSearchSongs.value) == true ||
                (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == true
            ? controller.audioPlayer.positionStream
            : controller.audioPlayer.positionStream,
        controller.isMiniPlayerOpenDownloadSongs.value == true ||
                controller.isMiniPlayerOpen.value == true ||
                controller.isMiniPlayerOpenHome.value == true ||
                controller.isMiniPlayerOpenHome1.value == true ||
                controller.isMiniPlayerOpenHome2.value == true ||
                controller.isMiniPlayerOpenHome3.value == true ||
                controller.isMiniPlayerOpenAllSongs.value == true ||
                controller.isMiniPlayerOpenQueueSongs.value == true ||
                (controller.isMiniPlayerOpenFavoriteSongs.value) == true ||
                (controller.isMiniPlayerOpenAlbumSongs.value) == true ||
                (controller.isMiniPlayerOpenArtistSongs.value) == true ||
                controller.isMiniPlayerOpenSearchSongs.value == true ||
                controller.isMiniPlayerOpenAdminPlaylistSongs.value == true
            ? controller.audioPlayer.bufferedPositionStream
            : controller.audioPlayer.bufferedPositionStream,
        controller.isMiniPlayerOpenDownloadSongs.value == true ||
                controller.isMiniPlayerOpen.value == true ||
                controller.isMiniPlayerOpenHome.value == true ||
                controller.isMiniPlayerOpenHome1.value == true ||
                controller.isMiniPlayerOpenHome2.value == true ||
                controller.isMiniPlayerOpenHome3.value == true ||
                controller.isMiniPlayerOpenAllSongs.value == true ||
                controller.isMiniPlayerOpenQueueSongs.value == true ||
                (controller.isMiniPlayerOpenFavoriteSongs.value) == true ||
                (controller.isMiniPlayerOpenAlbumSongs.value) == true ||
                (controller.isMiniPlayerOpenArtistSongs.value) == true ||
                controller.isMiniPlayerOpenSearchSongs.value == true ||
                controller.isMiniPlayerOpenAdminPlaylistSongs.value == true
            ? controller.audioPlayer.durationStream
            : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  // Stream<PositionData> get _positionDataStream =>
  //     rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //       widget.positionStream != null
  //           ? widget.positionStream!
  //           : audioPlayer.positionStream,
  //       widget.bufferedPositionStream != null
  //           ? widget.bufferedPositionStream!
  //           : audioPlayer.bufferedPositionStream,
  //       widget.durationStream != null
  //           ? widget.durationStream!
  //           : audioPlayer.durationStream,
  //       (position, bufferedPosition, duration) => PositionData(
  //         position,
  //         bufferedPosition,
  //         duration ?? Duration.zero,
  //       ),
  //     );

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
                child: AlertDialog(
                  backgroundColor: AppColors.backgroundColor,
                  title: lable(
                      text: AppStrings.addPlaylistName,
                      fontWeight: FontWeight.w600),
                  content: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: myKey4,
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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
                                    Navigator.pop(context);
                                    // Navigator.pop(context);
                                    // Get.offAll(DetailScreen(
                                    //   index: 0,
                                    //   type: '',
                                    // ));
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

// // ignore_for_file: unnecessary_null_comparison

// import 'dart:developer';
// // import 'dart:io';

// import 'package:audio_session/audio_session.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
// import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
// import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
// import 'package:edpal_music_app_ui/utils/assets.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
// import 'package:edpal_music_app_ui/utils/common_method.dart';
// import 'package:edpal_music_app_ui/utils/globVar.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:edpal_music_app_ui/utils/validation.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/without_login_screen.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bounce/flutter_bounce.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;

// // ignore: depend_on_referenced_packages
// import 'package:path_provider/path_provider.dart';
// import 'package:rxdart/rxdart.dart' as rxdart;
// import 'package:shared_preferences/shared_preferences.dart';

// // ignore: must_be_immutable
// class DetailScreen extends StatefulWidget {
//   final int index;
//   final String type;
//   Duration? duration;
//   Duration? position;
//   Duration? bufferedPosition;
//   // ignore: prefer_typing_uninitialized_variables
//   var positionStream;
//   // ignore: prefer_typing_uninitialized_variables
//   var bufferedPositionStream;
//   // ignore: prefer_typing_uninitialized_variables
//   var durationStream;
//   AudioPlayer? audioPlayer;
//   CategoryData? categoryData1;
//   CategoryData? categoryData2;
//   CategoryData? categoryData3;
//   DetailScreen(
//       {required this.index,
//       required this.type,
//       this.duration,
//       this.position,
//       this.bufferedPosition,
//       this.positionStream,
//       this.bufferedPositionStream,
//       this.durationStream,
//       this.audioPlayer,
//       this.categoryData1,
//       this.categoryData2,
//       this.categoryData3,
//       super.key});

//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }

// class _DetailScreenState extends State<DetailScreen>
//     with WidgetsBindingObserver {
//   final HomeScreenController homeScreenController =
//       Get.put(HomeScreenController());
//   final DetailScreenController detailScreenController =
//       Get.put(DetailScreenController());
//   AllSongsScreenController allSongsScreenController =
//       Get.put(AllSongsScreenController());
//   PlaylistScreenController playlistScreenController =
//       Get.put(PlaylistScreenController());
//   ProfileController profileController = Get.put(ProfileController());
//   DownloadSongScreenController downloadSongScreenController =
//       Get.put(DownloadSongScreenController());
//   final MainScreenController controller =
//       Get.put(MainScreenController(initialIndex: 0));
//   QueueSongsScreenController queueSongsScreenController =
//       Get.put(QueueSongsScreenController());

//   final TextEditingController playlistNameController = TextEditingController();

//   GlobalKey<FormState> myKey4 = GlobalKey<FormState>();

//   late AudioPlayer audioPlayer = AudioPlayer();

//   bool isPlaying = true;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   bool downloading = false;
//   double downloadProgress = 0.0;
//   bool isLoding = false;

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     fetchData();
//     _initAudioPlayer();
//     log(detailScreenController.message.toString());
//     fetchMyPlaylistData();
//     cheackInMyPlaylistSongAvailable();
//     downloadSongScreenController.downloadSongsList();
//     queueSongsScreenController.queueSongsListWithoutPlaylist();
//     audioPlayer.play();
//     if (widget.position != null) {
//       audioPlayer.seek(position);
//     }
//     widget.type == 'allSongs'
//         ? allSongsScreenController.allSongsListModel != null
//         : null;
//     log(widget.type, name: 'type');
//   }

//   // String formatTime(Duration duration) {
//   //   String twoDigits(int n) => n.toString().padLeft(2, '0');
//   //   final hours = twoDigits(duration.inHours);
//   //   final minutes = twoDigits(duration.inMinutes.remainder(60));
//   //   final seconds = twoDigits(duration.inSeconds.remainder(60));
//   //   return [
//   //     if (duration.inHours > 0) hours,
//   //     minutes,
//   //     seconds,
//   //   ].join(':');
//   // }

//   void _initAudioPlayer() async {
//     final url = widget.type == 'queue song'
//         ? queueSongsScreenController
//             .allSongsListModel.value.data![widget.index].audio
//         : widget.type == 'download song'
//             ? downloadSongScreenController
//                 .allSongsListModel.value.data![widget.index].audio
//             : widget.type == 'playlist'
//                 ? playlistScreenController
//                     .allSongsListModel.value.data![widget.index].audio
//                 : widget.type == 'allSongs'
//                     ? allSongsScreenController
//                         .allSongsListModel.value.data![widget.index].audio
//                     : homeScreenController
//                         .categoryData.value.data![widget.index].audio;

//     if (url != null) {
//       final session = await AudioSession.instance;
//       await session.configure(const AudioSessionConfiguration.speech());
//       audioPlayer.playbackEventStream.listen((event) {},
//           onError: (Object e, StackTrace stackTrace) {
//         if (kDebugMode) {
//           print('A stream error occurred: $e');
//         }
//       });
//       // final localFilePath = widget.type == 'download song'
//       //     ? '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//       //     : widget.type == 'playlist'
//       //         ? '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//       //         : widget.type == 'allSongs'
//       //             ? '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//       //             : '${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3';

//       // final file = File(localFilePath);

//       // if (file.existsSync()) {
//       //   try {
//       //     // audioPlayer.dispose();
//       //     log('locally playing.');
//       //     detailScreenController.songExistsLocally.value = true;
//       //     // await audioPlayer.setFilePath(localFilePath);
//       //     MediaItem mediaItem = MediaItem(
//       //       id: widget.type == 'download song'
//       //           ? '${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}'
//       //           : widget.type == 'playlist'
//       //               ? '${playlistScreenController.allSongsListModel.value.data![widget.index].id}'
//       //               : widget.type == 'allSongs'
//       //                   ? '${allSongsScreenController.allSongsListModel.value.data![widget.index].id}'
//       //                   : '${homeScreenController.categoryData.value.data![widget.index].id}',
//       //       album: "Album name",
//       //       title: widget.type == 'download song'
//       //           ? "${downloadSongScreenController.allSongsListModel.value.data![widget.index].title}"
//       //           : widget.type == 'playlist'
//       //               ? "${playlistScreenController.allSongsListModel.value.data![widget.index].title}"
//       //               : widget.type == 'allSongs'
//       //                   ? '${allSongsScreenController.allSongsListModel.value.data![widget.index].title}'
//       //                   : "${homeScreenController.categoryData.value.data![widget.index].title}",
//       //       artUri: widget.type == 'download song'
//       //           ? Uri.parse(
//       //               "${downloadSongScreenController.allSongsListModel.value.data![widget.index].image}")
//       //           : widget.type == 'playlist'
//       //               ? Uri.parse(
//       //                   "${playlistScreenController.allSongsListModel.value.data![widget.index].image}")
//       //               : widget.type == 'allSongs'
//       //                   ? Uri.parse(
//       //                       "${allSongsScreenController.allSongsListModel.value.data![widget.index].image}")
//       //                   : Uri.parse(
//       //                       "${homeScreenController.categoryData.value.data![widget.index].image}"),
//       //     );
//       //     await audioPlayer.setAudioSource(
//       //       AudioSource.uri(
//       //         Uri.parse(localFilePath),
//       //         tag: mediaItem,
//       //       ),
//       //     );
//       //   } catch (e) {
//       //     if (kDebugMode) {
//       //       print("Error initializing audio player: $e");
//       //     }
//       //   }
//       // } else {
//       try {
//         // audioPlayer.dispose();
//         log('plying with internet.');
//         MediaItem mediaItem = MediaItem(
//           id: widget.type == 'queue song'
//               ? '${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}'
//               : widget.type == 'download song'
//                   ? '${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}'
//                   : widget.type == 'playlist'
//                       ? '${playlistScreenController.allSongsListModel.value.data![widget.index].id}'
//                       : widget.type == 'allSongs'
//                           ? '${allSongsScreenController.allSongsListModel.value.data![widget.index].id}'
//                           : '${homeScreenController.categoryData.value.data![widget.index].id}',
//           album: "Album name",
//           title: widget.type == 'queue song'
//               ? "${queueSongsScreenController.allSongsListModel.value.data![widget.index].title}"
//               : widget.type == 'download song'
//                   ? "${downloadSongScreenController.allSongsListModel.value.data![widget.index].title}"
//                   : widget.type == 'playlist'
//                       ? "${playlistScreenController.allSongsListModel.value.data![widget.index].title}"
//                       : widget.type == 'allSongs'
//                           ? '${allSongsScreenController.allSongsListModel.value.data![widget.index].title}'
//                           : "${homeScreenController.categoryData.value.data![widget.index].title}",
//           artUri: widget.type == 'queue song'
//               ? Uri.parse(
//                   "${queueSongsScreenController.allSongsListModel.value.data![widget.index].image}")
//               : widget.type == 'download song'
//                   ? Uri.parse(
//                       "${downloadSongScreenController.allSongsListModel.value.data![widget.index].image}")
//                   : widget.type == 'playlist'
//                       ? Uri.parse(
//                           "${playlistScreenController.allSongsListModel.value.data![widget.index].image}")
//                       : widget.type == 'allSongs'
//                           ? Uri.parse(
//                               "${allSongsScreenController.allSongsListModel.value.data![widget.index].image}")
//                           : Uri.parse(
//                               "${homeScreenController.categoryData.value.data![widget.index].image}"),
//         );
//         await audioPlayer.setAudioSource(
//           AudioSource.uri(
//             Uri.parse(url),
//             tag: mediaItem,
//           ),
//         );

//         if (widget.position != null) {
//           audioPlayer.positionStream.listen((position) {
//             // setState(() {
//             //   if (mounted) {
//             widget.position = position;
//             //   }
//             // });
//           });
//         }
//       } catch (e) {
//         if (kDebugMode) {
//           print("Error initializing audio player: $e");
//         }
//       }
//     }
//     // }
//   }

//   final apiHelper = ApiHelper();

//   bool isLoading = false;
//   MyPlaylistDataModel? myPlaylistDataModel;
//   MyPlaylistDataModel? myPlaylistDataModel1;

//   Future<void> fetchMyPlaylistData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

//       myPlaylistDataModel =
//           MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//         isLoading = false;
//       }
//     }
//   }

//   Future<void> cheackInMyPlaylistSongAvailable() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final myPlaylistDataModel1Json = await apiHelper
//           .cheackInMyPlaylistSongAvailable(widget.type == 'queue song'
//               ? (queueSongsScreenController
//                   .allSongsListModel.value.data![widget.index].id)!
//               : widget.type == 'download song'
//                   ? (downloadSongScreenController
//                       .allSongsListModel.value.data![widget.index].id)!
//                   : widget.type == 'playlist'
//                       ? (playlistScreenController
//                           .allSongsListModel.value.data![widget.index].id)!
//                       : widget.type == 'allSongs'
//                           ? (allSongsScreenController
//                               .allSongsListModel.value.data![widget.index].id)!
//                           : (homeScreenController
//                                   .categoryData.value.data![widget.index].id) ??
//                               '');

//       myPlaylistDataModel1 =
//           MyPlaylistDataModel.fromJson(myPlaylistDataModel1Json);

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//         isLoading = false;
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // (widget.audioPlayer) != null ?
//     // (widget.audioPlayer)!.dispose() :
//     // audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> downloadAudio() async {
//     final url = widget.type == 'queue song'
//         ? queueSongsScreenController
//             .allSongsListModel.value.data![widget.index].audio
//         : widget.type == 'download song'
//             ? downloadSongScreenController
//                 .allSongsListModel.value.data![widget.index].audio
//             : widget.type == 'playlist'
//                 ? playlistScreenController
//                     .allSongsListModel.value.data![widget.index].audio
//                 : widget.type == 'allSongs'
//                     ? allSongsScreenController
//                         .filteredAllSongsAudios[widget.index]
//                     : widget.type == 'home' &&
//                             controller.category1AudioUrl.isNotEmpty
//                         ? (categoryData1!.data![widget.index].audio)
//                         : widget.type == 'home' &&
//                                 controller.category2AudioUrl.isNotEmpty
//                             ? (categoryData2!.data![widget.index].audio)
//                             : widget.type == 'home' &&
//                                     controller.category3AudioUrl.isNotEmpty
//                                 ? (categoryData3!.data![widget.index].audio)
//                                 : null;
//     // homeScreenController
//     // .categoryData.value.data![widget.index].audio;
//     final id = widget.type == 'queue song'
//         ? queueSongsScreenController.allSongsListModel.value.data![widget.index].id
//         : widget.type == 'download song'
//             ? downloadSongScreenController
//                 .allSongsListModel.value.data![widget.index].id
//             : widget.type == 'playlist'
//                 ? playlistScreenController
//                     .allSongsListModel.value.data![widget.index].id
//                 : widget.type == 'allSongs'
//                     ? allSongsScreenController
//                         .filteredAllSongsIds[widget.index]
//                     : widget.type == 'home' &&
//                             controller.category1AudioUrl.isNotEmpty
//                         ? (categoryData1!.data![widget.index].id)
//                         : widget.type == 'home' &&
//                                 controller.category2AudioUrl.isNotEmpty
//                             ? (categoryData2!.data![widget.index].id)
//                             : widget.type == 'home' &&
//                                     controller.category3AudioUrl.isNotEmpty
//                                 ? (categoryData3!.data![widget.index].id)
//                                 : null;
//     // homeScreenController
//     //     .categoryData.value.data![widget.index].id;

//     final directory = await getExternalStorageDirectory();

//     if (directory != null) {
//       final filePath = '${directory.path}/$id.mp3';
//       log(filePath, name: 'file path audio');

//       try {
//         setState(() {
//           downloading = true;
//         });
//         final dio = Dio();
//         final response = await dio.download(
//           url!,
//           filePath,
//           onReceiveProgress: (received, total) {
//             if (mounted) {
//               setState(() {
//                 downloadProgress = received / total;
//               });
//             }
//           },
//         );

//         if (response.statusCode == 200) {
//           setState(() {
//             downloading = false;
//           });
//           detailScreenController.addSongInDownloadlist(
//               musicId: widget.type == 'queue song'
//                   ? queueSongsScreenController
//                       .allSongsListModel.value.data![widget.index].id
//                   : widget.type == 'download song'
//                       ? downloadSongScreenController
//                           .allSongsListModel.value.data![widget.index].id
//                       : widget.type == 'playlist'
//                           ? playlistScreenController
//                               .allSongsListModel.value.data![widget.index].id
//                           : widget.type == 'allSongs'
//                               ? allSongsScreenController
//                                   .filteredAllSongsIds[widget.index]
//                               : homeScreenController
//                                   .categoryData.value.data![widget.index].id);

//           // allSongsScreenController.allSongsList();
//           // playlistScreenController.songsInPlaylist(playlistId: '');
//           // fetchData();
//           // downloadSongScreenController.downloadSongsList();
//           // queueSongsScreenController.queueSongsListWithoutPlaylist();

//           widget.type == 'home' &&
//                   controller.isMiniPlayerOpenHome1.value == true
//               ? controller.category1AudioUrl[widget.index] =
//                   '${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3'
//               : widget.type == 'home' &&
//                       controller.isMiniPlayerOpenHome2.value == true
//                   ? controller.category2AudioUrl[widget.index] =
//                       '${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3'
//                   : widget.type == 'home' &&
//                           controller.isMiniPlayerOpenHome3.value == true
//                       ? controller.category3AudioUrl[widget.index] =
//                           '${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3'
//                       // : null;
//                       : widget.type == 'playlist' &&
//                               controller.isMiniPlayerOpen.value == true
//                           ? controller.playlisSongAudioUrl[widget.index] =
//                               '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//                           : widget.type == 'allSongs' &&
//                                   controller.isMiniPlayerOpenAllSongs.value ==
//                                       true
//                               ? controller.allSongsUrl[widget.index] =
//                                   '${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[widget.index]}.mp3'
//                               : widget.type == 'download song' &&
//                                       controller.isMiniPlayerOpenDownloadSongs
//                                               .value ==
//                                           true
//                                   ? controller.downloadSongsUrl[widget.index] =
//                                       '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//                                   : widget.type == 'queue song' &&
//                                           controller.isMiniPlayerOpenQueueSongs
//                                                   .value ==
//                                               true
//                                       ? controller.queueSongsUrl[widget.index] =
//                                           '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//                                       : '';
//           detailScreenController.songExistsLocally.value = true;
//           snackBar(AppStrings.audioDownloadSuccessfully);
//         } else {
//           setState(() {
//             downloading = false;
//           });
//           snackBar('Failed to download audio');
//         }
//       } on DioException catch (_) {
//         setState(() {
//           downloading = false;
//         });
//         snackBar(AppStrings.internetNotAvailable);
//       } catch (e) {
//         setState(() {
//           downloading = false;
//         });
//         if (kDebugMode) {
//           print(e);
//         }
//         snackBar('Error :$e');
//       }
//     }
//   }

//   // bool isLoading = false;
//   CategoryData? categoryData1;
//   CategoryData? categoryData2;
//   CategoryData? categoryData3;

//   Future<void> fetchData() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final login = prefs.getBool('isLoggedIn') ?? '';
//       if (kDebugMode) {
//         print(login);
//       }
//       final categoryData1Json = login == false
//           ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory1')
//           : await apiHelper.fetchHomeCategoryData('category1');
//       final categoryData2Json = login == false
//           ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory2')
//           : await apiHelper.fetchHomeCategoryData('category2');
//       final categoryData3Json = login == false
//           ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory3')
//           : await apiHelper.fetchHomeCategoryData('category3');

//       categoryData1 = CategoryData.fromJson(categoryData1Json);
//       categoryData2 = CategoryData.fromJson(categoryData2Json);
//       categoryData3 = CategoryData.fromJson(categoryData3Json);

//       setState(() {
//         if (mounted) {
//           isLoading = false;
//         }
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//         isLoading = false;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     // final localFilePath = widget.type == 'download song'
//     //     ? '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//     //     : widget.type == 'playlist'
//     //         ? '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//     //         : widget.type == 'allSongs'
//     //             ? '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3'
//     //             : '${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3';

//     // final file = File(localFilePath);

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         title: lable(
//           text: AppStrings.nowPlaying,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             (widget.audioPlayer) != null
//                 ? Get.back()
//                 : Get.offAll(MainScreen());
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.white,
//             size: 21,
//           ),
//         ),
//       ),
//       body:
//        (categoryData1 == null ||
//               categoryData2 == null ||
//               categoryData3 == null)
//           ? Center(
//               child: SizedBox(
//                 height: 15,
//                 width: 14,
//                 child: CircularProgressIndicator(
//                   color: AppColors.white,
//                   strokeWidth: 2,
//                 ),
//               ),
//             )
//           :
//           SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: h * 0.03,
//                   ),
//                   ClipRRect(
//                     // borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       widget.type == 'queue song'
//                           ? queueSongsScreenController.allSongsListModel!
//                                   .data![widget.index].image ??
//                               'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                           : widget.type == 'download song'
//                               ? downloadSongScreenController.allSongsListModel!
//                                       .data![widget.index].image ??
//                                   'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                               : widget.type == 'playlist'
//                                   ? playlistScreenController.allSongsListModel!
//                                           .data![widget.index].image ??
//                                       'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                   : widget.type == 'allSongs'
//                                       ? allSongsScreenController
//                                               .filteredAllSongsImage[widget.index]
//                                       : homeScreenController.categoryData.value
//                                               .data![widget.index].image ??
//                                           'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
//                       height: h * 0.3,
//                       width: w * 0.75,
//                       fit: BoxFit.fill,
//                       filterQuality: FilterQuality.high,
//                     ),
//                   ),
//                   SizedBox(
//                     height: h * 0.03,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 60),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: lable(
//                           text: widget.type == 'queue song'
//                               ? (queueSongsScreenController.allSongsListModel!
//                                   .data![widget.index].title)!
//                               : widget.type == 'download song'
//                                   ? (downloadSongScreenController
//                                       .allSongsListModel!
//                                       .data![widget.index]
//                                       .title)!
//                                   : widget.type == 'playlist'
//                                       ? (playlistScreenController
//                                           .allSongsListModel!
//                                           .data![widget.index]
//                                           .title)!
//                                       : widget.type == 'allSongs'
//                                           ? (allSongsScreenController
//                                               .filteredAllSongsTitles[widget.index])
//                                           : homeScreenController
//                                                   .categoryData
//                                                   .value
//                                                   .data![widget.index]
//                                                   .title ??
//                                               AppStrings.noTitle,
//                           fontWeight: FontWeight.w600,
//                           maxLines: 2,
//                           textAlign: TextAlign.center,
//                           fontSize: 17),
//                     ),
//                   ),
//                   SizedBox(
//                     height: h * 0.01,
//                   ),
//                   // lable(text: AppStrings.unknown),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: lable(
//                         text: widget.type == 'queue song'
//                             ? (queueSongsScreenController.allSongsListModel!
//                                 .data![widget.index].description)!
//                             : widget.type == 'download song'
//                                 ? (downloadSongScreenController
//                                     .allSongsListModel!
//                                     .data![widget.index]
//                                     .description)!
//                                 : widget.type == 'playlist'
//                                     ? (playlistScreenController
//                                         .allSongsListModel!
//                                         .data![widget.index]
//                                         .description)!
//                                     : widget.type == 'allSongs'
//                                         ? (allSongsScreenController
//                                             .filteredAllSongsDesc[widget.index])
//                                         : homeScreenController
//                                                 .categoryData
//                                                 .value
//                                                 .data![widget.index]
//                                                 .description ??
//                                             AppStrings.unknown,
//                         maxLines: 2,
//                         textAlign: TextAlign.center),
//                   ),
//                   SizedBox(
//                     height: h * 0.055,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // (categoryData1 == null ||
//                         //         categoryData2 == null ||
//                         //         categoryData3 == null)
//                         //     ? Center(
//                         //         child: SizedBox(
//                         //           height: 15,
//                         //           width: 14,
//                         //           child: CircularProgressIndicator(
//                         //             color: AppColors.white,
//                         //             strokeWidth: 2,
//                         //           ),
//                         //         ),
//                         //       )
//                         //     :
//                         Obx(
//                           () =>
//                            GestureDetector(
//                             onTap: () {
//                               // log((queueSongsScreenController
//                               //     .allSongsListModel.value.data![widget.index].id)!,name: 'queue');
//                               // log((downloadSongScreenController
//                               //     .allSongsListModel.value.data![widget.index].id)!,name: 'download');
//                               // log((playlistScreenController
//                               //     .allSongsListModel.value.data![widget.index].id)!,name: 'playlist');
//                               // log((allSongsScreenController
//                               //     .allSongsListModel.value.data![widget.index].id)!,name: 'all song');
//                               // log((categoryData1!.data![widget.index].id)!,name: 'cate1');
//                               // log((categoryData2!.data![widget.index].id)!,name: 'cate2');
//                               // log((categoryData3!.data![widget.index].id)!,name: 'cate3');

//                               if(GlobVar.login == true) {
//                               setState(() {
//                                 detailScreenController.likedUnlikedSongs(
//                                     musicId: widget.type == 'queue song'
//                                         ? (queueSongsScreenController
//                                             .allSongsListModel!
//                                             .data![widget.index]
//                                             .id)!
//                                         : widget.type == 'download song'
//                                             ? (downloadSongScreenController
//                                                 .allSongsListModel!
//                                                 .data![widget.index]
//                                                 .id)!
//                                             : widget.type == 'playlist'
//                                                 ? (playlistScreenController
//                                                     .allSongsListModel!
//                                                     .data![widget.index]
//                                                     .id)!
//                                                 : widget.type == 'allSongs'
//                                                     ? (allSongsScreenController
//                                                         .filteredAllSongsIds[widget.index])
//                                                     // : widget.type == 'home' &&
//                                                     //         controller
//                                                     //             .category1AudioUrl
//                                                     //             .isNotEmpty
//                                                     //     ? (widget.categoryData1!
//                                                     //         .data![widget.index]
//                                                     //         .id)!
//                                                     //     : widget.type == 'home' &&
//                                                     //             controller
//                                                     //                 .category2AudioUrl
//                                                     //                 .isNotEmpty
//                                                     //         ? (widget.categoryData2!
//                                                     //             .data![widget
//                                                     //                 .index]
//                                                     //             .id)!
//                                                     //         : widget.type == 'home' &&
//                                                     //                 controller
//                                                     //                     .category3AudioUrl
//                                                     //                     .isNotEmpty
//                                                     //             ? (widget.categoryData3!
//                                                     //                 .data![widget
//                                                     //                     .index]
//                                                     //                 .id)!
//                                                                 //  (homeScreenController.categoryData
//                                                                 //     .value.data![widget.index].id)!
//                                                                 : (homeScreenController.categoryData
//                                                                     .value.data![widget.index].id)!
//                                                                 // );
//                                                                 // : ''
//                                                                 );
//                               });
//                               downloadSongScreenController.downloadSongsList();
//                               fetchData();
//                               queueSongsScreenController
//                                   .queueSongsListWithoutPlaylist();
//                               playlistScreenController.songsInPlaylist(
//                                   playlistId: GlobVar.playlistId);
//                               allSongsScreenController.allSongsList();} else {
//                                 Get.to(const WitoutLogginScreen(),transition: Transition.downToUp);
//                               }
//                             },
//                             child:
//                                 ((widget.type == 'queue song')
//                                         // &&
//                                         //             controller.queueSongsUrl.isNotEmpty
//                                         ? queueSongsScreenController.isLikeQueueData[widget.index].isLiked ==
//                                             false
//                                         : (widget.type == 'download song') &&
//                                                 controller.isMiniPlayerOpenDownloadSongs.value == true
//                                             ? downloadSongScreenController.isLikeDownloadData[widget.index].isLiked ==
//                                                 false
//                                             : (widget.type == 'playlist') &&
//                                                     controller.isMiniPlayerOpen.value == true
//                                                 ? playlistScreenController
//                                                         .isLikePlaylistData[widget.index]
//                                                         .isLiked ==
//                                                     false
//                                                 : widget.type == 'allSongs' &&
//                                                         controller.isMiniPlayerOpenAllSongs.value == true
//                                                     ? allSongsScreenController.isLikeAllSongData[widget.index]
//                                                             .isLiked ==
//                                                         false
//                                                     : widget.type == 'home'
//                                                     &&
//                                                             controller.isMiniPlayerOpenHome1.value == true
//                                                         ? categoryData1!.data![widget.index].isLiked ==
//                                                             false
//                                                         : widget.type == 'home' &&
//                                                                 controller.isMiniPlayerOpenHome2.value == true
//                                                             ? categoryData2!
//                                                                     .data![widget.index]
//                                                                     .isLiked ==
//                                                                 false
//                                                             : widget.type == 'home' &&
//                                                                     controller.isMiniPlayerOpenHome3.value == true
//                                                                 ? categoryData3!.data![widget.index].isLiked == false

//                                                                 //  ? homeScreenController.categoryData.value.data![widget.index].isLiked == false
//                                                                 // ignore: unrelated_type_equality_checks
//                                                                 : "" == true
//                                                                 ) || GlobVar.login == false
//                                     ? containerIcon(
//                                         icon: Icons.favorite,
//                                       )
//                                     : AnimatedContainer(
//                                         duration: const Duration(milliseconds: 2000),
//                                         curve: Curves.fastEaseInToSlowEaseOut,
//                                         height: 55,
//                                         width: 55,
//                                         child: containerIcon(
//                                             icon: Icons.favorite,
//                                             iconColor: AppColors.white,
//                                             containerColor: Colors.red.shade200),
//                                       ),
//                                 // ((widget.type == 'queue song') &&
//                                 //             controller.queueSongsUrl.isNotEmpty
//                                 //         ? queueSongsScreenController.isLikeQueueData[widget.index].isLiked ==
//                                 //                 true
//                                 //             ? queueSongsScreenController
//                                 //                 .isLikeQueueData[widget.index]
//                                 //                 .isLiked = true
//                                 //             : queueSongsScreenController
//                                 //                 .isLikeQueueData[widget.index]
//                                 //                 .isLiked = false
//                                 //         : (widget.type == 'download song') &&
//                                 //                 controller
//                                 //                     .downloadSongsUrl.isNotEmpty
//                                 //             ? downloadSongScreenController.isLikeDownloadData[widget.index].isLiked ==
//                                 //                     true
//                                 //                 ? downloadSongScreenController
//                                 //                         .isLikeDownloadData[widget.index].isLiked =
//                                 //                     true
//                                 //                 : downloadSongScreenController
//                                 //                         .isLikeDownloadData[widget.index].isLiked =
//                                 //                     false
//                                 //             : (widget.type == 'playlist') &&
//                                 //                     controller
//                                 //                         .playlisSongAudioUrl
//                                 //                         .isNotEmpty
//                                 //                 ? playlistScreenController.isLikePlaylistData[widget.index].isLiked ==
//                                 //                         true
//                                 //                     ? playlistScreenController.isLikePlaylistData[widget.index].isLiked =
//                                 //                         true
//                                 //                     : playlistScreenController
//                                 //                         .isLikePlaylistData[widget.index]
//                                 //                         .isLiked = false
//                                 //                 : widget.type == 'allSongs' && controller.allSongsUrl.isNotEmpty
//                                 //                     ? allSongsScreenController.isLikeAllSongData[widget.index].isLiked == true
//                                 //                         ? allSongsScreenController.isLikeAllSongData[widget.index].isLiked = true
//                                 //                         : allSongsScreenController.isLikeAllSongData[widget.index].isLiked = false
//                                 //                     : widget.type == 'home' && controller.category1AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome1.value == true
//                                 //                         ? widget.categoryData1!.data![widget.index].isLiked! == true
//                                 //                             ? widget.categoryData1!.data![widget.index].isLiked = true
//                                 //                             : widget.categoryData1!.data![widget.index].isLiked = false
//                                 //                         : widget.type == 'home' && controller.category2AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome2.value == true
//                                 //                             ? widget.categoryData2!.data![widget.index].isLiked! == true
//                                 //                                 ? widget.categoryData2!.data![widget.index].isLiked = true
//                                 //                                 : widget.categoryData2!.data![widget.index].isLiked = false
//                                 //                             : widget.type == 'home' && controller.category3AudioUrl.isNotEmpty && controller.isMiniPlayerOpenHome3.value == true
//                                 //                                 ? widget.categoryData3!.data![widget.index].isLiked! == true
//                                 //                                     ? widget.categoryData3!.data![widget.index].isLiked = true
//                                 //                                     : widget.categoryData3!.data![widget.index].isLiked = false

//                                 //                                 // ? homeScreenController.categoryData.value.data![widget.index].isLiked = true
//                                 //                                 : '' == true)
//                                 //     ? AnimatedContainer(
//                                 //         duration:
//                                 //             const Duration(milliseconds: 2000),
//                                 //         curve: Curves.fastEaseInToSlowEaseOut,
//                                 //         height: 55,
//                                 //         width: 55,
//                                 //         child: containerIcon(
//                                 //             icon: Icons.favorite,
//                                 //             iconColor: AppColors.white,
//                                 //             containerColor:
//                                 //                 Colors.red.shade200),
//                                 //       )
//                                 //     : containerIcon(
//                                 //         icon: Icons.favorite,
//                                 //       ),
//                           ),
//                         ),
//                         containerIcon(icon: Icons.shuffle),
//                         InkWell(
//                           onTap: () async {
//                             final prefs = await SharedPreferences.getInstance();
//                             final login = prefs.getBool('isLoggedIn') ?? '';
//                             if (login == true) {
//                               if (kDebugMode) {
//                                 print(downloadProgress);
//                               }
//                               // detailScreenController.songExistsLocally.value == true &&
//                               (categoryData1 == null ||
//                                           categoryData2 == null ||
//                                           categoryData3 == null) ||
//                                       (widget.type == 'queue song'
//                                           ? controller.queueSongsUrl.contains(
//                                                   '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                               true
//                                           : widget.type == 'download song'
//                                               ? controller.downloadSongsUrl.contains(
//                                                       '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                                   true
//                                               : widget.type == 'playlist'
//                                                   ? controller.playlisSongAudioUrl.contains(
//                                                           '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                                       true
//                                                   : widget.type == 'allSongs'
//                                                       ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[widget.index]}.mp3') ==
//                                                           true
//                                                       : widget.type == 'home' &&
//                                                               controller.isMiniPlayerOpenHome1.value ==
//                                                                   true &&
//                                                               controller
//                                                                   .category1AudioUrl
//                                                                   .isNotEmpty
//                                                           ? controller.category1AudioUrl
//                                                                   .contains(
//                                                                       '${AppStrings.localPathMusic}/${categoryData1!.data![widget.index].id}.mp3') ==
//                                                               true
//                                                           : widget.type == 'home' &&
//                                                                   controller.isMiniPlayerOpenHome2.value == true &&
//                                                                   controller.category2AudioUrl.isNotEmpty
//                                                               ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData2!.data![widget.index].id}.mp3') == true
//                                                               : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
//                                                                   ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${categoryData3!.data![widget.index].id}.mp3') == true
//                                                                   // ignore: unrelated_type_equality_checks
//                                                                   : '' == true)
//                                   //         ||
//                                   // (playlistScreenController.allSongsListModel ==
//                                   //     null) ||
//                                   // (downloadSongScreenController.allSongsListModel ==
//                                   //     null) ||
//                                   // (allSongsScreenController.allSongsListModel ==
//                                   //     null) ||
//                                   // (queueSongsScreenController.allSongsListModel ==
//                                   //     null)
//                                   ? null
//                                   : downloadAudio();
//                             } else {
//                               // noLoginBottomSheet();
//                                 Get.to(const WitoutLogginScreen(),transition: Transition.downToUp);
//                             }
//                           },
//                           child: downloading
//                               ? Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 56,
//                                       width: 56,
//                                       child: CircularProgressIndicator(
//                                         value: downloadProgress,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                     Positioned.fill(
//                                       child:
//                                           containerIcon(icon: Icons.download),
//                                     ),
//                                     Positioned.fill(
//                                       bottom: 5,
//                                       child: Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: lable(
//                                           text:
//                                               '${(downloadProgress * 100).toStringAsFixed(0)}%',
//                                           color: AppColors.backgroundColor,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               :
//                               //  Obx(
//                               //     () =>
//                               // detailScreenController.songExistsLocally.value ==
//                               //         true
//                               // categoryData1 == null ||
//                               //         categoryData2 == null ||
//                               //         categoryData3 == null
//                               //     //  || (playlistScreenController.allSongsListModel == null) ||
//                               //     //     (downloadSongScreenController.allSongsListModel == null) ||
//                               //     //     (allSongsScreenController.allSongsListModel == null) ||
//                               //     //     (queueSongsScreenController.allSongsListModel == null)
//                               //     ? Center(
//                               //         child: SizedBox(
//                               //           height: 15,
//                               //           width: 14,
//                               //           child: CircularProgressIndicator(
//                               //             color: AppColors.white,
//                               //             strokeWidth: 2,
//                               //           ),
//                               //         ),
//                               //       )
//                               //     :
//                                   (widget.type == 'queue song'
//                                           ? controller.queueSongsUrl.contains(
//                                                   '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                               true
//                                           : widget.type == 'download song'
//                                               ? controller.downloadSongsUrl.contains(
//                                                       '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                                   true
//                                               : widget.type == 'playlist'
//                                                   ? controller.playlisSongAudioUrl.contains(
//                                                           '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel.value.data![widget.index].id}.mp3') ==
//                                                       true
//                                                   : widget.type == 'allSongs'
//                                                       ? controller.allSongsUrl.contains('${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[widget.index]}.mp3') ==
//                                                           true
//                                                       : widget.type == 'home' &&
//                                                               controller.isMiniPlayerOpenHome1.value ==
//                                                                   true &&
//                                                               controller
//                                                                   .category1AudioUrl
//                                                                   .isNotEmpty
//                                                           ? controller.category1AudioUrl
//                                                                   .contains(
//                                                                       '${AppStrings.localPathMusic}/${widget.categoryData1!.data![widget.index].id}.mp3') ==
//                                                               true
//                                                           : widget.type == 'home' &&
//                                                                   controller.isMiniPlayerOpenHome2.value == true &&
//                                                                   controller.category2AudioUrl.isNotEmpty
//                                                               ? controller.category2AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData2!.data![widget.index].id}.mp3') == true
//                                                               : widget.type == 'home' && controller.isMiniPlayerOpenHome3.value == true && controller.category3AudioUrl.isNotEmpty
//                                                                   ? controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${widget.categoryData3!.data![widget.index].id}.mp3') == true
//                                                                   // ignore: unrelated_type_equality_checks
//                                                                   : '' == true
//                                       // : controller.category3AudioUrl.contains('${AppStrings.localPathMusic}/${homeScreenController.categoryData.value.data![widget.index].id}.mp3') == true
//                                       )
//                                       ? containerIcon(
//                                           icon: Icons.check,
//                                           containerColor: Colors.green,
//                                           iconColor: Colors.white,
//                                         )
//                                       : containerIcon(
//                                           icon: Icons.download,
//                                         ),
//                           // ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   sizeBoxHeight(10),
//                   StreamBuilder<PositionData>(
//                     stream: _positionDataStream,
//                     builder: (context, snapshot) {
//                       final positionData = snapshot.data;
//                       return SeekBar(
//                         isTrackTimeShow: true,
//                         duration: widget.duration != null
//                             ? widget.duration!
//                             : positionData?.duration ?? Duration.zero,
//                         position: positionData?.position ?? Duration.zero,
//                         // widget.position != null
//                         //     ? widget.position!
//                         //     : positionData?.position ?? Duration.zero,
//                         bufferedPosition:
//                             positionData?.bufferedPosition ?? Duration.zero,
//                         //  widget.bufferedPosition != null
//                         //     ? widget.bufferedPosition!
//                         //     : positionData?.bufferedPosition ?? Duration.zero,
//                         onChangeEnd: (newPosition) {
//                           widget.audioPlayer != null
//                               ? (widget.audioPlayer!).seek(newPosition)
//                               : audioPlayer.seek(newPosition);
//                         },
//                         onChanged: (newPosition) {
//                           audioPlayer.seek(newPosition);
//                         },
//                       );
//                     },
//                   ),
//                   sizeBoxHeight(30),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                             onTap: () async {
//                               final prefs =
//                                   await SharedPreferences.getInstance();
//                               final login = prefs.getBool('isLoggedIn') ?? '';
//                               if (login == true) {
//                                 // ignore: use_build_context_synchronously
//                                 addToPlaylist(context);
//                               } else {
//                                 // noLoginBottomSheet();
//                                 Get.to(const WitoutLogginScreen(),transition: Transition.downToUp);

//                               }
//                             },
//                             child: customIcon(
//                               icon: Icons.playlist_add,
//                             )),
//                         customIcon(icon: Icons.skip_previous),
//                         ControlButtons(widget.audioPlayer != null
//                             ? (widget.audioPlayer!)
//                             : audioPlayer),
//                         customIcon(icon: Icons.skip_next),
//                         customIcon(icon: Icons.volume_up),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: h * 0.05,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Stream<PositionData> get _positionDataStream =>
//       rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         widget.positionStream != null
//             ? widget.positionStream!
//             : audioPlayer.positionStream,
//         widget.bufferedPositionStream != null
//             ? widget.bufferedPositionStream!
//             : audioPlayer.bufferedPositionStream,
//         widget.durationStream != null
//             ? widget.durationStream!
//             : audioPlayer.durationStream,
//         (position, bufferedPosition, duration) => PositionData(
//           position,
//           bufferedPosition,
//           duration ?? Duration.zero,
//         ),
//       );

//   addToPlaylist(BuildContext context) {
//     return showModalBottomSheet(
//       backgroundColor: AppColors.backgroundColor,
//       context: context,
//       builder: (context) {
//         return myPlaylistDataModel == null || isLoading == true
//             ? Center(
//                 child: CircularProgressIndicator(
//                 color: AppColors.white,
//               ))
//             : SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Stack(children: [
//                   SizedBox(
//                     height: 400,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 30, vertical: 10),
//                           width: double.infinity,
//                           color: AppColors.white,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               commonIconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                   color: AppColors.backgroundColor,
//                                 ),
//                                 onPressed: () {
//                                   Get.back();
//                                   playlistNameController.text = '';
//                                 },
//                               ),
//                               lable(
//                                 text: AppStrings.addToPlaylist,
//                                 color: AppColors.backgroundColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                         isLoading || myPlaylistDataModel! == null
//                             ? Center(
//                                 child: CircularProgressIndicator(
//                                   color: AppColors.white,
//                                 ),
//                               )
//                             : SizedBox(
//                                 height: 300,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   physics: const BouncingScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: myPlaylistDataModel!.data!.length,
//                                   itemBuilder: (context, index) {
//                                     if (kDebugMode) {
//                                       print(
//                                           "${(myPlaylistDataModel!.data![index].inPlayList)!}");
//                                     }
//                                     return myPlaylistDataModel!
//                                             .data![index].plTitle!.isEmpty
//                                         ? SizedBox(
//                                             height: 300,
//                                             child: Row(
//                                               children: [
//                                                 sizeBoxHeight(30),
//                                                 lable(
//                                                     text: AppStrings
//                                                         .emptyPlaylist,
//                                                     color: Colors.white),
//                                                 Icon(
//                                                   Icons.playlist_add,
//                                                   color: AppColors.white,
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         : Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                             ),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 sizeBoxHeight(20),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     detailScreenController
//                                                         .addSongInPlaylist(
//                                                             playlistId:
//                                                                 (myPlaylistDataModel!
//                                                                     .data![
//                                                                         index]
//                                                                     .id)!,
//                                                             songsId: widget
//                                                                         .type !=
//                                                                     'home'
//                                                                 ? (playlistScreenController
//                                                                     .allSongsListModel!
//                                                                     .data![widget
//                                                                         .index]
//                                                                     .id)!
//                                                                 : (homeScreenController
//                                                                     .categoryData
//                                                                     .value
//                                                                     .data![widget
//                                                                         .index]
//                                                                     .id)!)
//                                                         .then((value) {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                       fetchMyPlaylistData();
//                                                       cheackInMyPlaylistSongAvailable();

//                                                       detailScreenController
//                                                                   .success ==
//                                                               "true"
//                                                           ? snackBar(
//                                                               '${AppStrings.songAddedInPlaylistSuccessfully} ${(myPlaylistDataModel!.data![index].plTitle)!}')
//                                                           : snackBar(
//                                                               (detailScreenController
//                                                                   .message)!);
//                                                     });
//                                                   },
//                                                   child: ListTile(
//                                                       visualDensity:
//                                                           const VisualDensity(
//                                                         horizontal: 0,
//                                                         vertical: -4,
//                                                       ),
//                                                       leading: Icon(
//                                                         Icons.music_note,
//                                                         color: AppColors.white,
//                                                       ),
//                                                       title: lable(
//                                                           text:
//                                                               (myPlaylistDataModel!
//                                                                   .data![index]
//                                                                   .plTitle)!),
//                                                       subtitle: lable(
//                                                         text:
//                                                             "${(myPlaylistDataModel!.data![index].tracks)!} • ${AppStrings.tracks}",
//                                                       ),
//                                                       trailing:
//                                                           (myPlaylistDataModel1!
//                                                                       .data![
//                                                                           index]
//                                                                       .inPlayList)! ==
//                                                                   true
//                                                               ? Icon(
//                                                                   Icons.check,
//                                                                   color:
//                                                                       AppColors
//                                                                           .white,
//                                                                 )
//                                                               : null),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                   },
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                   myPlaylistDataModel!.data!.isEmpty &&
//                           myPlaylistDataModel!.data != null
//                       ? Positioned.fill(
//                           bottom: 10,
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 lable(text: AppStrings.emptyPlaylist),
//                                 Icon(
//                                   Icons.playlist_add,
//                                   color: AppColors.white,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   Positioned.fill(
//                     bottom: 25,
//                     child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: Bounce(
//                         duration: const Duration(milliseconds: 110),
//                         onPressed: () {
//                           Get.back();
//                           createPlaylist();
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.5,
//                           decoration: BoxDecoration(color: AppColors.white),
//                           child: Row(
//                             children: [
//                               commonIconButton(
//                                 icon: const Icon(Icons.add),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               lable(
//                                   text: AppStrings.createPlaylist,
//                                   color: Colors.grey)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ]),
//               );
//       },
//     );
//   }

//   createPlaylist() {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Align(
//               alignment: Alignment.center,
//               child: SingleChildScrollView(
//                 child: AlertDialog(
//                   backgroundColor: AppColors.backgroundColor,
//                   title: lable(
//                       text: AppStrings.addPlaylistName,
//                       fontWeight: FontWeight.w600),
//                   content: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Form(
//                       key: myKey4,
//                       child: SizedBox(
//                         height: 150,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             TextFormField(
//                               style: TextStyle(color: AppColors.white),
//                               controller: playlistNameController,
//                               validator: (value) =>
//                                   AppValidation.validateName(value!),
//                               decoration: InputDecoration(
//                                 hintText: AppStrings.enterPlaylistName,
//                                 hintStyle: TextStyle(
//                                   color: AppColors.white,
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 50,
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (myKey4.currentState!.validate()) {
//                                   snackBar(
//                                       '${playlistNameController.text} ${AppStrings.added}');
//                                   detailScreenController
//                                       .addPlaylist(
//                                           playlistTitle:
//                                               playlistNameController.text)
//                                       .then((value) {
//                                     fetchMyPlaylistData();
//                                     FocusScope.of(context).unfocus();
//                                     Navigator.pop(context);
//                                     // Navigator.pop(context);
//                                     // Get.offAll(DetailScreen(
//                                     //   index: 0,
//                                     //   type: '',
//                                     // ));
//                                   });
//                                   playlistNameController.text = '';
//                                 } else {
//                                   snackBar(AppStrings.enterPlaylistName);
//                                 }
//                               },
//                               child: lable(
//                                   text: AppStrings.addToPlaylist,
//                                   color: AppColors.backgroundColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   noLoginBottomSheet() {
//     // ignore: deprecated_member_use, unused_field
//     return showModalBottomSheet(
//         backgroundColor: const Color(0xFF2a2d36),
//         context: context,
//         builder: (context) {
//           return SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 sizeBoxHeight(60),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: lable(
//                     text: AppStrings.signUpOrLogin,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20,
//                   ),
//                 ),
//                 sizeBoxHeight(15),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: lable(
//                     text: AppStrings.pleaseLoginToUseThisFeature,
//                   ),
//                 ),
//                 sizeBoxHeight(50),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: InkWell(
//                     onTap: () {
//                       Get.offAll(const MobileLoginScreen(),
//                           transition: Transition.downToUp);
//                     },
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF43464d),
//                           ),
//                           child: CountryCodePicker(
//                             onChanged: (CountryCode countryCode) {
//                               setState(() {});
//                             },
//                             initialSelection: 'IN',
//                             textStyle:
//                                 const TextStyle(color: Color(0xFF8e8e94)),
//                             showCountryOnly: false,
//                             showFlag: false,
//                             showOnlyCountryWhenClosed: false,
//                             dialogTextStyle:
//                                 const TextStyle(color: Colors.grey),
//                             dialogBackgroundColor:
//                                 AppColors.backgroundColor.withOpacity(0.9),
//                             barrierColor: Colors.transparent,
//                             alignLeft: false,
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Color(0xFF4c4f56),
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               child: TextFormField(
//                                 maxLength: 10,
//                                 keyboardType: TextInputType.phone,
//                                 // controller: phoneNumber,
//                                 enabled: false,
//                                 autofocus: false,
//                                 validator: (value) =>
//                                     AppValidation.validatePhone(value!),
//                                 onChanged: (value) {
//                                   setState(() {});
//                                 },
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.grey.shade400),
//                                 cursorColor: Colors.grey.shade400,
//                                 decoration: const InputDecoration(
//                                   hintText: AppStrings.continueWithMobileNumber,
//                                   errorText: null,
//                                   counterText: "",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 15,
//                                   ),
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 sizeBoxHeight(50),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         height: 3,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     lable(
//                       text: '  Or  ',
//                       color: Colors.grey.shade400,
//                     ),
//                     Expanded(
//                         child: Divider(
//                       height: 3,
//                       color: Colors.grey.shade600,
//                     )),
//                   ],
//                 ),
//                 sizeBoxHeight(30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     containerIcon(
//                       onTap: () {
//                         googleSignIn();
//                       },
//                       image: Image.asset(
//                         AppAsstes.google,
//                         height: 30,
//                       ),
//                       border: Border.all(color: Colors.orange),
//                       containerColor: AppColors.backgroundColor,
//                       iconColor: AppColors.white,
//                       height: 50,
//                       width: 50,
//                     ),
//                     containerIcon(
//                       onTap: () {
//                         Get.offAll(const LogInScreen(),
//                             transition: Transition.downToUp);
//                       },
//                       icon: Icons.mail_outline_outlined,
//                       border: Border.all(color: Colors.white),
//                       containerColor: AppColors.backgroundColor,
//                       iconColor: AppColors.white,
//                       height: 50,
//                       width: 50,
//                     )
//                   ],
//                 ),
//                 sizeBoxHeight(30),
//               ],
//             ),
//           );
//         });
//   }

//   googleSignIn() async {
//     setState(() {
//       isLoding = true;
//     });
//     if (kDebugMode) {
//       print("googleLogin method Called");
//     }
//     GoogleSignIn googleSignIn = GoogleSignIn();
//     try {
//       var reslut = await googleSignIn.signIn();
//       if (reslut == null) {
//         setState(() {
//           isLoding = false;
//         });
//         return;
//       } else {
//         Get.offAll(MainScreen());
//         setState(() {
//           isLoding = false;
//         });
//         snackBar('Login Succesfully');
//       }
//     } catch (error) {
//       setState(() {
//         isLoding = false;
//       });
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//   }
// }
