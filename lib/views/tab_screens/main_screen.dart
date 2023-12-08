import 'dart:developer';
// import 'dart:html';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/album_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/artist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/notification/notification_service.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
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
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  ProfileController profileController = Get.put(ProfileController());
  AuthController authController = Get.put(AuthController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());

  final apiHelper = ApiHelper();

  bool isLoading = false;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  List<String>? favoriteSongsUrl;
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
    // controller.toggleMiniPlayer(isMiniPlayerOpen  ?? false);
    controller.updateCurrentListTileIndex(currentListTileIndex);
  }

  final List<Widget> screens = [
    const HomeTabScreen(),
    const AllSongScreen(myPlaylistId: '', playlistTitle: ''),
    // ReelsScreen(),
    const SearchScreen(),
    const MyLibraryScreen(),
  ];

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: AppStrings.home,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.play_arrow_outlined),
      label: AppStrings.forYou,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: AppStrings.search,
    ),
    // const BottomNavigationBarItem(
    //   icon: Icon(Icons.videocam_outlined),
    //   label: AppStrings.reel,
    // ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      label: AppStrings.myLibrary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          // ignore: avoid_print
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(

          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          // ignore: avoid_print
          print(message.notification!.title);
          // ignore: avoid_print
          print(message.data['message']);
          // ignore: avoid_print
          print("message.data11 ${message.data}");
          LocalNotificationService().createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          // ignore: avoid_print
          print('title-----> ${message.notification!.title}');
          // print(message.notification!);
          // ignore: avoid_print
          print(message.data['message']);
          // ignore: avoid_print
          print('data--->> ${message.data}');
          // // ignore: avoid_print
          // print("message.data22 ${message.data['_id']}");
        }
      },
    );
    fetchData();
    sharedPref();
    homeScreenController.homeCategories();
    homeScreenController.recentSongsList();
    profileController.fetchProfile();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        GlobVar.deviceToken = token!;
        print("Device token---> $token");
        print("Device token Glob---> ${GlobVar.deviceToken}");
        //  print("GlobVar.deviceToken main ----> ${GlobVar.deviceToken}");
        authController.deviceToken(deviceToken: GlobVar.deviceToken);
      }
    });

    // controller.currentIndex.value = 0;
    setState(() {
      controller.currentListTileIndex.value;
      controller.currentListTileIndexCategory.value;
      controller.currentListTileIndexCategoryData.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndexQueueSongs.value;
      controller.currentListTileIndexFavoriteSongs.value;
      controller.isMiniPlayerOpen.value;
      log(controller.isMiniPlayerOpen.value.toString(),
          name: 'isMiniPlayerOpen');
      log(controller.isMiniPlayerOpenHome.value.toString(),
          name: 'isMiniPlayerOpenHome');
      log(controller.isMiniPlayerOpenHome1.value.toString(),
          name: 'isMiniPlayerOpenHome1');
      log(controller.isMiniPlayerOpenHome2.value.toString(),
          name: 'isMiniPlayerOpenHome2');
      log(controller.isMiniPlayerOpenHome3.value.toString(),
          name: 'isMiniPlayerOpenHome3');
      log(controller.isMiniPlayerOpenAllSongs.value.toString(),
          name: 'isMiniPlayerOpenAllSongs');
      log(controller.isMiniPlayerOpenQueueSongs.value.toString(),
          name: 'isMiniPlayerOpenQueueSongs');
      log(controller.isMiniPlayerOpenFavoriteSongs.value.toString(),
          name: 'isMiniPlayerOpenFavoriteSongs');
      log(controller.isMiniPlayerOpenAlbumSongs.value.toString(),
          name: 'isMiniPlayerOpenAlbumSongs');
      log(controller.currentListTileIndexCategory1.value.toString(),
          name: 'currentListTileIndexCategory1');
      log(controller.currentListTileIndexAllSongs.value.toString(),
          name: 'currentListTileIndexAllSongs');
      log(controller.currentListTileIndexDownloadSongs.value.toString(),
          name: 'currentListTileIndexDownloadSongs');
      log(controller.currentListTileIndexQueueSongs.value.toString(),
          name: 'currentListTileIndexQueueSongs');
      log(controller.currentListTileIndexFavoriteSongs.value.toString(),
          name: 'currentListTileIndexFavoriteSongs');
      log(controller.currentListTileIndexAlbumSongs.value.toString(),
          name: 'currentListTileIndexAlbumSongs');
      log(controller.currentListTileIndexArtistSongs.value.toString(),
          name: 'currentListTileIndexArtistSongs');
      log(GlobVar.playlistId, name: 'playlistId');
      log("${GlobVar.login}", name: 'login');
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
              controller.isMiniPlayerOpenHome.value == false ||
              controller.isMiniPlayerOpenHome1.value == false ||
              controller.isMiniPlayerOpenHome2.value == false ||
              controller.isMiniPlayerOpenHome3.value == false ||
              controller.isMiniPlayerOpenAllSongs.value == false ||
              controller.isMiniPlayerOpenFavoriteSongs.value == false ||
              controller.isMiniPlayerOpenAlbumSongs.value == false ||
              controller.isMiniPlayerOpenArtistSongs.value == false
          ? controller.audioPlayer.dispose()
          : controller.audioPlayer.play();
      playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);
      // playlistScreenController.isLikePlaylistData.isEmpty ? controller.isMiniPlayerOpen.value = false : controller.isMiniPlayerOpen.value = true;

      // downloadSongScreenController.downloadSongsList();
      // queueSongsScreenController.queueSongsListWithoutPlaylist();
    });
    // allSongsScreenController.allSongsList();

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

  @override
  Widget build(BuildContext context) {
    log(controller.currentListTileIndexCategory.value.toString(),
        name: 'main currentListTileIndexCategory');
    log(controller.currentListTileIndexCategoryData.value.toString(),
        name: 'main currentListTileIndexCategoryData');
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
    log(controller.currentListTileIndexFavoriteSongs.value.toString(),
        name: 'main currentListTileIndexFavoriteSongs');
    log(controller.currentListTileIndexAlbumSongs.value.toString(),
        name: 'main currentListTileIndexAlbumSongs');
    log(controller.currentListTileIndexArtistSongs.value.toString(),
        name: 'main currentListTileIndexArtistSongs');
    controller.setAudioPlayer(audioPlayer);
    var systemOverlayStyle = const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.bottomNavColor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
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
          () => Padding(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                        artistScreenController.allSongsListModel != null
                    // &&
                    // (controller.isMiniPlayerOpenHome1.value) == false
                   ? BottomAppBar(
                            elevation: 0,
                            height: 60,
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.none,
                            color: AppColors.bottomNavColor,
                            child: miniplayer())
                    : (controller.isMiniPlayerOpenAlbumSongs.value) == true &&
                            albumScreenController.allSongsListModel != null
                        // &&
                        // (controller.isMiniPlayerOpenHome1.value) == false
                        ? 
                            BottomAppBar(
                                elevation: 0,
                                height: 60,
                                padding: EdgeInsets.zero,
                                clipBehavior: Clip.none,
                                color: AppColors.bottomNavColor,
                                child: miniplayer())
                        : (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
                                favoriteSongScreenController.allSongsListModel !=
                                    null
                            // &&
                            // (controller.isMiniPlayerOpenHome1.value) == false
                            ?  BottomAppBar(
                                    elevation: 0,
                                    height: 60,
                                    padding: EdgeInsets.zero,
                                    clipBehavior: Clip.none,
                                    color: AppColors.bottomNavColor,
                                    child: miniplayer())
                            : (controller.isMiniPlayerOpenQueueSongs.value) == true &&
                                    queueSongsScreenController.allSongsListModel !=
                                        null
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
                                        downloadSongScreenController
                                                .allSongsListModel !=
                                            null
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
                                            playlistScreenController
                                                    .allSongsListModel !=
                                                null &&
                                            playlistScreenController
                                                .isLikePlaylistData.isNotEmpty
                                        // &&
                                        // (controller.isMiniPlayerOpenHome1.value) == false
                                        ? BottomAppBar(
                                                elevation: 0,
                                                height: 60,
                                                padding: EdgeInsets.zero,
                                                clipBehavior: Clip.none,
                                                color: AppColors.bottomNavColor,
                                                child: miniplayer())
                                        : (controller.isMiniPlayerOpenHome.value) == true &&
                                                homeScreenController
                                                    .homeCategoryData.isNotEmpty
                                            ? BottomAppBar(
                                                    elevation: 0,
                                                    height: 60,
                                                    padding: EdgeInsets.zero,
                                                    clipBehavior: Clip.none,
                                                    color: AppColors
                                                        .bottomNavColor,
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
                                                : (controller.isMiniPlayerOpenHome2.value) == true && categoryData2 != null
                                                    ? BottomAppBar(elevation: 0, height: 60, padding: EdgeInsets.zero, clipBehavior: Clip.none, color: AppColors.bottomNavColor, child: miniplayer())
                                                    : (controller.isMiniPlayerOpenHome3.value) == true && categoryData3 != null
                                                        ? BottomAppBar(elevation: 0, height: 60, padding: EdgeInsets.zero, clipBehavior: Clip.none, color: AppColors.bottomNavColor, child: miniplayer())
                                                        : (controller.isMiniPlayerOpenAllSongs.value) == true && allSongsScreenController.allSongsListModel!.data != null
                                                            ? BottomAppBar(elevation: 0, height: 60, padding: EdgeInsets.zero, clipBehavior: Clip.none, color: AppColors.bottomNavColor, child: miniplayer())
                                                            : const SizedBox(),
                // const Divider(
                //   color: AppColors.bottomDividerColor,
                //   thickness: 1,
                //   height: 1,
                // ),
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
                  index: controller.isMiniPlayerOpenArtistSongs.value == true
                      ? controller.currentListTileIndexArtistSongs.value
                      : controller.isMiniPlayerOpenAlbumSongs.value == true
                          ? controller.currentListTileIndexAlbumSongs.value
                          : controller.isMiniPlayerOpenFavoriteSongs.value ==
                                  true
                              ? controller
                                  .currentListTileIndexFavoriteSongs.value
                              : controller.isMiniPlayerOpenQueueSongs.value ==
                                      true
                                  ? controller
                                      .currentListTileIndexQueueSongs.value
                                  : controller.isMiniPlayerOpenDownloadSongs
                                              .value ==
                                          true
                                      ? controller
                                          .currentListTileIndexDownloadSongs
                                          .value
                                      : controller.isMiniPlayerOpen.value ==
                                              true
                                          ? controller
                                              .currentListTileIndex.value
                                          : controller.isMiniPlayerOpenHome
                                                      .value ==
                                                  true
                                              ? controller
                                                  .currentListTileIndexCategoryData
                                                  .value
                                              : controller.isMiniPlayerOpenHome1
                                                          .value ==
                                                      true
                                                  ? controller
                                                      .currentListTileIndexCategory1
                                                      .value
                                                  : controller.isMiniPlayerOpenHome2
                                                              .value ==
                                                          true
                                                      ? controller
                                                          .currentListTileIndexCategory2
                                                          .value
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
                                                                  .currentListTileIndex
                                                                  .value,
                  type: controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true
                      ? 'home'
                      : controller.isMiniPlayerOpenHome.value == true
                          ? 'home cat song'
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
                                          : controller.isMiniPlayerOpenFavoriteSongs
                                                      .value ==
                                                  true
                                              ? 'favorite song'
                                              : controller.isMiniPlayerOpenAlbumSongs
                                                          .value ==
                                                      true
                                                  ? 'album song'
                                                  : controller.isMiniPlayerOpenArtistSongs
                                                              .value ==
                                                          true
                                                      ? 'artist song'
                                                      : '',
                  duration: duration,
                  position: position,
                  bufferedPosition: bufferedPosition,
                  durationStream: durationStream!,
                  positionStream: positionStream!,
                  bufferedPositionStream: bufferedPositionStream!,
                  audioPlayer: controller.isMiniPlayerOpenHome.value == true ||
                          controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true ||
                          controller.isMiniPlayerOpenAllSongs.value == true ||
                          controller.isMiniPlayerOpen.value == true ||
                          controller.isMiniPlayerOpenDownloadSongs.value ==
                              true ||
                          controller.isMiniPlayerOpenQueueSongs.value == true ||
                          controller.isMiniPlayerOpenFavoriteSongs.value ==
                              true ||
                          controller.isMiniPlayerOpenAlbumSongs.value == true ||
                          controller.isMiniPlayerOpenArtistSongs.value == true
                      ? controller.audioPlayer
                      : controller.audioPlayer,
                  categoryData1: categoryData1,
                  categoryData2: categoryData2,
                  categoryData3: categoryData3,
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
                                (controller.isMiniPlayerOpenArtistSongs.value) ==
                                    true &&
                                (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpen.value) == false &&
                                (controller.isMiniPlayerOpenHome.value) ==
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
                                    false &&
                        artistScreenController.allSongsListModel != null 
                            ? artistScreenController.currentPlayingImage.value 
                            // artistScreenController
                            //         .allSongsListModel!
                            //         .data![controller
                            //             .currentListTileIndexArtistSongs.value]
                            //         .image ??
                            : albumScreenController.allSongsListModel != null &&
                                    (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                        true &&
                                    (controller.isMiniPlayerOpenArtistSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpen.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenHome.value) ==
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
                                ? albumScreenController
                                        .allSongsListModel!
                                        .data![controller
                                            .currentListTileIndexAlbumSongs
                                            .value]
                                        .image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : favoriteSongScreenController.allSongsListModel != null &&
                                        (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                            true &&
                                        (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                        (controller.isMiniPlayerOpenArtistSongs.value) == false &&
                                        (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                        (controller.isMiniPlayerOpen.value) == false &&
                                        (controller.isMiniPlayerOpenHome.value) == false &&
                                        (controller.isMiniPlayerOpenHome1.value) == false &&
                                        (controller.isMiniPlayerOpenHome2.value) == false &&
                                        (controller.isMiniPlayerOpenHome3.value) == false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                        (controller.isMiniPlayerOpenQueueSongs.value) == false
                                    ? favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                    : queueSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true
                                        ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : downloadSongScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                            ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : playlistScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                ? playlistScreenController.currentPlayingImage.isNotEmpty
                                                    ? playlistScreenController.currentPlayingImage.value
                                                    : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                : (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && categoryData1 != null && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        : categoryData3 != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                            ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                            : homeScreenController.homeCategoryData.isNotEmpty && (controller.isMiniPlayerOpenHome.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                                ? homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                                : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                          text: (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                                  (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenQueueSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpen.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome.value) ==
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
                              ? artistScreenController.currentPlayingTitle.value
                              // (artistScreenController
                              //     .allSongsListModel!
                              //     .data![controller
                              //         .currentListTileIndexArtistSongs.value]
                              //     .title)!
                              : (controller.isMiniPlayerOpenAlbumSongs.value) == true &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome.value) ==
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
                                  ? (albumScreenController
                                      .allSongsListModel!
                                      .data![controller.currentListTileIndexAlbumSongs.value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                      ? (favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                          ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? playlistScreenController.currentPlayingTitle.isNotEmpty
                                                      ? playlistScreenController.currentPlayingTitle.value
                                                      : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                                              : homeScreenController.homeCategoryData.isNotEmpty && (controller.isMiniPlayerOpenHome.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                                  ? (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].title)!
                                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                                      ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                                      : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: homeScreenController.homeCategoryData.isNotEmpty &&
                                  (controller.isMiniPlayerOpenHome.value) ==
                                      true &&
                                  (controller.isMiniPlayerOpenArtistSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                      false &&
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
                                      false &&
                                  (controller.isMiniPlayerOpenQueueSongs.value) ==
                                      false
                              ? (homeScreenController
                                  .homeCategoryModel!
                                  .data![controller
                                      .currentListTileIndexCategory.value]
                                  .categoryData![controller
                                      .currentListTileIndexCategoryData.value]
                                  .description)!
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) == false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) == false
                                  ? artistScreenController.currentPlayingDesc.value
                                  // (artistScreenController.allSongsListModel!.data![controller.currentListTileIndexArtistSongs.value].description)!
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) == false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) == false
                                  ? (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].description)!
                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].description)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].description)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].description)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? playlistScreenController.currentPlayingDesc.isNotEmpty
                                                      ? playlistScreenController.currentPlayingDesc.value
                                                      : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
                                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                            (controller.isMiniPlayerOpenHome.value) == true ||
                            (controller.isMiniPlayerOpenHome1.value) == true ||
                            (controller.isMiniPlayerOpenHome2.value) == true ||
                            (controller.isMiniPlayerOpenHome3.value) == true ||
                            (controller.isMiniPlayerOpenAllSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenQueueSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                    controller.isMiniPlayerOpenHome.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true ||
                    (controller.isMiniPlayerOpenFavoriteSongs.value) == true ||
                    (controller.isMiniPlayerOpenAlbumSongs.value) == true ||
                    (controller.isMiniPlayerOpenArtistSongs.value) == true
                ? audioPlayer.positionStream
                : controller.audioPlayer.positionStream,
        bufferedPositionStream =
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
                    (controller.isMiniPlayerOpenArtistSongs.value) == true
                ? audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream =
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
                    (controller.isMiniPlayerOpenArtistSongs.value) == true
                ? audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}
