import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenController extends GetxController {
  HomeScreenController homeScreenController = HomeScreenController();
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  ProfileController profileController = Get.put(ProfileController());

  AudioPlayer audioPlayer = AudioPlayer();
  

  final apiHelper = ApiHelper();

  final RxInt currentIndex;
  final RxBool isMiniPlayerOpen;
  final RxBool isMiniPlayerOpenHome1;
  final RxBool isMiniPlayerOpenHome2;
  final RxBool isMiniPlayerOpenHome3;
  final RxBool isMiniPlayerOpenAllSongs;
  final RxBool isMiniPlayerOpenDownloadSongs;
  final RxBool isMiniPlayerOpenQueueSongs;

  // final RxBool isMiniPlayerOpen;
  final RxInt currentListTileIndex;
  final RxInt currentListTileIndexCategory1;
  final RxInt currentListTileIndexCategory2;
  final RxInt currentListTileIndexCategory3;
  final RxInt currentListTileIndexAllSongs;
  final RxInt currentListTileIndexDownloadSongs;
  final RxInt currentListTileIndexQueueSongs;

  /////
  // AudioPlayer? audioPlayer;
  List<String> playlisSongAudioUrl = [];
  List<String> category1AudioUrl = [];
  List<String> category2AudioUrl = [];
  List<String> category3AudioUrl = [];
  List<String> allSongsUrl = [];
  List<String> downloadSongsUrl = [];
  List<String> queueSongsUrl = [];


  MainScreenController({int initialIndex = 0})
      : currentIndex = initialIndex.obs,
        isMiniPlayerOpen = false.obs,
        isMiniPlayerOpenHome1 = false.obs,
        isMiniPlayerOpenHome2 = false.obs,
        isMiniPlayerOpenHome3 = false.obs,
        isMiniPlayerOpenAllSongs = false.obs,
        isMiniPlayerOpenDownloadSongs = false.obs,
        isMiniPlayerOpenQueueSongs = false.obs,
        currentListTileIndex = 0.obs,
        currentListTileIndexCategory1 = 0.obs,
        currentListTileIndexCategory2 = 0.obs,
        currentListTileIndexCategory3 = 0.obs,
        currentListTileIndexAllSongs = 0.obs,
        currentListTileIndexDownloadSongs = 0.obs,
        currentListTileIndexQueueSongs = 0.obs;

  @override
  void onInit() {
    fetchData();
      homeScreenController.recentSongsList();
      allSongsScreenController.allSongsList();
      playlistScreenController.songsInPlaylist(playlistId: '');
      downloadSongScreenController.downloadSongsList();
      queueSongsScreenController.queueSongsListWithoutPlaylist();
      // profileController.fetchProfile(); 
    initAudioPlayer();
    super.onInit();
  }

  void setAudioPlayer(AudioPlayer newAudioPlayer) {
    audioPlayer = newAudioPlayer;
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  ////

  void toggleMiniPlayer(bool isOpen) {
    isMiniPlayerOpen.value = isOpen;
  }

  //////

  void updateCurrentListTileIndex(int index) {
    currentListTileIndex.value = index;
  }

  void updateCurrentListTileIndexCategory1(int index) {
    currentListTileIndexCategory1.value = index;
  }

  void updateCurrentListTileIndexCategory2(int index) {
    currentListTileIndexCategory2.value = index;
  }

  void updateCurrentListTileIndexCategory3(int index) {
    currentListTileIndexCategory3.value = index;
  }

  void updateCurrentListTileIndexAllSongs(int index) {
    currentListTileIndexAllSongs.value = index;
  }

  void updateCurrentListTileIndexDownloadSongs(int index) {
    currentListTileIndexDownloadSongs.value = index;
  }

  void updateCurrentListTileIndexQueueSongs(int index) {
    currentListTileIndexQueueSongs.value = index;
  }

  /////////

  void addPlaylistSongAudioUrlToList(String newString) {
    playlisSongAudioUrl.add(newString);
    update();
  }

  void addCategory1AudioUrlToList(String newString) {
    category1AudioUrl.add(newString);
    update();
  }

  void addCategory2AudioUrlToList(String newString) {
    category2AudioUrl.add(newString);
    update();
  }

  void addCategory3AudioUrlToList(String newString) {
    category3AudioUrl.add(newString);
    update();
  }

  void addAllSongsAudioUrlToList(String newString) {
    allSongsUrl.add(newString);
    update();
  }

  void addDownloadSongsAudioUrlToList(String newString) {
    downloadSongsUrl.add(newString);
    update();
  }

  void addQueueSongsAudioUrlToList(String newString) {
    queueSongsUrl.add(newString);
    update();
  }

  //////////

  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  Future<void> fetchData() async {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

    Future<void> initAudioPlayer() async {
      // List<String> queueSongsUrl = [];
      // List<String> downloadSongsUrl = [];
      // List<String> playlistAudioUrl = [];
      // List<String> category1AudioUrl = [];
      // List<String> category2AudioUrl = [];
      // List<String> category3AudioUrl = [];
      // List<String> allSongsAudioUrl = [];

      try {
        // queueSongsUrl = (queueSongsUrl);
        // downloadSongsUrl = (downloadSongsUrl);
        // playlisSongAudioUrl = (playlistAudioUrl);
        // category1AudioUrl = (category1AudioUrl);
        // category2AudioUrl = (category2AudioUrl);
        // category3AudioUrl = (category3AudioUrl);
        // allSongsAudioUrl = (allSongsUrl);
        log("$category1AudioUrl", name: 'list main screen cat1');
        log("${currentListTileIndexAllSongs.value}",
            name: 'currentListTileIndexAllSongs.value');
        audioPlayer.currentIndexStream.listen((index) {
          isMiniPlayerOpenQueueSongs.value == true
              ? currentListTileIndexQueueSongs.value = index ?? 0
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? currentListTileIndexDownloadSongs.value = index  ?? 0 
                  : isMiniPlayerOpen.value == true
                      ? currentListTileIndex.value = index ?? 0
                      : isMiniPlayerOpenHome1.value == true
                          ? currentListTileIndexCategory1.value = index ?? 0
                          : isMiniPlayerOpenHome2.value == true
                              ? currentListTileIndexCategory2.value = index ?? 0
                              : isMiniPlayerOpenHome3.value == true
                                  ? currentListTileIndexCategory3.value =
                                      index ?? 0
                                  : isMiniPlayerOpenAllSongs.value == true
                                      //  &&
                                      //         allSongsScreenallSongsListModel != null
                                      ? currentListTileIndexAllSongs.value =
                                          index ?? 0
                                      : null;
        });
        MediaItem mediaItem = MediaItem(
          id: isMiniPlayerOpenQueueSongs.value == true
              ? (queueSongsScreenController.allSongsListModel!
                  .data![currentListTileIndexQueueSongs.value].id)!
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? (downloadSongScreenController.allSongsListModel!
                      .data![currentListTileIndexDownloadSongs.value].id)!
                  : isMiniPlayerOpen.value == true
                      ? (playlistScreenController.allSongsListModel!
                          .data![currentListTileIndex.value].id)!
                      : isMiniPlayerOpenHome1.value == true
                          ? (categoryData1!
                              .data![currentListTileIndexCategory1.value].id)!
                          : isMiniPlayerOpenHome2.value == true
                              ? (categoryData2!
                                  .data![currentListTileIndexCategory2.value].id)!
                              : isMiniPlayerOpenHome3.value == true
                                  ? (categoryData3!
                                      .data![currentListTileIndexCategory3.value]
                                      .id)!
                                  : isMiniPlayerOpenAllSongs.value == true
                                      ? (allSongsScreenController
                                          .allSongsListModel!
                                          .data![
                                              currentListTileIndexAllSongs.value]
                                          .id)!
                                      : '',
          title: isMiniPlayerOpenQueueSongs.value == true
              ? (queueSongsScreenController.allSongsListModel!
                  .data![currentListTileIndexQueueSongs.value].title)!
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? (downloadSongScreenController.allSongsListModel!
                      .data![currentListTileIndexDownloadSongs.value].title)!
                  : isMiniPlayerOpen.value == true
                      ? (playlistScreenController.allSongsListModel!
                          .data![currentListTileIndex.value].title)!
                      : isMiniPlayerOpenHome1.value == true
                          ? (categoryData1!
                              .data![currentListTileIndexCategory1.value].title)!
                          : isMiniPlayerOpenHome2.value == true
                              ? (categoryData2!
                                  .data![currentListTileIndexCategory2.value]
                                  .title)!
                              : isMiniPlayerOpenHome3.value == true
                                  ? (categoryData3!
                                      .data![currentListTileIndexCategory3.value]
                                      .title)!
                                  : isMiniPlayerOpenAllSongs.value == true
                                      ? (allSongsScreenController
                                          .allSongsListModel!
                                          .data![
                                              currentListTileIndexAllSongs.value]
                                          .title)!
                                      : '',
          album: isMiniPlayerOpenQueueSongs.value == true
              ? (queueSongsScreenController.allSongsListModel!
                  .data![currentListTileIndexQueueSongs.value].description)!
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? (downloadSongScreenController
                      .allSongsListModel!
                      .data![currentListTileIndexDownloadSongs.value]
                      .description)!
                  : isMiniPlayerOpen.value == true
                      ? (playlistScreenController.allSongsListModel!
                          .data![currentListTileIndex.value].description)!
                      : isMiniPlayerOpenHome1.value == true
                          ? (categoryData1!
                              .data![currentListTileIndexCategory1.value]
                              .description)!
                          : isMiniPlayerOpenHome2.value == true
                              ? (categoryData2!
                                  .data![currentListTileIndexCategory2.value]
                                  .description)!
                              : isMiniPlayerOpenHome3.value == true
                                  ? (categoryData3!
                                      .data![currentListTileIndexCategory3.value]
                                      .description)!
                                  : isMiniPlayerOpenAllSongs.value == true
                                      ? (allSongsScreenController
                                          .allSongsListModel!
                                          .data![
                                              currentListTileIndexAllSongs.value]
                                          .description)!
                                      : '',
          artUri: Uri.parse(isMiniPlayerOpenQueueSongs.value == true
              ? (queueSongsScreenController.allSongsListModel!
                  .data![currentListTileIndexQueueSongs.value].image)!
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? (downloadSongScreenController.allSongsListModel!
                      .data![currentListTileIndexDownloadSongs.value].image)!
                  : isMiniPlayerOpen.value == true
                      ? (playlistScreenController.allSongsListModel!
                          .data![currentListTileIndex.value].image)!
                      : isMiniPlayerOpenHome1.value == true
                          ? (categoryData1!
                              .data![currentListTileIndexCategory1.value].image)!
                          : isMiniPlayerOpenHome2.value == true
                              ? (categoryData2!
                                  .data![currentListTileIndexCategory2.value]
                                  .image)!
                              : isMiniPlayerOpenHome3.value == true
                                  ? (categoryData3!
                                      .data![currentListTileIndexCategory3.value]
                                      .image)!
                                  : isMiniPlayerOpenAllSongs.value == true
                                      ? (allSongsScreenController
                                          .allSongsListModel!
                                          .data![
                                              currentListTileIndexAllSongs.value]
                                          .image)!
                                      : ''),
          duration: const Duration(milliseconds: 0),
        );

        audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
            useLazyPreparation: true,
            shuffleOrder: DefaultShuffleOrder(),
            children: isMiniPlayerOpenQueueSongs.value == true
                ? queueSongsUrl
                    .map(
                      (url) => AudioSource.uri(
                        Uri.parse(url),
                        tag: mediaItem,
                      ),
                    )
                    .toList()
                : isMiniPlayerOpenDownloadSongs.value == true
                    ? downloadSongsUrl
                        .map(
                          (url) => AudioSource.uri(
                            Uri.parse(url),
                            tag: mediaItem,
                          ),
                        )
                        .toList()
                    : isMiniPlayerOpen.value == true
                        ? playlisSongAudioUrl
                            .map(
                              (url) => AudioSource.uri(
                                Uri.parse(url),
                                tag: mediaItem,
                              ),
                            )
                            .toList()
                        : isMiniPlayerOpenHome1.value == true
                            ? category1AudioUrl
                                .map(
                                  (url) => AudioSource.uri(
                                    Uri.parse(url),
                                    tag: mediaItem,
                                  ),
                                )
                                .toList()
                            : isMiniPlayerOpenHome2.value == true
                                ? category2AudioUrl
                                    .map(
                                      (url) => AudioSource.uri(
                                        Uri.parse(url),
                                        tag: mediaItem,
                                      ),
                                    )
                                    .toList()
                                : isMiniPlayerOpenHome3.value == true
                                    ? category3AudioUrl
                                        .map(
                                          (url) => AudioSource.uri(
                                            Uri.parse(url),
                                            tag: mediaItem,
                                          ),
                                        )
                                        .toList()
                                    : isMiniPlayerOpenAllSongs.value == true
                                        ? allSongsUrl
                                            .map(
                                              (url) => AudioSource.uri(
                                                Uri.parse(url),
                                                tag: mediaItem,
                                              ),
                                            )
                                            .toList()
                                        : category1AudioUrl
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
          //       currentListTileIndexCategory1.value]),
          //   tag: mediaItem,
          // ),
          initialIndex: isMiniPlayerOpenQueueSongs.value == true
              ? currentListTileIndexQueueSongs.value
              : isMiniPlayerOpenDownloadSongs.value == true
                  ? currentListTileIndexDownloadSongs.value
                  : isMiniPlayerOpen.value == true
                      ? currentListTileIndex.value
                      : isMiniPlayerOpenHome1.value == true
                          ? currentListTileIndexCategory1.value
                          : isMiniPlayerOpenHome2.value == true
                              ? currentListTileIndexCategory2.value
                              : isMiniPlayerOpenHome3.value == true
                                  ? currentListTileIndexCategory3.value
                                  : isMiniPlayerOpenAllSongs.value == true
                                      ? currentListTileIndexAllSongs.value
                                      : null,
          preload: false,
          initialPosition: Duration.zero,
        );
        (isMiniPlayerOpenQueueSongs.value) == true &&
                (isMiniPlayerOpenDownloadSongs.value) == false &&
                (isMiniPlayerOpen.value) == false &&
                (isMiniPlayerOpenHome1.value) == false &&
                (isMiniPlayerOpenHome2.value) == false &&
                (isMiniPlayerOpenHome3.value) == false &&
                (isMiniPlayerOpenAllSongs.value) == false &&
                queueSongsUrl.isNotEmpty
            ? await audioPlayer.setLoopMode(LoopMode.all)
            : await audioPlayer.setLoopMode(LoopMode.off);
            await audioPlayer.play();
            log('${audioPlayer.playing}',name: 'check init playing ????');
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing audio player: $e');
        }
      }
    }
}


// // main screen controller


// import 'dart:developer';

// import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
// import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainScreenController extends GetxController {
//   AllSongsScreenController allSongsScreenController =
//       Get.put(AllSongsScreenController());
//   PlaylistScreenController playlistScreenController =
//       Get.put(PlaylistScreenController());
//   DownloadSongScreenController downloadSongScreenController =
//       Get.put(DownloadSongScreenController());
//   QueueSongsScreenController queueSongsScreenController =
//       Get.put(QueueSongsScreenController());

//   AudioPlayer audioPlayer = AudioPlayer();
  

//   final apiHelper = ApiHelper();

//   final RxInt currentIndex;
//   final RxBool isMiniPlayerOpen;
//   final RxBool isMiniPlayerOpenHome1;
//   final RxBool isMiniPlayerOpenHome2;
//   final RxBool isMiniPlayerOpenHome3;
//   final RxBool isMiniPlayerOpenAllSongs;
//   final RxBool isMiniPlayerOpenDownloadSongs;
//   final RxBool isMiniPlayerOpenQueueSongs;

//   // final RxBool isMiniPlayerOpen;
//   final RxInt currentListTileIndex;
//   final RxInt currentListTileIndexCategory1;
//   final RxInt currentListTileIndexCategory2;
//   final RxInt currentListTileIndexCategory3;
//   final RxInt currentListTileIndexAllSongs;
//   final RxInt currentListTileIndexDownloadSongs;
//   final RxInt currentListTileIndexQueueSongs;

//   /////
//   // AudioPlayer? audioPlayer;
//   List<String> playlisSongAudioUrl = [];
//   List<String> category1AudioUrl = [];
//   List<String> category2AudioUrl = [];
//   List<String> category3AudioUrl = [];
//   List<String> allSongsUrl = [];
//   List<String> downloadSongsUrl = [];
//   List<String> queueSongsUrl = [];


//   MainScreenController({int initialIndex = 0})
//       : currentIndex = initialIndex.obs,
//         isMiniPlayerOpen = false.obs,
//         isMiniPlayerOpenHome1 = false.obs,
//         isMiniPlayerOpenHome2 = false.obs,
//         isMiniPlayerOpenHome3 = false.obs,
//         isMiniPlayerOpenAllSongs = false.obs,
//         isMiniPlayerOpenDownloadSongs = false.obs,
//         isMiniPlayerOpenQueueSongs = false.obs,
//         currentListTileIndex = 0.obs,
//         currentListTileIndexCategory1 = 0.obs,
//         currentListTileIndexCategory2 = 0.obs,
//         currentListTileIndexCategory3 = 0.obs,
//         currentListTileIndexAllSongs = 0.obs,
//         currentListTileIndexDownloadSongs = 0.obs,
//         currentListTileIndexQueueSongs = 0.obs;

//   @override
//   void onInit() {
//     // fetchData();
//       currentListTileIndex.value;
//       currentListTileIndexCategory1.value;
//       currentListTileIndexCategory2.value;
//       currentListTileIndexCategory3.value;
//       currentListTileIndexAllSongs.value;
//       currentListTileIndexDownloadSongs.value;
//       currentListTileIndexQueueSongs.value;
//       isMiniPlayerOpen.value;
//       log(isMiniPlayerOpen.value.toString(),
//           name: 'controller isMiniPlayerOpen');
//       log(isMiniPlayerOpenHome1.value.toString(),
//           name: 'controller isMiniPlayerOpenHome1');
//       log(isMiniPlayerOpenHome2.value.toString(),
//           name: 'controller isMiniPlayerOpenHome2');
//       log(isMiniPlayerOpenHome3.value.toString(),
//           name: 'controller isMiniPlayerOpenHome3');
//       log(isMiniPlayerOpenAllSongs.value.toString(),
//           name: 'isMiniPlayerOpenAllSongs');
//       log(currentListTileIndexCategory1.value.toString(),
//           name: 'controller currentListTileIndexCategory1');
//       log(currentListTileIndexAllSongs.value.toString(),
//           name: 'controller currentListTileIndexAllSongs');
//       log(currentListTileIndexDownloadSongs.value.toString(),
//           name: 'controller currentListTileIndexDownloadSongs');
//       log(currentListTileIndexQueueSongs.value.toString(),
//           name: 'controller currentListTileIndexQueueSongs');
//       isMiniPlayerOpenQueueSongs.value == false ||
//               isMiniPlayerOpenDownloadSongs.value == false ||
//               isMiniPlayerOpen.value == false ||
//               isMiniPlayerOpenHome1.value == false ||
//               isMiniPlayerOpenHome2.value == false ||
//               isMiniPlayerOpenHome3.value == false ||
//               isMiniPlayerOpenAllSongs.value == false
//           ? audioPlayer.dispose()
//           : audioPlayer.play();
//       allSongsScreenController.allSongsList();
//       playlistScreenController.songsInPlaylist(playlistId: '');
//       downloadSongScreenController.downloadSongsList();
//       queueSongsScreenController.queueSongsListWithoutPlaylist();
//     // audioPlayer.play();
//     // initAudioPlayer();
//     super.onInit();
//   }

//   void setAudioPlayer(AudioPlayer newAudioPlayer) {
//     audioPlayer = newAudioPlayer;
//   }

//   void changeTab(int index) {
//     currentIndex.value = index;
//   }

//   ////

//   void toggleMiniPlayer(bool isOpen) {
//     isMiniPlayerOpen.value = isOpen;
//   }

//   //////

//   void updateCurrentListTileIndex(int index) {
//     currentListTileIndex.value = index;
//   }

//   void updateCurrentListTileIndexCategory1(int index) {
//     currentListTileIndexCategory1.value = index;
//   }

//   void updateCurrentListTileIndexCategory2(int index) {
//     currentListTileIndexCategory2.value = index;
//   }

//   void updateCurrentListTileIndexCategory3(int index) {
//     currentListTileIndexCategory3.value = index;
//   }

//   void updateCurrentListTileIndexAllSongs(int index) {
//     currentListTileIndexAllSongs.value = index;
//   }

//   void updateCurrentListTileIndexDownloadSongs(int index) {
//     currentListTileIndexDownloadSongs.value = index;
//   }

//   void updateCurrentListTileIndexQueueSongs(int index) {
//     currentListTileIndexQueueSongs.value = index;
//   }

//   /////////

//   void addPlaylistSongAudioUrlToList(String newString) {
//     playlisSongAudioUrl.add(newString);
//     update();
//   }

//   void addCategory1AudioUrlToList(String newString) {
//     category1AudioUrl.add(newString);
//     update();
//   }

//   void addCategory2AudioUrlToList(String newString) {
//     category2AudioUrl.add(newString);
//     update();
//   }

//   void addCategory3AudioUrlToList(String newString) {
//     category3AudioUrl.add(newString);
//     update();
//   }

//   void addAllSongsAudioUrlToList(String newString) {
//     allSongsUrl.add(newString);
//     update();
//   }

//   void addDownloadSongsAudioUrlToList(String newString) {
//     downloadSongsUrl.add(newString);
//     update();
//   }

//   void addQueueSongsAudioUrlToList(String newString) {
//     queueSongsUrl.add(newString);
//     update();
//   }

//   //////////

//   CategoryData? categoryData1;
//   CategoryData? categoryData2;
//   CategoryData? categoryData3;

//   Future<void> fetchData() async {
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
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//     Future<void> initAudioPlayer() async {
//       // List<String> queueSongsUrl = [];
//       // List<String> downloadSongsUrl = [];
//       // List<String> playlistAudioUrl = [];
//       // List<String> category1AudioUrl = [];
//       // List<String> category2AudioUrl = [];
//       // List<String> category3AudioUrl = [];
//       // List<String> allSongsAudioUrl = [];

//       try {
//         // queueSongsUrl = (queueSongsUrl);
//         // downloadSongsUrl = (downloadSongsUrl);
//         // playlistAudioUrl = (playlisSongAudioUrl);
//         // category1AudioUrl = (category1AudioUrl);
//         // category2AudioUrl = (category2AudioUrl);
//         // category3AudioUrl = (category3AudioUrl);
//         // allSongsAudioUrl = (allSongsUrl);
//         log("$category1AudioUrl", name: 'list main screen cat1');
//         log("${currentListTileIndexAllSongs.value}",
//             name: 'currentListTileIndexAllSongs.value');
          
        
//         log("${audioPlayer.playing}",name: 'audio play?');

//         audioPlayer.currentIndexStream.listen((index) {
//           isMiniPlayerOpenQueueSongs.value == true
//               ? currentListTileIndexQueueSongs.value
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? currentListTileIndexDownloadSongs.value
//                   : isMiniPlayerOpen.value == true
//                       ? currentListTileIndex.value = index ?? 0
//                       : isMiniPlayerOpenHome1.value == true
//                           ? currentListTileIndexCategory1.value = index ?? 0
//                           : isMiniPlayerOpenHome2.value == true
//                               ? currentListTileIndexCategory2.value = index ?? 0
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? currentListTileIndexCategory3.value =
//                                       index ?? 0
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       //  &&
//                                       //         allSongsScreenallSongsListModel != null
//                                       ? currentListTileIndexAllSongs.value =
//                                           index ?? 0
//                                       : null;
//         });
//         MediaItem mediaItem = MediaItem(
//           id: isMiniPlayerOpenQueueSongs.value == true
//               ? (queueSongsScreenController.allSongsListModel!
//                   .data![currentListTileIndexQueueSongs.value].id)!
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? (downloadSongScreenController.allSongsListModel!
//                       .data![currentListTileIndexDownloadSongs.value].id)!
//                   : isMiniPlayerOpen.value == true
//                       ? (playlistScreenController.allSongsListModel!
//                           .data![currentListTileIndex.value].id)!
//                       : isMiniPlayerOpenHome1.value == true
//                           ? (categoryData1!
//                               .data![currentListTileIndexCategory1.value].id)!
//                           : isMiniPlayerOpenHome2.value == true
//                               ? (categoryData2!
//                                   .data![currentListTileIndexCategory2.value].id)!
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? (categoryData3!
//                                       .data![currentListTileIndexCategory3.value]
//                                       .id)!
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       ? (allSongsScreenController
//                                           .allSongsListModel!
//                                           .data![
//                                               currentListTileIndexAllSongs.value]
//                                           .id)!
//                                       : '',
//           title: isMiniPlayerOpenQueueSongs.value == true
//               ? (queueSongsScreenController.allSongsListModel!
//                   .data![currentListTileIndexQueueSongs.value].title)!
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? (downloadSongScreenController.allSongsListModel!
//                       .data![currentListTileIndexDownloadSongs.value].title)!
//                   : isMiniPlayerOpen.value == true
//                       ? (playlistScreenController.allSongsListModel!
//                           .data![currentListTileIndex.value].title)!
//                       : isMiniPlayerOpenHome1.value == true
//                           ? (categoryData1!
//                               .data![currentListTileIndexCategory1.value].title)!
//                           : isMiniPlayerOpenHome2.value == true
//                               ? (categoryData2!
//                                   .data![currentListTileIndexCategory2.value]
//                                   .title)!
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? (categoryData3!
//                                       .data![currentListTileIndexCategory3.value]
//                                       .title)!
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       ? (allSongsScreenController
//                                           .allSongsListModel!
//                                           .data![
//                                               currentListTileIndexAllSongs.value]
//                                           .title)!
//                                       : '',
//           album: isMiniPlayerOpenQueueSongs.value == true
//               ? (queueSongsScreenController.allSongsListModel!
//                   .data![currentListTileIndexQueueSongs.value].description)!
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? (downloadSongScreenController
//                       .allSongsListModel!
//                       .data![currentListTileIndexDownloadSongs.value]
//                       .description)!
//                   : isMiniPlayerOpen.value == true
//                       ? (playlistScreenController.allSongsListModel!
//                           .data![currentListTileIndex.value].description)!
//                       : isMiniPlayerOpenHome1.value == true
//                           ? (categoryData1!
//                               .data![currentListTileIndexCategory1.value]
//                               .description)!
//                           : isMiniPlayerOpenHome2.value == true
//                               ? (categoryData2!
//                                   .data![currentListTileIndexCategory2.value]
//                                   .description)!
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? (categoryData3!
//                                       .data![currentListTileIndexCategory3.value]
//                                       .description)!
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       ? (allSongsScreenController
//                                           .allSongsListModel!
//                                           .data![
//                                               currentListTileIndexAllSongs.value]
//                                           .description)!
//                                       : '',
//           artUri: Uri.parse(isMiniPlayerOpenQueueSongs.value == true
//               ? (queueSongsScreenController.allSongsListModel!
//                   .data![currentListTileIndexQueueSongs.value].image)!
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? (downloadSongScreenController.allSongsListModel!
//                       .data![currentListTileIndexDownloadSongs.value].image)!
//                   : isMiniPlayerOpen.value == true
//                       ? (playlistScreenController.allSongsListModel!
//                           .data![currentListTileIndex.value].image)!
//                       : isMiniPlayerOpenHome1.value == true
//                           ? (categoryData1!
//                               .data![currentListTileIndexCategory1.value].image)!
//                           : isMiniPlayerOpenHome2.value == true
//                               ? (categoryData2!
//                                   .data![currentListTileIndexCategory2.value]
//                                   .image)!
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? (categoryData3!
//                                       .data![currentListTileIndexCategory3.value]
//                                       .image)!
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       ? (allSongsScreenController
//                                           .allSongsListModel!
//                                           .data![
//                                               currentListTileIndexAllSongs.value]
//                                           .image)!
//                                       : ''),
//           duration: const Duration(milliseconds: 0),
//         );

//         audioPlayer.setAudioSource(
//           ConcatenatingAudioSource(
//             useLazyPreparation: true,
//             shuffleOrder: DefaultShuffleOrder(),
//             children: isMiniPlayerOpenQueueSongs.value == true
//                 ? queueSongsUrl
//                     .map(
//                       (url) => AudioSource.uri(
//                         Uri.parse(url),
//                         tag: mediaItem,
//                       ),
//                     )
//                     .toList()
//                 : isMiniPlayerOpenDownloadSongs.value == true
//                     ? downloadSongsUrl
//                         .map(
//                           (url) => AudioSource.uri(
//                             Uri.parse(url),
//                             tag: mediaItem,
//                           ),
//                         )
//                         .toList()
//                     : isMiniPlayerOpen.value == true
//                         ? playlisSongAudioUrl
//                             .map(
//                               (url) => AudioSource.uri(
//                                 Uri.parse(url),
//                                 tag: mediaItem,
//                               ),
//                             )
//                             .toList()
//                         : isMiniPlayerOpenHome1.value == true
//                             ? category1AudioUrl
//                                 .map(
//                                   (url) => AudioSource.uri(
//                                     Uri.parse(url),
//                                     tag: mediaItem,
//                                   ),
//                                 )
//                                 .toList()
//                             : isMiniPlayerOpenHome2.value == true
//                                 ? category2AudioUrl
//                                     .map(
//                                       (url) => AudioSource.uri(
//                                         Uri.parse(url),
//                                         tag: mediaItem,
//                                       ),
//                                     )
//                                     .toList()
//                                 : isMiniPlayerOpenHome3.value == true
//                                     ? category3AudioUrl
//                                         .map(
//                                           (url) => AudioSource.uri(
//                                             Uri.parse(url),
//                                             tag: mediaItem,
//                                           ),
//                                         )
//                                         .toList()
//                                     : isMiniPlayerOpenAllSongs.value == true
//                                         ? allSongsUrl
//                                             .map(
//                                               (url) => AudioSource.uri(
//                                                 Uri.parse(url),
//                                                 tag: mediaItem,
//                                               ),
//                                             )
//                                             .toList()
//                                         : category1AudioUrl
//                                             .map(
//                                               (url) => AudioSource.uri(
//                                                 Uri.parse(url),
//                                                 tag: mediaItem,
//                                               ),
//                                             )
//                                             .toList(),
//           ),
//           // AudioSource.uri(

//           //   Uri.parse(category1AudioUrl![
//           //       currentListTileIndexCategory1.value]),
//           //   tag: mediaItem,
//           // ),
//           initialIndex: isMiniPlayerOpenQueueSongs.value == true
//               ? currentListTileIndexQueueSongs.value
//               : isMiniPlayerOpenDownloadSongs.value == true
//                   ? currentListTileIndexDownloadSongs.value
//                   : isMiniPlayerOpen.value == true
//                       ? currentListTileIndex.value
//                       : isMiniPlayerOpenHome1.value == true
//                           ? currentListTileIndexCategory1.value
//                           : isMiniPlayerOpenHome2.value == true
//                               ? currentListTileIndexCategory2.value
//                               : isMiniPlayerOpenHome3.value == true
//                                   ? currentListTileIndexCategory3.value
//                                   : isMiniPlayerOpenAllSongs.value == true
//                                       ? currentListTileIndexAllSongs.value
//                                       : null,
//           preload: true,
//           initialPosition: Duration.zero,
//         );
//         (isMiniPlayerOpenQueueSongs.value) == true &&
//                 (isMiniPlayerOpenDownloadSongs.value) == false &&
//                 (isMiniPlayerOpen.value) == false &&
//                 (isMiniPlayerOpenHome1.value) == false &&
//                 (isMiniPlayerOpenHome2.value) == false &&
//                 (isMiniPlayerOpenHome3.value) == false &&
//                 (isMiniPlayerOpenAllSongs.value) == false &&
//                 queueSongsUrl.isNotEmpty
//             ? await audioPlayer.setLoopMode(LoopMode.all)
//             : await audioPlayer.setLoopMode(LoopMode.off);
//             await audioPlayer.play();
//             log('${audioPlayer.playing}',name: 'check init playing ????');
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error initializing audio player: $e');
//         }
//       }
//     }
// }
	