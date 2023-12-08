import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/album_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/artist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siri_wave/siri_wave.dart';

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
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  ProfileController profileController = Get.put(ProfileController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());

  AudioPlayer audioPlayer = AudioPlayer();

  final apiHelper = ApiHelper();

  var musicPlay = false.obs;

  final RxInt currentIndex;
  final RxBool isMiniPlayerOpen;
  final RxBool isMiniPlayerOpenHome;
  final RxBool isMiniPlayerOpenHome1;
  final RxBool isMiniPlayerOpenHome2;
  final RxBool isMiniPlayerOpenHome3;
  final RxBool isMiniPlayerOpenAllSongs;
  final RxBool isMiniPlayerOpenDownloadSongs;
  final RxBool isMiniPlayerOpenQueueSongs;
  final RxBool isMiniPlayerOpenFavoriteSongs;
  final RxBool isMiniPlayerOpenAlbumSongs;
  final RxBool isMiniPlayerOpenArtistSongs;

  // final RxBool isMiniPlayerOpen;
  final RxInt currentListTileIndex;
  final RxInt currentListTileIndexCategory;
  final RxInt currentListTileIndexCategoryData;
  final RxInt currentListTileIndexCategory1;
  final RxInt currentListTileIndexCategory2;
  final RxInt currentListTileIndexCategory3;
  final RxInt currentListTileIndexAllSongs;
  final RxInt currentListTileIndexDownloadSongs;
  final RxInt currentListTileIndexQueueSongs;
  final RxInt currentListTileIndexFavoriteSongs;
  final RxInt currentListTileIndexAlbumSongs;
  final RxInt currentListTileIndexArtistSongs;

  /////
  // AudioPlayer? audioPlayer;
  List<String> categoryAudioUrl = [];
  List<String> playlisSongAudioUrl = [];
  List<String> category1AudioUrl = [];
  List<String> category2AudioUrl = [];
  List<String> category3AudioUrl = [];
  List<String> allSongsUrl = [];
  List<String> downloadSongsUrl = [];
  List<String> queueSongsUrl = [];
  List<String> favoriteSongsUrl = [];
  List<String> albumSongsUrl = [];
  List<String> artistSongsUrl = [];

  MainScreenController({int initialIndex = 0})
      : currentIndex = initialIndex.obs,
        isMiniPlayerOpen = false.obs,
        isMiniPlayerOpenHome = false.obs,
        isMiniPlayerOpenHome1 = false.obs,
        isMiniPlayerOpenHome2 = false.obs,
        isMiniPlayerOpenHome3 = false.obs,
        isMiniPlayerOpenAllSongs = false.obs,
        isMiniPlayerOpenDownloadSongs = false.obs,
        isMiniPlayerOpenQueueSongs = false.obs,
        isMiniPlayerOpenFavoriteSongs = false.obs,
        isMiniPlayerOpenAlbumSongs = false.obs,
        isMiniPlayerOpenArtistSongs = false.obs,
        currentListTileIndex = 0.obs,
        currentListTileIndexCategory = 0.obs,
        currentListTileIndexCategoryData = 0.obs,
        currentListTileIndexCategory1 = 0.obs,
        currentListTileIndexCategory2 = 0.obs,
        currentListTileIndexCategory3 = 0.obs,
        currentListTileIndexAllSongs = 0.obs,
        currentListTileIndexDownloadSongs = 0.obs,
        currentListTileIndexQueueSongs = 0.obs,
        currentListTileIndexFavoriteSongs = 0.obs,
        currentListTileIndexAlbumSongs = 0.obs,
        currentListTileIndexArtistSongs = 0.obs;

  @override
  void onInit() {
    fetchData();
    homeScreenController.homeCategories();
    homeScreenController.recentSongsList();
    allSongsScreenController.allSongsList();
    playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);
    downloadSongScreenController.downloadSongsList();
    queueSongsScreenController.queueSongsListWithoutPlaylist();
    favoriteSongScreenController.favoriteSongsList();
    albumScreenController.albumsSongsList(albumId: GlobVar.albumId);
    artistScreenController.artistsSongsList(artistId: GlobVar.artistId);
    // profileController.fetchProfile();
    initAudioPlayer();
    // isMiniPlayerOpenQueueSongs.value == false ||
    //           isMiniPlayerOpenDownloadSongs.value == false ||
    //           isMiniPlayerOpen.value == false ||
    //           isMiniPlayerOpenHome1.value == false ||
    //           isMiniPlayerOpenHome2.value == false ||
    //           isMiniPlayerOpenHome3.value == false ||
    //           isMiniPlayerOpenAllSongs.value == false
    //       ? audioPlayer.dispose()
    //       : audioPlayer.play();
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

  void updateCurrentListTileIndexCategory(int index) {
    currentListTileIndexCategoryData.value = index;
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

  void updateCurrentListTileIndexFavoriteSongs(int index) {
    currentListTileIndexFavoriteSongs.value = index;
  }

  void updateCurrentListTileIndexAlbumSongs(int index) {
    currentListTileIndexAlbumSongs.value = index;
  }

  void updateCurrentListTileIndexArtistSongs(int index) {
    currentListTileIndexArtistSongs.value = index;
  }

  /////////

  void addPlaylistSongAudioUrlToList(String newString) {
    playlisSongAudioUrl.add(newString);
    update();
  }

  void addCategoryAudioUrlToList(String newString) {
    categoryAudioUrl.add(newString);
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

  void addFavoriteSongsAudioUrlToList(String newString) {
    favoriteSongsUrl.add(newString);
    update();
  }

  void addAlbumSongsAudioUrlToList(String newString) {
    albumSongsUrl.add(newString);
    update();
  }

  void addArtistSongsAudioUrlToList(String newString) {
    artistSongsUrl.add(newString);
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

  final siriWaveController = IOS9SiriWaveformController(
    amplitude: 1,
    speed: 0.1,
  );

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
        isMiniPlayerOpenArtistSongs.value == true
            ? currentListTileIndexArtistSongs.value = index ?? 0
            : isMiniPlayerOpenAlbumSongs.value == true
                ? currentListTileIndexAlbumSongs.value = index ?? 0
                : isMiniPlayerOpenFavoriteSongs.value == true
                    ? currentListTileIndexFavoriteSongs.value = index ?? 0
                    : isMiniPlayerOpenQueueSongs.value == true
                        ? currentListTileIndexQueueSongs.value = index ?? 0
                        : isMiniPlayerOpenDownloadSongs.value == true
                            ? currentListTileIndexDownloadSongs.value =
                                index ?? 0
                            : isMiniPlayerOpen.value == true
                                ? currentListTileIndex.value = index ?? 0
                                // home
                                : isMiniPlayerOpenHome.value == true
                                    ? currentListTileIndexCategoryData.value =
                                        index ?? 0
                                    : isMiniPlayerOpenHome1.value == true
                                        ? currentListTileIndexCategory1.value =
                                            index ?? 0
                                        : isMiniPlayerOpenHome2.value == true
                                            ? currentListTileIndexCategory2
                                                .value = index ?? 0
                                            : isMiniPlayerOpenHome3.value ==
                                                    true
                                                ? currentListTileIndexCategory3
                                                    .value = index ?? 0
                                                : isMiniPlayerOpenAllSongs
                                                            .value ==
                                                        true
                                                    //  &&
                                                    //         allSongsScreenallSongsListModel != null
                                                    ? currentListTileIndexAllSongs
                                                        .value = index ?? 0
                                                    : null;
        if (playlistScreenController.allSongsListModel != null) {
          playlistScreenController.currentPlayingImage.value =
              (playlistScreenController
                  .allSongsListModel!.data![currentListTileIndex.value].image)!;
          playlistScreenController.currentPlayingTitle.value =
              (playlistScreenController
                  .allSongsListModel!.data![currentListTileIndex.value].title)!;
          playlistScreenController.currentPlayingDesc.value =
              (playlistScreenController.allSongsListModel!
                  .data![currentListTileIndex.value].description)!;
          log(playlistScreenController.currentPlayingImage.value,
              name: 'playlistScreenController.currentPlayingImage.value');
          log(playlistScreenController.currentPlayingTitle.value,
              name: 'playlistScreenController.currentPlayingTitle.value');
          log(playlistScreenController.currentPlayingDesc.value,
              name: 'playlistScreenController.currentPlayingDesc.value');
        }
        if(artistScreenController.allSongsListModel != null){
          artistScreenController.currentPlayingImage.value =
              (artistScreenController
                  .allSongsListModel!.data![currentListTileIndexArtistSongs.value].image)!;
          artistScreenController.currentPlayingTitle.value =
              (artistScreenController
                  .allSongsListModel!.data![currentListTileIndexArtistSongs.value].title)!;
          artistScreenController.currentPlayingDesc.value =
              (artistScreenController.allSongsListModel!
                  .data![currentListTileIndexArtistSongs.value].description)!;
          artistScreenController.currentPlayingId.value =
              (artistScreenController.allSongsListModel!
                  .data![currentListTileIndexArtistSongs.value].id)!;
          artistScreenController.currentPlayingAudio.value =
              (artistScreenController.allSongsListModel!
                  .data![currentListTileIndexArtistSongs.value].audio)!;
          artistScreenController.currentPlayingIsLiked.value =
              (artistScreenController.allSongsListModel!
                  .data![currentListTileIndexArtistSongs.value].isLiked)!;
          log(artistScreenController.currentPlayingImage.value,
              name: 'artistScreenController.currentPlayingImage.value');
          log(artistScreenController.currentPlayingTitle.value,
              name: 'artistScreenController.currentPlayingTitle.value');
          log(artistScreenController.currentPlayingDesc.value,
              name: 'artistScreenController.currentPlayingDesc.value');
        }
      });

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          shuffleOrder: DefaultShuffleOrder(),
          children: isMiniPlayerOpenArtistSongs.value == true
              ? artistSongsUrl.map((url) {
                  int index = artistSongsUrl.indexOf(url);
                  return AudioSource.uri(
                    Uri.parse(url),
                    tag: MediaItem(
                      id: (artistScreenController
                          .allSongsListModel!.data![index].id)!,
                      title: (artistScreenController
                          .allSongsListModel!.data![index].title)!,
                      album: (artistScreenController
                          .allSongsListModel!.data![index].description)!,
                      artUri: Uri.parse((artistScreenController
                          .allSongsListModel!.data![index].image)!),
                    ),
                  );
                }).toList()
              : isMiniPlayerOpenAlbumSongs.value == true
                  ? albumSongsUrl.map((url) {
                      int index = albumSongsUrl.indexOf(url);
                      return AudioSource.uri(
                        Uri.parse(url),
                        tag: MediaItem(
                          id: (albumScreenController
                              .allSongsListModel!.data![index].id)!,
                          title: (albumScreenController
                              .allSongsListModel!.data![index].title)!,
                          album: (albumScreenController
                              .allSongsListModel!.data![index].description)!,
                          artUri: Uri.parse((albumScreenController
                              .allSongsListModel!.data![index].image)!),
                        ),
                      );
                    }).toList()
                  : isMiniPlayerOpenFavoriteSongs.value == true
                      ? favoriteSongsUrl.map((url) {
                          int index = favoriteSongsUrl.indexOf(url);
                          return AudioSource.uri(
                            Uri.parse(url),
                            tag: MediaItem(
                              id: (favoriteSongScreenController
                                  .allSongsListModel!.data![index].id)!,
                              title: (favoriteSongScreenController
                                  .allSongsListModel!.data![index].title)!,
                              album: (favoriteSongScreenController
                                  .allSongsListModel!
                                  .data![index]
                                  .description)!,
                              artUri: Uri.parse((favoriteSongScreenController
                                  .allSongsListModel!.data![index].image)!),
                            ),
                          );
                        }).toList()
                      : isMiniPlayerOpenQueueSongs.value == true
                          ? queueSongsUrl.map((url) {
                              int index = queueSongsUrl.indexOf(url);
                              return AudioSource.uri(
                                Uri.parse(url),
                                tag: MediaItem(
                                  id: (queueSongsScreenController
                                      .allSongsListModel!.data![index].id)!,
                                  title: (queueSongsScreenController
                                      .allSongsListModel!.data![index].title)!,
                                  album: (queueSongsScreenController
                                      .allSongsListModel!
                                      .data![index]
                                      .description)!,
                                  artUri: Uri.parse((queueSongsScreenController
                                      .allSongsListModel!.data![index].image)!),
                                ),
                              );
                            }).toList()
                          : isMiniPlayerOpenDownloadSongs.value == true
                              ? downloadSongsUrl.map((url) {
                                  int index = downloadSongsUrl.indexOf(url);
                                  return AudioSource.uri(
                                    Uri.parse(url),
                                    tag: MediaItem(
                                      id: (downloadSongScreenController
                                          .allSongsListModel!.data![index].id)!,
                                      title: (downloadSongScreenController
                                          .allSongsListModel!
                                          .data![index]
                                          .title)!,
                                      album: (downloadSongScreenController
                                          .allSongsListModel!
                                          .data![index]
                                          .description)!,
                                      artUri: Uri.parse(
                                          (downloadSongScreenController
                                              .allSongsListModel!
                                              .data![index]
                                              .image)!),
                                    ),
                                  );
                                }).toList()
                              : isMiniPlayerOpen.value == true
                                  ? playlisSongAudioUrl.map((url) {
                                      int index =
                                          playlisSongAudioUrl.indexOf(url);
                                      return AudioSource.uri(
                                        Uri.parse(url),
                                        tag: MediaItem(
                                          id: (playlistScreenController
                                              .allSongsListModel!
                                              .data![index]
                                              .id)!,
                                          title: (playlistScreenController
                                              .allSongsListModel!
                                              .data![index]
                                              .title)!,
                                          album: (playlistScreenController
                                              .allSongsListModel!
                                              .data![index]
                                              .description)!,
                                          artUri: Uri.parse(
                                              (playlistScreenController
                                                  .allSongsListModel!
                                                  .data![index]
                                                  .image)!),
                                        ),
                                      );
                                    }).toList()
                                  : isMiniPlayerOpenHome.value == true
                                      ? categoryAudioUrl.map((url) {
                                          int index =
                                              categoryAudioUrl.indexOf(url);
                                          return AudioSource.uri(
                                            Uri.parse(url),
                                            tag: MediaItem(
                                              id: (homeScreenController
                                                  .homeCategoryData[
                                                      currentListTileIndexCategory
                                                          .value]
                                                  .categoryData[index]
                                                  .id)!,
                                              title: (homeScreenController
                                                  .homeCategoryData[
                                                      currentListTileIndexCategory
                                                          .value]
                                                  .categoryData[index]
                                                  .title)!,
                                              album: (homeScreenController
                                                  .homeCategoryData[
                                                      currentListTileIndexCategory
                                                          .value]
                                                  .categoryData[index]
                                                  .description)!,
                                              artUri: Uri.parse(
                                                  (homeScreenController
                                                      .homeCategoryData[
                                                          currentListTileIndexCategory
                                                              .value]
                                                      .categoryData[index]
                                                      .image)!),
                                            ),
                                          );
                                        }).toList()
                                      : isMiniPlayerOpenHome1.value == true
                                          ? category1AudioUrl.map((url) {
                                              int index = category1AudioUrl
                                                  .indexOf(url);
                                              return AudioSource.uri(
                                                Uri.parse(url),
                                                tag: MediaItem(
                                                  id: (categoryData1!
                                                      .data![index].id)!,
                                                  title: (categoryData1!
                                                      .data![index].title)!,
                                                  album: (categoryData1!
                                                      .data![index]
                                                      .description)!,
                                                  artUri: Uri.parse(
                                                      (categoryData1!
                                                          .data![index]
                                                          .image)!),
                                                ),
                                              );
                                            }).toList()
                                          : isMiniPlayerOpenHome2.value == true
                                              ? category2AudioUrl.map((url) {
                                                  int index = category2AudioUrl
                                                      .indexOf(url);
                                                  return AudioSource.uri(
                                                    Uri.parse(url),
                                                    tag: MediaItem(
                                                      id: (categoryData2!
                                                          .data![index].id)!,
                                                      title: (categoryData2!
                                                          .data![index].title)!,
                                                      album: (categoryData2!
                                                          .data![index]
                                                          .description)!,
                                                      artUri: Uri.parse(
                                                          (categoryData2!
                                                              .data![index]
                                                              .image)!),
                                                    ),
                                                  );
                                                }).toList()
                                              : isMiniPlayerOpenHome3.value ==
                                                      true
                                                  ? category3AudioUrl
                                                      .map((url) {
                                                      int index =
                                                          category3AudioUrl
                                                              .indexOf(url);
                                                      return AudioSource.uri(
                                                        Uri.parse(url),
                                                        tag: MediaItem(
                                                          id: (categoryData3!
                                                              .data![index]
                                                              .id)!,
                                                          title: (categoryData3!
                                                              .data![index]
                                                              .title)!,
                                                          album: (categoryData3!
                                                              .data![index]
                                                              .description)!,
                                                          artUri: Uri.parse(
                                                              (categoryData3!
                                                                  .data![index]
                                                                  .image)!),
                                                        ),
                                                      );
                                                    }).toList()
                                                  : isMiniPlayerOpenAllSongs
                                                              .value ==
                                                          true
                                                      ? allSongsUrl.map((url) {
                                                          int index =
                                                              allSongsUrl
                                                                  .indexOf(url);
                                                          return AudioSource
                                                              .uri(
                                                            Uri.parse(url),
                                                            tag: MediaItem(
                                                              id: (allSongsScreenController
                                                                  .allSongsListModel!
                                                                  .data![index]
                                                                  .id)!,
                                                              title: (allSongsScreenController
                                                                  .allSongsListModel!
                                                                  .data![index]
                                                                  .title)!,
                                                              album: (allSongsScreenController
                                                                  .allSongsListModel!
                                                                  .data![index]
                                                                  .description)!,
                                                              artUri: Uri.parse(
                                                                  (allSongsScreenController
                                                                      .allSongsListModel!
                                                                      .data![
                                                                          index]
                                                                      .image)!),
                                                            ),
                                                          );
                                                        }).toList()
                                                      : category1AudioUrl
                                                          .map((url) {
                                                          int index =
                                                              category1AudioUrl
                                                                  .indexOf(url);
                                                          return AudioSource
                                                              .uri(
                                                            Uri.parse(url),
                                                            tag: MediaItem(
                                                              id: (categoryData1!
                                                                  .data![index]
                                                                  .id)!,
                                                              title:
                                                                  (categoryData1!
                                                                      .data![
                                                                          index]
                                                                      .title)!,
                                                              album: (categoryData1!
                                                                  .data![index]
                                                                  .description)!,
                                                              artUri: Uri.parse(
                                                                  (categoryData1!
                                                                      .data![
                                                                          index]
                                                                      .image)!),
                                                            ),
                                                          );
                                                        }).toList(),
        ),
        // AudioSource.uri(

        //   Uri.parse(category1AudioUrl![
        //       currentListTileIndexCategory1.value]),
        //   tag: mediaItem,
        // ),
        initialIndex: isMiniPlayerOpenArtistSongs.value == true
            ? currentListTileIndexArtistSongs.value
            : isMiniPlayerOpenAlbumSongs.value == true
                ? currentListTileIndexAlbumSongs.value
                : isMiniPlayerOpenFavoriteSongs.value == true
                    ? currentListTileIndexFavoriteSongs.value
                    : isMiniPlayerOpenQueueSongs.value == true
                        ? currentListTileIndexQueueSongs.value
                        : isMiniPlayerOpenDownloadSongs.value == true
                            ? currentListTileIndexDownloadSongs.value
                            : isMiniPlayerOpen.value == true
                                ? currentListTileIndex.value
                                : isMiniPlayerOpenHome.value == true
                                    ? currentListTileIndexCategoryData.value
                                    : isMiniPlayerOpenHome1.value == true
                                        ? currentListTileIndexCategory1.value
                                        : isMiniPlayerOpenHome2.value == true
                                            ? currentListTileIndexCategory2
                                                .value
                                            : isMiniPlayerOpenHome3.value ==
                                                    true
                                                ? currentListTileIndexCategory3
                                                    .value
                                                : isMiniPlayerOpenAllSongs
                                                            .value ==
                                                        true
                                                    ? currentListTileIndexAllSongs
                                                        .value
                                                    : null,
        preload: false,
        initialPosition: Duration.zero,
      );
      (isMiniPlayerOpenQueueSongs.value) == true &&
              (isMiniPlayerOpenDownloadSongs.value) == false &&
              (isMiniPlayerOpen.value) == false &&
              (isMiniPlayerOpenHome.value) == false &&
              (isMiniPlayerOpenHome1.value) == false &&
              (isMiniPlayerOpenHome2.value) == false &&
              (isMiniPlayerOpenHome3.value) == false &&
              (isMiniPlayerOpenFavoriteSongs.value) == false &&
              (isMiniPlayerOpenAlbumSongs.value) == false &&
              (isMiniPlayerOpenArtistSongs.value) == false &&
              (isMiniPlayerOpenAllSongs.value) == false &&
              queueSongsUrl.isNotEmpty
          ? await audioPlayer.setLoopMode(LoopMode.all)
          : await audioPlayer.setLoopMode(LoopMode.off);
      await audioPlayer.play();
      log('${audioPlayer.playing}', name: 'check init playing ?');
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
