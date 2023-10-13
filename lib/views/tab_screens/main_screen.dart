import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
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
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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

  final apiHelper = ApiHelper();

  bool isLoading = false;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  List<String>? downloadSongsUrl;
  List<String>? playlisSongAudioUrl;
  List<String>? category1AudioUrl;
  List<String>? category2AudioUrl;
  List<String>? category3AudioUrl;
  List<String>? allSongsAudioUrl;

  // int? currentListTileIndexCategory1;

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
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoading = false;
    }
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('isLoggedIn');
    GlobVar.login = login;
    await prefs.reload();
    bool? isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen')!;
    log("$isMiniPlayerOpen", name: 'isMiniPlayerOpen');
    int currentListTileIndex = prefs.getInt('currentListTileIndex') ?? 0;
    log("$currentListTileIndex", name: 'currentListTileIndex');
    controller.toggleMiniPlayer(isMiniPlayerOpen);
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
    setState(() {
      controller.currentIndex.value == 0;
      controller.currentListTileIndex.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
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
      controller.isMiniPlayerOpenDownloadSongs.value == false ||
              controller.isMiniPlayerOpen.value == false ||
              controller.isMiniPlayerOpenHome1.value == false ||
              controller.isMiniPlayerOpenHome2.value == false ||
              controller.isMiniPlayerOpenHome3.value == false ||
              controller.isMiniPlayerOpenAllSongs.value == false
          ? controller.audioPlayer.dispose()
          : controller.audioPlayer.play();
      allSongsScreenController.allSongsList();
      playlistScreenController.songsInPlaylist(playlistId: '');
      downloadSongScreenController.downloadSongsList();
     
    });
    // controller.isMiniPlayerOpenAllSongs.value == true
    //     ? allSongsScreenController.allSongsListModel != null
    //     : null;
    // _initAudioPlayer();
    // controller.isMiniPlayerOpen.value == true ? audioPlayer.dispose() : null;
  }

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
        controller.isMiniPlayerOpenDownloadSongs.value == true
            ? controller.currentListTileIndexDownloadSongs.value = index ?? 0
            : controller.isMiniPlayerOpen.value == true
                ? controller.currentListTileIndex.value = index ?? 0
                : controller.isMiniPlayerOpenHome1.value == true
                    ? controller.currentListTileIndexCategory1.value =
                        index ?? 0
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? controller.currentListTileIndexCategory2.value =
                            index ?? 0
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? controller.currentListTileIndexCategory3.value =
                                index ?? 0
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                //  &&
                                //         allSongsScreenController.allSongsListModel != null
                                ? controller.currentListTileIndexAllSongs
                                    .value = index ?? 0
                                : null;
      });
      MediaItem mediaItem = MediaItem(
        id: controller.isMiniPlayerOpenDownloadSongs.value == true &&
                downloadSongScreenController.allSongsListModel != null
            ? (downloadSongScreenController
                    .allSongsListModel!
                    .data![controller.currentListTileIndexDownloadSongs.value]
                    .id) ??
                ''
            : controller.isMiniPlayerOpen.value == true &&
                    playlistScreenController.allSongsListModel != null
                ? (playlistScreenController.allSongsListModel!
                        .data![controller.currentListTileIndex.value].id) ??
                    ''
                : controller.isMiniPlayerOpenHome1.value == true
                    ? (categoryData1!
                        .data![controller.currentListTileIndexCategory1.value]
                        .id)!
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? (categoryData2!
                            .data![
                                controller.currentListTileIndexCategory2.value]
                            .id)!
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? (categoryData3!
                                .data![controller
                                    .currentListTileIndexCategory3.value]
                                .id)!
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                ? (allSongsScreenController
                                    .allSongsListModel!
                                    .data![controller
                                        .currentListTileIndexAllSongs.value]
                                    .id)!
                                : '',
        title: controller.isMiniPlayerOpenDownloadSongs.value == true
            ? (downloadSongScreenController
                .allSongsListModel!
                .data![controller.currentListTileIndexDownloadSongs.value]
                .title)!
            : controller.isMiniPlayerOpen.value == true
                ? (playlistScreenController.allSongsListModel!
                    .data![controller.currentListTileIndex.value].title)!
                : controller.isMiniPlayerOpenHome1.value == true
                    ? (categoryData1!
                        .data![controller.currentListTileIndexCategory1.value]
                        .title)!
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? (categoryData2!
                            .data![
                                controller.currentListTileIndexCategory2.value]
                            .title)!
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? (categoryData3!
                                .data![controller
                                    .currentListTileIndexCategory3.value]
                                .title)!
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                ? (allSongsScreenController
                                    .allSongsListModel!
                                    .data![controller
                                        .currentListTileIndexAllSongs.value]
                                    .title)!
                                : '',
        album: controller.isMiniPlayerOpenDownloadSongs.value == true
            ? (downloadSongScreenController
                .allSongsListModel!
                .data![controller.currentListTileIndexDownloadSongs.value]
                .description)!
            : controller.isMiniPlayerOpen.value == true
                ? (playlistScreenController.allSongsListModel!
                    .data![controller.currentListTileIndex.value].description)!
                : controller.isMiniPlayerOpenHome1.value == true
                    ? (categoryData1!
                        .data![controller.currentListTileIndexCategory1.value]
                        .description)!
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? (categoryData2!
                            .data![
                                controller.currentListTileIndexCategory2.value]
                            .description)!
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? (categoryData3!
                                .data![controller
                                    .currentListTileIndexCategory3.value]
                                .description)!
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                ? (allSongsScreenController
                                    .allSongsListModel!
                                    .data![controller
                                        .currentListTileIndexAllSongs.value]
                                    .description)!
                                : '',
        artUri: Uri.parse(controller.isMiniPlayerOpenDownloadSongs.value == true
            ? (downloadSongScreenController
                .allSongsListModel!
                .data![controller.currentListTileIndexDownloadSongs.value]
                .image)!
            : controller.isMiniPlayerOpen.value == true
                ? (playlistScreenController.allSongsListModel!
                    .data![controller.currentListTileIndex.value].image)!
                : controller.isMiniPlayerOpenHome1.value == true
                    ? (categoryData1!
                        .data![controller.currentListTileIndexCategory1.value]
                        .image)!
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? (categoryData2!
                            .data![
                                controller.currentListTileIndexCategory2.value]
                            .image)!
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? (categoryData3!
                                .data![controller
                                    .currentListTileIndexCategory3.value]
                                .image)!
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                ? (allSongsScreenController
                                    .allSongsListModel!
                                    .data![controller
                                        .currentListTileIndexAllSongs.value]
                                    .image)!
                                : ''),
        duration: const Duration(milliseconds: 0),
      );
       

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: controller.isMiniPlayerOpenDownloadSongs.value == true
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
        initialIndex: controller.isMiniPlayerOpenDownloadSongs.value == true
            ? controller.currentListTileIndexDownloadSongs.value
            : controller.isMiniPlayerOpen.value == true
                ? controller.currentListTileIndex.value
                : controller.isMiniPlayerOpenHome1.value == true
                    ? controller.currentListTileIndexCategory1.value
                    : controller.isMiniPlayerOpenHome2.value == true
                        ? controller.currentListTileIndexCategory2.value
                        : controller.isMiniPlayerOpenHome3.value == true
                            ? controller.currentListTileIndexCategory3.value
                            : controller.isMiniPlayerOpenAllSongs.value == true
                                ? controller.currentListTileIndexAllSongs.value
                                : null,
        preload: false,
        initialPosition: Duration.zero,
      );
      // setState(() {
        
      homeScreenController.addRecentSongs(musicId: (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
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
                                      .currentListTileIndexDownloadSongs.value]
                                  .id)!
                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (playlistScreenController
                                      .allSongsListModel!
                                      .data![
                                          controller.currentListTileIndex.value]
                                      .id)!
                                  : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpen.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome2.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].id)!
                                      : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].id)!
                                          : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].id)!
                                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                  ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id)!
                                                  : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].id)!,).then((value) {
                                                   homeScreenController.recentSongsList();
                                                  });
      // });
      await controller.audioPlayer.play();
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
    controller.setAudioPlayer(audioPlayer);
    return Scaffold(
      body: Obx(
        () => screens[controller.currentIndex.value],
      ),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
                    downloadSongScreenController.allSongsListModel != null
                // &&
                // (controller.isMiniPlayerOpenHome1.value) == false
                ? BottomAppBar(
                    elevation: 0,
                    height: 60,
                    padding: EdgeInsets.zero,
                    clipBehavior: Clip.none,
                    color: AppColors.backgroundColor,
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
                        color: AppColors.backgroundColor,
                        child: miniplayer())
                    : (controller.isMiniPlayerOpenHome1.value) == true &&
                            categoryData1 != null
                        ? BottomAppBar(
                            elevation: 0,
                            height: 60,
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.none,
                            color: AppColors.backgroundColor,
                            child: miniplayer())
                        : (controller.isMiniPlayerOpenHome2.value) == true &&
                                categoryData2 != null
                            ? BottomAppBar(
                                elevation: 0,
                                height: 60,
                                padding: EdgeInsets.zero,
                                clipBehavior: Clip.none,
                                color: AppColors.backgroundColor,
                                child: miniplayer())
                            : (controller.isMiniPlayerOpenHome3.value) ==
                                        true &&
                                    categoryData3 != null
                                ? BottomAppBar(
                                    elevation: 0,
                                    height: 60,
                                    padding: EdgeInsets.zero,
                                    clipBehavior: Clip.none,
                                    color: AppColors.backgroundColor,
                                    child: miniplayer())
                                : (controller.isMiniPlayerOpenAllSongs.value) ==
                                            true &&
                                        allSongsScreenController
                                                .allSongsListModel!.data !=
                                            null
                                    ? BottomAppBar(
                                        elevation: 0,
                                        height: 60,
                                        padding: EdgeInsets.zero,
                                        clipBehavior: Clip.none,
                                        color: AppColors.backgroundColor,
                                        child: miniplayer())
                                    : const SizedBox(),
            BottomNavigationBar(
              items: bottomNavBarItems,
              currentIndex: controller.currentIndex.value,
              backgroundColor: AppColors.backgroundColor,
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
              unselectedItemColor: Colors.grey.shade400,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          ],
        ),
      ),
    );
  }

  Miniplayer miniplayer() {
    return Miniplayer(
      minHeight: 60,
      maxHeight: 60,
      builder: (height, percentage) {
        _initAudioPlayer();
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
                  index: controller.isMiniPlayerOpenDownloadSongs.value == true
                      ? controller.currentListTileIndexDownloadSongs.value
                      : controller.isMiniPlayerOpen.value == true
                          ? controller.currentListTileIndex.value
                          : controller.isMiniPlayerOpenHome1.value == true
                              ? controller.currentListTileIndexCategory1.value
                              : controller.isMiniPlayerOpenHome2.value == true
                                  ? controller
                                      .currentListTileIndexCategory2.value
                                  : controller.isMiniPlayerOpenHome3.value ==
                                          true
                                      ? controller
                                          .currentListTileIndexCategory3.value
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
                          controller.isMiniPlayerOpenDownloadSongs.value == true
                      ? controller.audioPlayer
                      : controller.audioPlayer,
                ),
                transition: Transition.downToUp,
                duration: const Duration(milliseconds: 600));
          },
          child:
              Container(
            color: const Color.fromARGB(255, 7, 18, 59),
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
                        downloadSongScreenController.allSongsListModel != null &&
                                (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                    true &&
                                (controller.isMiniPlayerOpen.value) == false &&
                                (controller.isMiniPlayerOpenHome1.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenHome2.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenHome3.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenAllSongs.value) ==
                                    false
                            ? downloadSongScreenController
                                    .allSongsListModel!
                                    .data![controller
                                        .currentListTileIndexDownloadSongs.value]
                                    .image ?? 
                                'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : playlistScreenController.allSongsListModel != null &&
                                    (controller.isMiniPlayerOpen.value) == true &&
                                    (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome1.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome2.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome3.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenAllSongs.value) ==
                                        false
                                ? playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : categoryData1 != null &&
                                        (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpen.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome1.value) ==
                                            true &&
                                        (controller.isMiniPlayerOpenHome2.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenHome3.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) ==
                                            false
                                    ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                    : categoryData2 != null &&
                                            (controller
                                                    .isMiniPlayerOpenDownloadSongs
                                                    .value) ==
                                                false &&
                                            (controller.isMiniPlayerOpen.value) == false &&
                                            (controller.isMiniPlayerOpenHome1.value) == false &&
                                            (controller.isMiniPlayerOpenHome2.value) == true &&
                                            (controller.isMiniPlayerOpenHome3.value) == false &&
                                            (controller.isMiniPlayerOpenAllSongs.value) == false
                                        ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : categoryData3 != null && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                            ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                          text: (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
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
                                      .currentListTileIndexDownloadSongs.value]
                                  .title)!
                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (playlistScreenController
                                      .allSongsListModel!
                                      .data![
                                          controller.currentListTileIndex.value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpen.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome2.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                      : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                          : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                  ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                  : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
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
                                      .currentListTileIndexDownloadSongs.value]
                                  .description)!
                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (playlistScreenController
                                      .allSongsListModel!
                                      .data![
                                          controller.currentListTileIndex.value]
                                      .description)!
                                  : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome1.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpenHome2.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                      : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                          : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
                                              : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                            (controller.isMiniPlayerOpenAllSongs.value) == true
                        ? audioPlayer
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
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? audioPlayer.positionStream
                : controller.audioPlayer.positionStream,
        bufferedPositionStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}
