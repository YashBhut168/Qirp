import 'dart:developer';
// import 'dart:html';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/add_playlist_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_tab_screens.dart';
import 'package:edpal_music_app_ui/views/tab_screens/all_song_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/my_library_screens.dart';
import 'package:edpal_music_app_ui/views/tab_screens/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  ProfileController profileController = Get.put(ProfileController());

  final apiHelper = ApiHelper();

  bool isLoading = false;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  List<String>? queueSongsUrl;
  List<String>? downloadSongsUrl;
  List<String>? playlisSongAudioUrl;
  List<String>? category1AudioUrl;
  List<String>? category2AudioUrl;
  List<String>? category3AudioUrl;
  List<String>? allSongsAudioUrl;

  // int? currentListTileIndexCategory1;

  

  final AudioPlayer audioPlayer = AudioPlayer();

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('isLoggedIn');
    GlobVar.login = login;
    await prefs.reload();
    bool? isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen');
    log("$isMiniPlayerOpen", name: 'isMiniPlayerOpen');
    int currentListTileIndex = prefs.getInt('currentListTileIndex') ?? 0;
    log("$currentListTileIndex", name: 'currentListTileIndex');
    controller.toggleMiniPlayer(isMiniPlayerOpen  ?? false);
    controller.updateCurrentListTileIndex(currentListTileIndex);
  }

  final List<Widget> screens = [
    const HomeTabScreen(),
    const SearchScreen(),
    const AllSongScreen(myPlaylistId: '', playlistTitle: ''),
    const MyLibraryScreen(),
  ];

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: AppStrings.home,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: AppStrings.search,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.play_arrow_outlined),
      label: AppStrings.forYou,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      label: AppStrings.myLibrary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    sharedPref();
    homeScreenController.recentSongsList();
    profileController.fetchProfile();
      // controller.currentIndex.value = 0;
    setState(() {
      controller.currentListTileIndex.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndexQueueSongs.value;
      controller.isMiniPlayerOpen.value;
      log(controller.isMiniPlayerOpen.value.toString(),
          name: 'isMiniPlayerOpen');
      log(controller.isMiniPlayerOpenHome1.value.toString(),
          name: 'isMiniPlayerOpenHome1');
      log(controller.isMiniPlayerOpenHome2.value.toString(),
          name: 'isMiniPlayerOpenHome2');
      log(controller.isMiniPlayerOpenHome3.value.toString(),
          name: 'isMiniPlayerOpenHome3');
      log(controller.isMiniPlayerOpenAllSongs.value.toString(),
          name: 'isMiniPlayerOpenAllSongs');
      log(controller.currentListTileIndexCategory1.value.toString(),
          name: 'currentListTileIndexCategory1');
      log(controller.currentListTileIndexAllSongs.value.toString(),
          name: 'currentListTileIndexAllSongs');
      log(controller.currentListTileIndexDownloadSongs.value.toString(),
          name: 'currentListTileIndexDownloadSongs');
      log(controller.currentListTileIndexQueueSongs.value.toString(),
          name: 'currentListTileIndexQueueSongs');
          log(GlobVar.playlistId,name: 'playlistId');
          log("${GlobVar.login}",name: 'login');
      //     controller.isMiniPlayerOpenQueueSongs.value == true ||
      //         controller.isMiniPlayerOpenDownloadSongs.value == true ||
      //         controller.isMiniPlayerOpen.value == true ||
      //         controller.isMiniPlayerOpenHome1.value == true ||
      //         controller.isMiniPlayerOpenHome2.value == true ||
      //         controller.isMiniPlayerOpenHome3.value == true ||
      //         controller.isMiniPlayerOpenAllSongs.value == true
      //     ? controller.audioPlayer.play()
      //     : controller.audioPlayer.dispose();
      controller.isMiniPlayerOpenQueueSongs.value == false ||
              controller.isMiniPlayerOpenDownloadSongs.value == false ||
              controller.isMiniPlayerOpen.value == false ||
              controller.isMiniPlayerOpenHome1.value == false ||
              controller.isMiniPlayerOpenHome2.value == false ||
              controller.isMiniPlayerOpenHome3.value == false ||
              controller.isMiniPlayerOpenAllSongs.value == false
          ? controller.audioPlayer.dispose()
          : controller.audioPlayer.play();
      // allSongsScreenController.allSongsList();
      // playlistScreenController.songsInPlaylist(playlistId: '');
      // downloadSongScreenController.downloadSongsList();
      // queueSongsScreenController.queueSongsListWithoutPlaylist();
    });

    // controller.audioPlayer.play();
    // controller.isMiniPlayerOpenAllSongs.value == true
    //     ? allSongsScreenController.allSongsListModel != null
    //     : null;
    // _initAudioPlayer();
    // controller.isMiniPlayerOpen.value == true ? audioPlayer.dispose() : null;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final login = prefs.getBool('isLoggedIn') ?? '';
      if (kDebugMode) {
        print("main:::: $login");
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
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoading = false;
    }
  }


  // ignore: unused_element
  Future<void> _initAudioPlayer() async {
    // final localFilePath = controller.isMiniPlayerOpenDownloadSongs.value == true
    //     ? '${AppStrings.localPathMusic}/${downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].id}.mp3'
    //     : controller.isMiniPlayerOpen.value == true
    //         ? '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].id}.mp3'
    //         : controller.isMiniPlayerOpenAllSongs.value == true
    //             ? '${AppStrings.localPathMusic}/${allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id}.mp3'
    //             : controller.isMiniPlayerOpenHome1.value == true
    //                 ? '${AppStrings.localPathMusic}/${categoryData1!.data![controller.currentListTileIndexCategory1.value].id}.mp3'
    //                 : controller.isMiniPlayerOpenHome2.value == true
    //                     ? '${AppStrings.localPathMusic}/${categoryData2!.data![controller.currentListTileIndexCategory2.value].id}.mp3'
    //                     : controller.isMiniPlayerOpenHome3.value == true
    //                         ? '${AppStrings.localPathMusic}/${categoryData1!.data![controller.currentListTileIndexCategory3.value].id}.mp3'
    //                         : '';
    // final file = File(localFilePath);

    try {
      log('plying with internet.');
      queueSongsUrl = (controller.queueSongsUrl);
      downloadSongsUrl = (controller.downloadSongsUrl);
      playlisSongAudioUrl = (controller.playlisSongAudioUrl);
      category1AudioUrl = (controller.category1AudioUrl);
      category2AudioUrl = (controller.category2AudioUrl);
      category3AudioUrl = (controller.category3AudioUrl);
      allSongsAudioUrl = (controller.allSongsUrl);
      log("$category1AudioUrl", name: 'list');
      log("${controller.currentListTileIndexAllSongs.value}",
          name: 'controller.currentListTileIndexAllSongs.value');
      audioPlayer.currentIndexStream.listen((index) {
        controller.isMiniPlayerOpenQueueSongs.value == true
            ? controller.currentListTileIndexQueueSongs.value = index ?? 0
            : controller.isMiniPlayerOpenDownloadSongs.value == true
                ? controller.currentListTileIndexDownloadSongs.value =
                    index ?? 0
                : controller.isMiniPlayerOpen.value == true
                    ? controller.currentListTileIndex.value = index ?? 0
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? controller.currentListTileIndexCategory1.value =
                            index ?? 0
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? controller.currentListTileIndexCategory2.value =
                                index ?? 0
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? controller.currentListTileIndexCategory3
                                    .value = index ?? 0
                                : controller.isMiniPlayerOpenAllSongs.value ==
                                        true
                                    //  &&
                                    //         allSongsScreenController.allSongsListModel != null
                                    ? controller.currentListTileIndexAllSongs
                                        .value = index ?? 0
                                    : null;
      });
      MediaItem mediaItem = MediaItem(
        id: controller.isMiniPlayerOpenQueueSongs.value == true &&
                queueSongsScreenController.allSongsListModel != null
            ? (queueSongsScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexQueueSongs.value]
                    .id) ??
                ''
            : controller.isMiniPlayerOpenDownloadSongs.value == true &&
                    downloadSongScreenController.allSongsListModel != null
                ? (downloadSongScreenController
                        .allSongsListModel!
                        .data![
                            controller.currentListTileIndexDownloadSongs.value]
                        .id) ??
                    ''
                : controller.isMiniPlayerOpen.value == true &&
                        playlistScreenController.allSongsListModel != null
                    ? (playlistScreenController.allSongsListModel!
                            .data![controller.currentListTileIndex.value].id) ??
                        ''
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? (categoryData1!
                            .data![
                                controller.currentListTileIndexCategory1.value]
                            .id)!
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? (categoryData2!
                                .data![controller
                                    .currentListTileIndexCategory2.value]
                                .id)!
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? (categoryData3!
                                    .data![controller
                                        .currentListTileIndexCategory3.value]
                                    .id)!
                                : controller.isMiniPlayerOpenAllSongs.value == true
                                    ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id)!
                                    : '',
        title: controller.isMiniPlayerOpenQueueSongs.value == true
            ? (queueSongsScreenController.allSongsListModel!
                .data![controller.currentListTileIndexQueueSongs.value].title)!
            : controller.isMiniPlayerOpenDownloadSongs.value == true
                ? (downloadSongScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexDownloadSongs.value]
                    .title)!
                : controller.isMiniPlayerOpen.value == true
                    ? (playlistScreenController.allSongsListModel!
                        .data![controller.currentListTileIndex.value].title)!
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? (categoryData1!
                            .data![
                                controller.currentListTileIndexCategory1.value]
                            .title)!
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? (categoryData2!
                                .data![controller
                                    .currentListTileIndexCategory2.value]
                                .title)!
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? (categoryData3!
                                    .data![controller
                                        .currentListTileIndexCategory3.value]
                                    .title)!
                                : controller.isMiniPlayerOpenAllSongs.value ==
                                        true
                                    ? (allSongsScreenController
                                        .allSongsListModel!
                                        .data![controller
                                            .currentListTileIndexAllSongs.value]
                                        .title)!
                                    : '',
        album: controller.isMiniPlayerOpenQueueSongs.value == true
            ? (queueSongsScreenController
                .allSongsListModel!
                .data![controller.currentListTileIndexQueueSongs.value]
                .description)!
            : controller.isMiniPlayerOpenDownloadSongs.value == true
                ? (downloadSongScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexDownloadSongs.value]
                    .description)!
                : controller.isMiniPlayerOpen.value == true
                    ? (playlistScreenController
                        .allSongsListModel!
                        .data![controller.currentListTileIndex.value]
                        .description)!
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? (categoryData1!
                            .data![
                                controller.currentListTileIndexCategory1.value]
                            .description)!
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? (categoryData2!
                                .data![controller
                                    .currentListTileIndexCategory2.value]
                                .description)!
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? (categoryData3!
                                    .data![controller
                                        .currentListTileIndexCategory3.value]
                                    .description)!
                                : controller.isMiniPlayerOpenAllSongs.value ==
                                        true
                                    ? (allSongsScreenController
                                        .allSongsListModel!
                                        .data![controller
                                            .currentListTileIndexAllSongs.value]
                                        .description)!
                                    : '',
        artUri: Uri.parse(controller.isMiniPlayerOpenQueueSongs.value == true
            ? (queueSongsScreenController.allSongsListModel!
                .data![controller.currentListTileIndexQueueSongs.value].image)!
            : controller.isMiniPlayerOpenDownloadSongs.value == true
                ? (downloadSongScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexDownloadSongs.value]
                    .image)!
                : controller.isMiniPlayerOpen.value == true
                    ? (playlistScreenController.allSongsListModel!
                        .data![controller.currentListTileIndex.value].image)!
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? (categoryData1!
                            .data![
                                controller.currentListTileIndexCategory1.value]
                            .image)!
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? (categoryData2!
                                .data![controller
                                    .currentListTileIndexCategory2.value]
                                .image)!
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? (categoryData3!
                                    .data![controller
                                        .currentListTileIndexCategory3.value]
                                    .image)!
                                : controller.isMiniPlayerOpenAllSongs.value ==
                                        true
                                    ? (allSongsScreenController
                                        .allSongsListModel!
                                        .data![controller
                                            .currentListTileIndexAllSongs.value]
                                        .image)!
                                    : ''),
        duration: const Duration(milliseconds: 0),
        // duration: Duration(
        //   milliseconds:
        //    controller.isMiniPlayerOpenQueueSongs.value == true
        //       ? (int.parse(queueSongsScreenController
        //               .allSongsListModel!
        //               .data![controller.currentListTileIndexQueueSongs.value]
        //               .duration ??
        //           '0'))
        //       :
        //    controller.isMiniPlayerOpenDownloadSongs.value == true
        //       ? (int.parse(downloadSongScreenController
        //               .allSongsListModel!
        //               .data![controller.currentListTileIndexDownloadSongs.value]
        //               .duration ??
        //           '0'))
        //       : controller.isMiniPlayerOpen.value == true
        //           ? (int.parse(playlistScreenController
        //                   .allSongsListModel!
        //                   .data![controller.currentListTileIndex.value]
        //                   .duration ??
        //               '0'))
        //           : controller.isMiniPlayerOpenHome1.value == true
        //               ? int.parse((categoryData1!
        //                       .data![controller
        //                           .currentListTileIndexCategory1.value]
        //                       .duration ??
        //                   '0'))
        //               : controller.isMiniPlayerOpenHome2.value == true
        //                   ? int.parse((categoryData2!
        //                           .data![controller.currentListTileIndexCategory2.value]
        //                           .duration) ??
        //                       '0')
        //                   : controller.isMiniPlayerOpenHome3.value == true
        //                       ? int.parse((categoryData3!.data![controller.currentListTileIndexCategory3.value].duration ?? '0'))
        //                       : controller.isMiniPlayerOpenAllSongs.value == true
        //                           ? int.parse((allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].duration ?? '0'))
        //                           : 0,
        // ),
      );
      // audioPlayer.setAudioSource(
      //   ConcatenatingAudioSource(
      //     useLazyPreparation: true,
      //     shuffleOrder: DefaultShuffleOrder(),
      //     children: controller.isMiniPlayerOpenDownloadSongs.value == true
      //         ? downloadSongsUrl!
      //             .map(
      //               (url) => AudioSource.uri(
      //                 Uri.parse(url),
      //                 tag: mediaItem,
      //                 //  MediaItem(
      //                 //   id: (downloadSongScreenController
      //                 //           .allSongsListModel!
      //                 //           .data![controller
      //                 //               .currentListTileIndexDownloadSongs.value]
      //                 //           .id) ??
      //                 //       '',
      //                 //   title: (downloadSongScreenController
      //                 //       .allSongsListModel!
      //                 //       .data![controller
      //                 //           .currentListTileIndexDownloadSongs.value]
      //                 //       .title)!,
      //                 //   album: (downloadSongScreenController
      //                 //       .allSongsListModel!
      //                 //       .data![controller
      //                 //           .currentListTileIndexDownloadSongs.value]
      //                 //       .description)!,
      //                 //   artUri: Uri.parse((downloadSongScreenController
      //                 //       .allSongsListModel!
      //                 //       .data![controller
      //                 //           .currentListTileIndexDownloadSongs.value]
      //                 //       .image)!),
      //                 // ),
      //               ),
      //             )
      //             .toList()
      //         : controller.isMiniPlayerOpen.value == true
      //             ? playlisSongAudioUrl!
      //                 .map(
      //                   (url) => AudioSource.uri(
      //                     Uri.parse(url),
      //                     tag: mediaItem,

      //                     //  MediaItem(
      //                     //   id: (playlistScreenController
      //                     //           .allSongsListModel!
      //                     //           .data![
      //                     //               controller.currentListTileIndex.value]
      //                     //           .id) ??
      //                     //       '',
      //                     //   title: (playlistScreenController
      //                     //       .allSongsListModel!
      //                     //       .data![controller.currentListTileIndex.value]
      //                     //       .title)!,
      //                     //   album: (playlistScreenController
      //                     //       .allSongsListModel!
      //                     //       .data![controller.currentListTileIndex.value]
      //                     //       .description)!,
      //                     //   artUri: Uri.parse((playlistScreenController
      //                     //       .allSongsListModel!
      //                     //       .data![controller.currentListTileIndex.value]
      //                     //       .image)!),
      //                     // ),
      //                   ),
      //                 )
      //                 .toList()
      //             : controller.isMiniPlayerOpenHome1.value == true
      //                 ? category1AudioUrl!
      //                     .map(
      //                       (url) => AudioSource.uri(
      //                         Uri.parse(url),
      //                         tag: mediaItem,
      //                         //  MediaItem(
      //                         //   id: (categoryData1!
      //                         //       .data![controller
      //                         //           .currentListTileIndexCategory1.value]
      //                         //       .id)!,
      //                         //   title: (categoryData1!
      //                         //       .data![controller
      //                         //           .currentListTileIndexCategory1.value]
      //                         //       .title)!,
      //                         //   album: (categoryData1!
      //                         //       .data![controller
      //                         //           .currentListTileIndexCategory1.value]
      //                         //       .description)!,
      //                         //   artUri: Uri.parse((categoryData1!
      //                         //       .data![controller
      //                         //           .currentListTileIndexCategory1.value]
      //                         //       .image)!),
      //                         // ),
      //                       ),
      //                     )
      //                     .toList()
      //                 : controller.isMiniPlayerOpenHome2.value == true
      //                     ? category2AudioUrl!
      //                         .map((url) => AudioSource.uri(
      //                               Uri.parse(url),
      //                               tag: mediaItem,
      //                               //  MediaItem(
      //                               //   id: (categoryData2!
      //                               //       .data![controller
      //                               //           .currentListTileIndexCategory2
      //                               //           .value]
      //                               //       .id)!,
      //                               //   title: (categoryData2!
      //                               //       .data![controller
      //                               //           .currentListTileIndexCategory2
      //                               //           .value]
      //                               //       .title)!,
      //                               //   album: (categoryData2!
      //                               //       .data![controller
      //                               //           .currentListTileIndexCategory2
      //                               //           .value]
      //                               //       .description)!,
      //                               //   artUri: Uri.parse((categoryData2!
      //                               //       .data![controller
      //                               //           .currentListTileIndexCategory2
      //                               //           .value]
      //                               //       .image)!),
      //                               // ),
      //                             ))
      //                         .toList()
      //                     : controller.isMiniPlayerOpenHome3.value == true
      //                         ? category3AudioUrl!
      //                             .map(
      //                               (url) => AudioSource.uri(
      //                                 Uri.parse(url),
      //                                 tag: mediaItem,
      //                                 // MediaItem(
      //                                 //   id: (categoryData3!
      //                                 //       .data![controller
      //                                 //           .currentListTileIndexCategory3
      //                                 //           .value]
      //                                 //       .id)!,
      //                                 //   title: (categoryData3!
      //                                 //       .data![controller
      //                                 //           .currentListTileIndexCategory3
      //                                 //           .value]
      //                                 //       .title)!,
      //                                 //   album: (categoryData3!
      //                                 //       .data![controller
      //                                 //           .currentListTileIndexCategory3
      //                                 //           .value]
      //                                 //       .description)!,
      //                                 //   artUri: Uri.parse((categoryData3!
      //                                 //       .data![controller
      //                                 //           .currentListTileIndexCategory3
      //                                 //           .value]
      //                                 //       .image)!),
      //                                 // ),
      //                               ),
      //                             )
      //                             .toList()
      //                         : controller.isMiniPlayerOpenAllSongs.value ==
      //                                 true
      //                             ? allSongsAudioUrl!
      //                                 .map(
      //                                   (url) => AudioSource.uri(
      //                                     Uri.parse(url),
      //                                     tag: mediaItem,
      //                                     //  MediaItem(
      //                                     //   id: (allSongsScreenController
      //                                     //       .allSongsListModel!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexAllSongs
      //                                     //           .value]
      //                                     //       .id)!,
      //                                     //   title: (allSongsScreenController
      //                                     //       .allSongsListModel!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexAllSongs
      //                                     //           .value]
      //                                     //       .title)!,
      //                                     //   album: (allSongsScreenController
      //                                     //       .allSongsListModel!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexAllSongs
      //                                     //           .value]
      //                                     //       .description)!,
      //                                     //   artUri: Uri.parse(
      //                                     //       (allSongsScreenController
      //                                     //           .allSongsListModel!
      //                                     //           .data![controller
      //                                     //               .currentListTileIndexAllSongs
      //                                     //               .value]
      //                                     //           .image)!),
      //                                     // ),
      //                                   ),
      //                                 )
      //                                 .toList()
      //                             : category1AudioUrl!
      //                                 .map(
      //                                   (url) => AudioSource.uri(
      //                                     Uri.parse(url),
      //                                     tag: mediaItem,
      //                                     // MediaItem(
      //                                     //   id: (categoryData1!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexCategory1
      //                                     //           .value]
      //                                     //       .id)!,
      //                                     //   title: (categoryData1!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexCategory1
      //                                     //           .value]
      //                                     //       .title)!,
      //                                     //   album: (categoryData1!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexCategory1
      //                                     //           .value]
      //                                     //       .description)!,
      //                                     //   artUri: Uri.parse((categoryData1!
      //                                     //       .data![controller
      //                                     //           .currentListTileIndexCategory1
      //                                     //           .value]
      //                                     //       .image)!),
      //                                     // ),
      //                                   ),
      //                                 )
      //                                 .toList(),
      //   ),
      //   initialIndex: controller.isMiniPlayerOpenDownloadSongs.value == true
      //       ? controller.currentListTileIndexDownloadSongs.value
      //       : controller.isMiniPlayerOpen.value == true
      //           ? controller.currentListTileIndex.value
      //           : controller.isMiniPlayerOpenHome1.value == true
      //               ? controller.currentListTileIndexCategory1.value
      //               : controller.isMiniPlayerOpenHome2.value == true
      //                   ? controller.currentListTileIndexCategory2.value
      //                   : controller.isMiniPlayerOpenHome3.value == true
      //                       ? controller.currentListTileIndexCategory3.value
      //                       : controller.isMiniPlayerOpenAllSongs.value == true
      //                           ? controller.currentListTileIndexAllSongs.value
      //                           : null,
      //   preload: false,
      //   initialPosition: Duration.zero,
      // );

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: controller.isMiniPlayerOpenQueueSongs.value == true
              ? queueSongsUrl!
                  .map(
                    (url) => AudioSource.uri(
                      Uri.parse(url),
                      tag: mediaItem,
                    ),
                  )
                  .toList()
              : controller.isMiniPlayerOpenDownloadSongs.value == true
                  ? downloadSongsUrl!
                      .map(
                        (url) => AudioSource.uri(
                          Uri.parse(url),
                          tag: mediaItem,
                        ),
                      )
                      .toList()
                  : controller.isMiniPlayerOpen.value == true
                      ? playlisSongAudioUrl!
                          .map(
                            (url) => AudioSource.uri(
                              Uri.parse(url),
                              tag: mediaItem,
                            ),
                          )
                          .toList()
                      : controller.isMiniPlayerOpenHome1.value == true
                          ? category1AudioUrl!
                              .map(
                                (url) => AudioSource.uri(
                                  Uri.parse(url),
                                  tag: mediaItem,
                                ),
                              )
                              .toList()
                          : controller.isMiniPlayerOpenHome2.value == true
                              ? category2AudioUrl!
                                  .map(
                                    (url) => AudioSource.uri(
                                      Uri.parse(url),
                                      tag: mediaItem,
                                    ),
                                  )
                                  .toList()
                              : controller.isMiniPlayerOpenHome3.value == true
                                  ? category3AudioUrl!
                                      .map(
                                        (url) => AudioSource.uri(
                                          Uri.parse(url),
                                          tag: mediaItem,
                                        ),
                                      )
                                      .toList()
                                  : controller.isMiniPlayerOpenAllSongs.value ==
                                          true
                                      ? allSongsAudioUrl!
                                          .map(
                                            (url) => AudioSource.uri(
                                              Uri.parse(url),
                                              tag: mediaItem,
                                            ),
                                          )
                                          .toList()
                                      : category1AudioUrl!
                                          .map(
                                            (url) => AudioSource.uri(
                                              Uri.parse(url),
                                              tag: mediaItem,
                                            ),
                                          )
                                          .toList(),
        ),
        // AudioSource.uri(

        //   Uri.parse(category1AudioUrl![
        //       controller.currentListTileIndexCategory1.value]),
        //   tag: mediaItem,
        // ),
        initialIndex: controller.isMiniPlayerOpenQueueSongs.value == true
            ? controller.currentListTileIndexQueueSongs.value
            : controller.isMiniPlayerOpenDownloadSongs.value == true
                ? controller.currentListTileIndexDownloadSongs.value
                : controller.isMiniPlayerOpen.value == true
                    ? controller.currentListTileIndex.value
                    : controller.isMiniPlayerOpenHome1.value == true
                        ? controller.currentListTileIndexCategory1.value
                        : controller.isMiniPlayerOpenHome2.value == true
                            ? controller.currentListTileIndexCategory2.value
                            : controller.isMiniPlayerOpenHome3.value == true
                                ? controller.currentListTileIndexCategory3.value
                                : controller.isMiniPlayerOpenAllSongs.value ==
                                        true
                                    ? controller
                                        .currentListTileIndexAllSongs.value
                                    : null,
        preload: false,
        initialPosition: Duration.zero,
      );

      homeScreenController
          .addRecentSongs(
        musicId: (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                (controller.isMiniPlayerOpen.value) == false &&
                (controller.isMiniPlayerOpenHome1.value) == false &&
                (controller.isMiniPlayerOpenHome2.value) == false &&
                (controller.isMiniPlayerOpenHome3.value) == false &&
                (controller.isMiniPlayerOpenAllSongs.value) == false &&
                (controller.isMiniPlayerOpenQueueSongs.value) == true
            ? (queueSongsScreenController.allSongsListModel!
                .data![controller.currentListTileIndexQueueSongs.value].id)!
            : (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
                    (controller.isMiniPlayerOpen.value) == false &&
                    (controller.isMiniPlayerOpenHome1.value) == false &&
                    (controller.isMiniPlayerOpenHome2.value) == false &&
                    (controller.isMiniPlayerOpenHome3.value) == false &&
                    (controller.isMiniPlayerOpenAllSongs.value) == false &&
                    (controller.isMiniPlayerOpenQueueSongs.value) == false
                ? (downloadSongScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexDownloadSongs.value]
                    .id)!
                : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                        (controller.isMiniPlayerOpen.value) == true &&
                        (controller.isMiniPlayerOpenHome1.value) == false &&
                        (controller.isMiniPlayerOpenHome2.value) == false &&
                        (controller.isMiniPlayerOpenHome3.value) == false &&
                        (controller.isMiniPlayerOpenAllSongs.value) == false &&
                        (controller.isMiniPlayerOpenQueueSongs.value) == false
                    ? (playlistScreenController.allSongsListModel!
                        .data![controller.currentListTileIndex.value].id)!
                    : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                            (controller.isMiniPlayerOpenHome1.value) == true &&
                            (controller.isMiniPlayerOpen.value) == false &&
                            (controller.isMiniPlayerOpenHome2.value) == false &&
                            (controller.isMiniPlayerOpenHome3.value) == false &&
                            (controller.isMiniPlayerOpenAllSongs.value) ==
                                false &&
                            (controller.isMiniPlayerOpenQueueSongs.value) ==
                                false
                        ? (categoryData1!
                            .data![
                                controller.currentListTileIndexCategory1.value]
                            .id)!
                        : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                (controller.isMiniPlayerOpenHome1.value) ==
                                    false &&
                                (controller.isMiniPlayerOpen.value) == false &&
                                (controller.isMiniPlayerOpenHome2.value) ==
                                    true &&
                                (controller.isMiniPlayerOpenHome3.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenAllSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenQueueSongs.value) ==
                                    false
                            ? (categoryData2!
                                .data![controller
                                    .currentListTileIndexCategory2.value]
                                .id)!
                            : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                    (controller.isMiniPlayerOpen.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome1.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome2.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome3.value) ==
                                        true &&
                                    (controller.isMiniPlayerOpenAllSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenQueueSongs.value) ==
                                        false
                                ? (categoryData3!
                                    .data![controller
                                        .currentListTileIndexCategory3.value]
                                    .id)!
                                : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                        (controller.isMiniPlayerOpen.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome1.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome2.value) == false &&
                                        (controller.isMiniPlayerOpenHome3.value) == false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) == true &&
                                        (controller.isMiniPlayerOpenQueueSongs.value) == false
                                    ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id)!
                                    : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id)!,
      )
          .then((value) {
        homeScreenController.recentSongsList();
      });
      (controller.isMiniPlayerOpenQueueSongs.value) == true &&
              (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
              (controller.isMiniPlayerOpen.value) == false &&
              (controller.isMiniPlayerOpenHome1.value) == false &&
              (controller.isMiniPlayerOpenHome2.value) == false &&
              (controller.isMiniPlayerOpenHome3.value) == false &&
              (controller.isMiniPlayerOpenAllSongs.value) == false &&
              controller.queueSongsUrl.isNotEmpty
          ? await controller.audioPlayer.setLoopMode(LoopMode.all)
          : await controller.audioPlayer.setLoopMode(LoopMode.off);
          controller.audioPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing audio player: $e');
      }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   audioPlayer.stop();
  // }

  @override
  Widget build(BuildContext context) {
    log(controller.currentListTileIndexCategory1.value.toString(),
        name: 'main currentListTileIndexCategory1');
    log(controller.currentListTileIndexCategory2.value.toString(),
        name: 'main currentListTileIndexCategory2');
    log(controller.currentListTileIndexCategory3.value.toString(),
        name: 'main currentListTileIndexCategory3');
    log(controller.currentListTileIndexAllSongs.value.toString(),
        name: 'main currentListTileIndexAllSongs');
    log(controller.currentListTileIndexDownloadSongs.value.toString(),
        name: 'main currentListTileIndexDownloadSongs');
    log(controller.currentListTileIndexQueueSongs.value.toString(),
        name: 'main currentListTileIndexQueueSongs');
    controller.setAudioPlayer(audioPlayer);
    var systemOverlayStyle = const SystemUiOverlayStyle(systemNavigationBarColor: AppColors.bottomNavColor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:  systemOverlayStyle,
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
            // children: screens[controller.currentIndex.value],
          )
          //
          ,
        ),
        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (controller.isMiniPlayerOpenQueueSongs.value) == true &&
                      queueSongsScreenController.allSongsListModel != null
                  // &&
                  // (controller.isMiniPlayerOpenHome1.value) == false
                  ? BottomAppBar(
                      elevation: 0,
                      height: 60,
                      padding: EdgeInsets.zero,
                      clipBehavior: Clip.none,
                      color: AppColors.bottomNavColor,
                      child: miniplayer())
                  : (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
                          downloadSongScreenController.allSongsListModel != null
                      // &&
                      // (controller.isMiniPlayerOpenHome1.value) == false
                      ? BottomAppBar(
                          elevation: 0,
                          height: 60,
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.none,
                          color: AppColors.bottomNavColor,
                          child: miniplayer())
                      : (controller.isMiniPlayerOpen.value) == true &&
                              playlistScreenController.allSongsListModel != null
                          // &&
                          // (controller.isMiniPlayerOpenHome1.value) == false
                          ? BottomAppBar(
                              elevation: 0,
                              height: 60,
                              padding: EdgeInsets.zero,
                              clipBehavior: Clip.none,
                              color: AppColors.bottomNavColor,
                              child: miniplayer())
                          : (controller.isMiniPlayerOpenHome1.value) == true &&
                                  categoryData1 != null
                              ? BottomAppBar(
                                  elevation: 0,
                                  height: 60,
                                  padding: EdgeInsets.zero,
                                  clipBehavior: Clip.none,
                                  color: AppColors.bottomNavColor,
                                  child: miniplayer())
                              : (controller.isMiniPlayerOpenHome2.value) ==
                                          true &&
                                      categoryData2 != null
                                  ? BottomAppBar(
                                      elevation: 0,
                                      height: 60,
                                      padding: EdgeInsets.zero,
                                      clipBehavior: Clip.none,
                                      color: AppColors.bottomNavColor,
                                      child: miniplayer())
                                  : (controller.isMiniPlayerOpenHome3.value) ==
                                              true &&
                                          categoryData3 != null
                                      ? BottomAppBar(
                                          elevation: 0,
                                          height: 60,
                                          padding: EdgeInsets.zero,
                                          clipBehavior: Clip.none,
                                          color: AppColors.bottomNavColor,
                                          child: miniplayer())
                                      : (controller.isMiniPlayerOpenAllSongs
                                                      .value) ==
                                                  true &&
                                              allSongsScreenController
                                                      .allSongsListModel!.data !=
                                                  null
                                          ? BottomAppBar(
                                              elevation: 0,
                                              height: 60,
                                              padding: EdgeInsets.zero,
                                              clipBehavior: Clip.none,
                                              color: AppColors.bottomNavColor,
                                              child: miniplayer())
                                          : const SizedBox(),
              const Divider(color: AppColors.bottomDividerColor,height: 1),
              BottomNavigationBar(
                items: bottomNavBarItems,
                currentIndex: controller.currentIndex.value,
                backgroundColor: AppColors.bottomNavColor,
                selectedIconTheme: const IconThemeData(size: 30),
                unselectedIconTheme: const IconThemeData(size: 30),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
                onTap: controller.changeTab,
                selectedItemColor: AppColors.white,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Miniplayer miniplayer() {
    return Miniplayer(
      minHeight: 60,
      maxHeight: 60,
      backgroundColor: AppColors.bottomNavColor,
      builder: (height, percentage) {
        // _initAudioPlayer();
        // controller.initAudioPlayer();
        return GestureDetector(
          onTap: () async {
            Duration? duration;
            Duration? position;
            Duration? bufferedPosition;

            final positionData = await _positionDataStream.first;

            duration = positionData.duration;
            position = positionData.position;
            bufferedPosition = positionData.bufferedPosition;

            if (kDebugMode) {
              log("$duration", name: 'duration');
              log("$position", name: 'position');
              log("$bufferedPosition", name: 'bufferedPosition');
              log("${(durationStream)}", name: 'durationStream');
              log("${(positionStream)}", name: 'positionStream');
              log("${(bufferedPositionStream)}",
                  name: 'bufferedPositionStream');
            }

            Get.to(
                DetailScreen(
                  index: controller.isMiniPlayerOpenQueueSongs.value == true
                      ? controller.currentListTileIndexQueueSongs.value
                      : controller.isMiniPlayerOpenDownloadSongs.value == true
                          ? controller.currentListTileIndexDownloadSongs.value
                          : controller.isMiniPlayerOpen.value == true
                              ? controller.currentListTileIndex.value
                              : controller.isMiniPlayerOpenHome1.value == true
                                  ? controller
                                      .currentListTileIndexCategory1.value
                                  : controller.isMiniPlayerOpenHome2.value ==
                                          true
                                      ? controller
                                          .currentListTileIndexCategory2.value
                                      : controller.isMiniPlayerOpenHome3
                                                  .value ==
                                              true
                                          ? controller
                                              .currentListTileIndexCategory3
                                              .value
                                          : controller.isMiniPlayerOpenAllSongs
                                                      .value ==
                                                  true
                                              ? controller
                                                  .currentListTileIndexAllSongs
                                                  .value
                                              : controller
                                                  .currentListTileIndex.value,
                  type: controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true
                      ? 'home'
                      : controller.isMiniPlayerOpenAllSongs.value == true
                          ? 'allSongs'
                          : controller.isMiniPlayerOpen.value == true
                              ? 'playlist'
                              : controller.isMiniPlayerOpenDownloadSongs
                                          .value ==
                                      true
                                  ? 'download song'
                                  : controller.isMiniPlayerOpenQueueSongs
                                              .value ==
                                          true
                                      ? 'queue song'
                                      : '',
                  duration: duration,
                  position: position,
                  bufferedPosition: bufferedPosition,
                  durationStream: durationStream!,
                  positionStream: positionStream!,
                  bufferedPositionStream: bufferedPositionStream!,
                  audioPlayer: controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true ||
                          controller.isMiniPlayerOpenAllSongs.value == true ||
                          controller.isMiniPlayerOpen.value == true ||
                          controller.isMiniPlayerOpenDownloadSongs.value ==
                              true ||
                          controller.isMiniPlayerOpenQueueSongs.value == true
                      ? controller.audioPlayer
                      : controller.audioPlayer,
                  categoryData1:  categoryData1,
                  categoryData2:  categoryData2,
                  categoryData3:  categoryData3,
                ),
                transition: Transition.downToUp,
                duration: const Duration(milliseconds: 600));
          },
          child: Container(
            color: AppColors.bottomNavColor,
            height: 60,
            width: Get.width,
            child: Row(
              children: [
                Obx(
                  () => SizedBox(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        queueSongsScreenController.allSongsListModel != null &&
                                (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpen.value) == false &&
                                (controller.isMiniPlayerOpenHome1.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenHome2.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenHome3.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenAllSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenQueueSongs.value) ==
                                    true
                            ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ??
                                'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : downloadSongScreenController.allSongsListModel != null &&
                                    (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                        true &&
                                    (controller.isMiniPlayerOpen.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome1.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome2.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome3.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenAllSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenQueueSongs.value) ==
                                        false
                                ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : playlistScreenController.allSongsListModel != null &&
                                        (controller.isMiniPlayerOpen.value) ==
                                            true &&
                                        (controller
                                                .isMiniPlayerOpenDownloadSongs
                                                .value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome1.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome2.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome3.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenQueueSongs.value) ==
                                            false
                                    ?
                                    // playlistScreenController.queueAudioUrls.isNotEmpty &&
                                    //           (playlistScreenController.queueAudioUrls[
                                    //                   controller.currentListTileIndex.value] ==
                                    //               (playlistScreenController
                                    //                   .allSongsListModel!
                                    //                   .data![controller.currentListTileIndex.value]
                                    //                   .audio)!)
                                    //       ? (playlistScreenController.allSongsListModel!.data![playlistScreenController.index.value].image)!
                                    //       :
                                    playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                    : categoryData1 != null &&
                                            (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                            (controller.isMiniPlayerOpen.value) == false &&
                                            (controller.isMiniPlayerOpenHome1.value) == true &&
                                            (controller.isMiniPlayerOpenHome2.value) == false &&
                                            (controller.isMiniPlayerOpenHome3.value) == false &&
                                            (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                            (controller.isMiniPlayerOpenQueueSongs.value) == false
                                        ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : categoryData2 != null && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                            ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : categoryData3 != null && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                    ? allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    : '',
                        height: 60,
                        width: 60,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                sizeBoxWidth(8),
                Obx(
                  () => SizedBox(
                    width: Get.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        lable(
                          text: (controller.isMiniPlayerOpenQueueSongs.value) == true &&
                                  (controller.isMiniPlayerOpen.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome1.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome2.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                      false
                              ? (queueSongsScreenController
                                  .allSongsListModel!
                                  .data![controller
                                      .currentListTileIndexQueueSongs.value]
                                  .title)!
                              : (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false
                                  ? (downloadSongScreenController
                                      .allSongsListModel!
                                      .data![controller
                                          .currentListTileIndexDownloadSongs
                                          .value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpen.value) == true &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) == false
                                      ? (playlistScreenController.playlistSongAudioUrls[controller.currentListTileIndex.value] == playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].audio)
                                          ? (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                          :
                                          // playlistScreenController.queueAudioUrls.isNotEmpty &&
                                          //         (playlistScreenController.queueAudioUrls[
                                          //                 playlistScreenController
                                          //                     .index.value] ==
                                          //             (playlistScreenController
                                          //                 .allSongsListModel!
                                          //                 .data![controller.currentListTileIndex.value]
                                          //                 .audio)!)
                                          //     ? (playlistScreenController.allSongsListModel!.data![playlistScreenController.index.value].title)!
                                          //     :
                                          (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                      : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                          : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                              : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                                  : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                      ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                      : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: (controller.isMiniPlayerOpenQueueSongs.value) == true &&
                                  (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpen.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome1.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome2.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false
                              ? (queueSongsScreenController
                                  .allSongsListModel!
                                  .data![controller
                                      .currentListTileIndexQueueSongs.value]
                                  .description)!
                              : (controller.isMiniPlayerOpenQueueSongs.value) == false &&
                                      (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (downloadSongScreenController
                                      .allSongsListModel!
                                      .data![controller
                                          .currentListTileIndexDownloadSongs
                                          .value]
                                      .description)!
                                  : (controller.isMiniPlayerOpenQueueSongs.value) == false &&
                                          (controller
                                                  .isMiniPlayerOpenDownloadSongs
                                                  .value) ==
                                              false &&
                                          (controller.isMiniPlayerOpen.value) == true &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ?
                                      // playlistScreenController.queueAudioUrls.isNotEmpty &&
                                      //         (playlistScreenController.queueAudioUrls[
                                      //                 playlistScreenController
                                      //                     .index.value] ==
                                      //             (playlistScreenController
                                      //                 .allSongsListModel!
                                      //                 .data![controller.currentListTileIndex.value]
                                      //                 .audio)!)
                                      //     ? (playlistScreenController.allSongsListModel!.data![playlistScreenController.index.value].description)!
                                      //     :
                                      (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
                                      : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                          : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                              : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
                                                  : (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                      ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].description)!
                                                      : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].description)!,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                sizeBoxWidth(6),
                ControlButtons(
                    (controller.isMiniPlayerOpenDownloadSongs.value) == true ||
                            (controller.isMiniPlayerOpen.value) == true ||
                            (controller.isMiniPlayerOpenHome1.value) == true ||
                            (controller.isMiniPlayerOpenHome2.value) == true ||
                            (controller.isMiniPlayerOpenHome3.value) == true ||
                            (controller.isMiniPlayerOpenAllSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenQueueSongs.value) ==
                                true
                        ? controller.audioPlayer
                        : controller.audioPlayer,
                    size: 45),
              ],
            ),
          ),
        );
      },
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  Stream<Duration>? positionStream;
  // ignore: prefer_typing_uninitialized_variables
  Stream<Duration>? bufferedPositionStream;
  // ignore: prefer_typing_uninitialized_variables
  Stream<Duration?>? durationStream;

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        positionStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? audioPlayer.positionStream
                : controller.audioPlayer.positionStream,
        bufferedPositionStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}
