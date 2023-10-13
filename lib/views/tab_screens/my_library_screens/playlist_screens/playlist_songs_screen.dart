import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/add_songs_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/playlist_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

// ignore: unused_import
import '../../../../models/my_playlist_data_model.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistTitle;
  // final Data myPlaylistData;
  // ignore: prefer_typing_uninitialized_variables
  final myPlaylistData;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistTitle,
    required this.myPlaylistData,
  });

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final AudioPlayer audioPlayer = AudioPlayer();

  List<int> checkedIds = [];

  List<String> audioSongIds = [];
  List<String> audioSongUrls = [];

  // bool downloading = false;
  // double downloadProgress = 0.0;
  bool isLoding = false;

  bool? isMiniPlayerOpen;
  // int currentAudioIndex = 0;
  int currentListTileIndex = 0;
  int? currentListTileIndexPrev;

  @override
  void initState() {
    super.initState();
    playlistScreenController.songsInPlaylist(
      playlistId: (widget.myPlaylistData.id)!,
    );

    fetchData();
    // controller.initAudioPlayer();
    sharedPref();
    playlistScreenController.queueAudioUrls == [];
    playlistScreenController.queueSongIds == [];
    playlistScreenController.queueSongsList(
        playlistId: (widget.myPlaylistData.id)!);
    setState(() {
      controller.isMiniPlayerOpen.value == true ||
              controller.isMiniPlayerOpenDownloadSongs.value == true ||
              controller.isMiniPlayerOpenHome1.value == true ||
              controller.isMiniPlayerOpenHome2.value == true ||
              controller.isMiniPlayerOpenHome3.value == true ||
              controller.isMiniPlayerOpenAllSongs.value == true
          ? controller.audioPlayer.play()
          : null;
    });

    allSongsScreenController.allSongsList();
    downloadSongScreenController.downloadSongsList();
    // playQueue();
    // ignore: unnecessary_null_comparison
    // controller.audioPlayer != null ? (controller.audioPlayer).dispose() : null;
  }

  // playQueue() {
  //   (playlistScreenController.queueAudioUrls.isNotEmpty &&
  //           controller.isMiniPlayerOpenDownloadSongs.value == false &&
  //           controller.isMiniPlayerOpenHome1.value == false &&
  //           controller.isMiniPlayerOpenHome2.value == false &&
  //           controller.isMiniPlayerOpenHome3.value == false &&
  //           controller.isMiniPlayerOpenAllSongs.value == false)
  //       ? (controller.isMiniPlayerOpen.value = true)
  //       : null;
  // }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen');
    currentListTileIndexPrev = prefs.getInt('currentListTileIndex');
  }

  final apiHelper = ApiHelper();

  bool isLoading = false;
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
  void dispose() {
    // audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainScreenController controller = Get.find();
    controller.playlisSongAudioUrl = [];
    // controller.setAudioPlayer(audioPlayer);
    if (kDebugMode) {
      print(checkedIds);
      print(audioSongIds);
      print(audioSongUrls);
    }

    log(currentListTileIndex.toString());
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.offAll(const PlylistScreen());
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              playlistBottomSheet(
                                  context, widget.playlistTitle);
                            },
                            icon: Icon(
                              Icons.more_vert_outlined,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        padding: const EdgeInsets.all(60),
                        color: const Color(0xFF30343d),
                        child: Icon(
                          Icons.music_note,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    sizeBoxHeight(70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            playlistScreenController.isLoading.value == true
                                ? null
                                : setState(() {
                                    isMiniPlayerOpen = true;
                                    controller.initAudioPlayer();
                                  });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isMiniPlayerOpen', true);
                          },
                          child: containerIcon(
                            borderRadius: 30,
                            height: 55,
                            width: 55,
                            icon: Icons.play_arrow_outlined,
                            iconSize: 38,
                            iconColor: Colors.white,
                            containerColor: const Color(0xFF2ac5b3),
                          ),
                        ),
                      ),
                    ),
                    sizeBoxHeight(15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: lable(
                          text: widget.playlistTitle,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    sizeBoxHeight(10),
                    Obx(
                      () => playlistScreenController.isLoading.value == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            )
                          : playlistScreenController.allSongsListModel == null
                              ? Center(
                                  child: lable(text: 'Loading...'),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: playlistScreenController
                                      .allSongsListModel!.data!.length,
                                  itemBuilder: (context, index) {
                                    var playlistSongsData =
                                        playlistScreenController
                                            .allSongsListModel!.data![index];

                                    final localFilePath =
                                        '${AppStrings.localPathMusic}/${playlistSongsData.id}.mp3';
                                    final file = File(localFilePath);

                                    log(
                                        playlistScreenController.queueAudioUrls
                                            .toString(),
                                        name: 'queue songs');
                                    log(
                                        playlistScreenController.queueSongIds
                                            .toString(),
                                        name: 'queue songs id');

                                    // bool idIsAvailableLocally = false;

                                    // Iterate through your list of IDs to check if the current ID is available locally
                                    if (playlistScreenController
                                        .queueAudioUrls.isNotEmpty) {
                                      for (var quequeUrl
                                          in playlistScreenController
                                              .queueAudioUrls) {
                                        controller
                                            .addPlaylistSongAudioUrlToList(
                                                quequeUrl);
                                      }
                                    } else {
                                      controller.addPlaylistSongAudioUrlToList(
                                          file.existsSync()
                                              ? localFilePath
                                              : (playlistSongsData.audio)!);
                                    }
                                    controller.playlisSongAudioUrl = controller
                                        .playlisSongAudioUrl
                                        .toSet()
                                        .toList();
                                    log(controller.playlisSongAudioUrl
                                        .toString());

                                    checkedIds
                                        .add(int.parse(playlistSongsData.id!));
                                    audioSongIds.add((playlistSongsData.id)!);
                                    audioSongUrls
                                        .add((playlistSongsData.audio)!);

                                    checkedIds = checkedIds.toSet().toList();
                                    audioSongIds =
                                        audioSongIds.toSet().toList();

                                    audioSongUrls =
                                        audioSongUrls.toSet().toList();

                                    return ListTile(
                                      onTap: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.setBool(
                                            'isMiniPlayerOpen', true);
                                        await prefs.setBool(
                                            'isMiniPlayerOpenHome1', false);
                                        setState(() {
                                          // controller.audioPlayer.pause();
                                          // isMiniPlayerOpen = true;
                                          controller.isMiniPlayerOpen.value =
                                              true;
                                          controller
                                              .isMiniPlayerOpenDownloadSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenHome1
                                              .value = false;
                                          controller.isMiniPlayerOpenHome2
                                              .value = false;
                                          controller.isMiniPlayerOpenHome3
                                              .value = false;
                                          controller.isMiniPlayerOpenAllSongs
                                              .value = false;
                                          currentListTileIndex = index;
                                          controller.updateCurrentListTileIndex(
                                              index);
                                          log(
                                              controller
                                                  .currentListTileIndex.value
                                                  .toString(),
                                              name:
                                                  'currentListTileIndex playlist song log');
                                          // audioPlayer.playing
                                          //     ? audioPlayer.stop()
                                          //     : null;
                                          controller.audioPlayer.play();
                                        });
                                        await prefs.setInt(
                                            'currentListTileIndex',
                                            currentListTileIndex);
                                        homeScreenController.addRecentSongs(
                                            musicId: playlistScreenController
                                                .allSongsListModel!
                                                .data![controller
                                                    .currentListTileIndex.value]
                                                .id!);
                                      },
                                      contentPadding: const EdgeInsets.only(
                                          left: 23, right: 0.0),
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -1.5),
                                      title: Obx(
                                        () => lable(
                                          text: (playlistSongsData.title)!,
                                          fontSize: 11,
                                          color: playlistScreenController
                                                              .allSongsListModel!
                                                              .data![
                                                          controller
                                                              .currentListTileIndex
                                                              .value] ==
                                                      playlistScreenController
                                                          .allSongsListModel!
                                                          .data![index] &&
                                                  controller.isMiniPlayerOpen
                                                          .value ==
                                                      true
                                              ? const Color(0xFF2ac5b3)
                                              : isMiniPlayerOpen == false
                                                  ? Colors.white
                                                  : Colors.white,
                                        ),
                                      ),
                                      subtitle: lable(
                                          text:
                                              (playlistSongsData.description)!,
                                          color: Colors.grey.shade400,
                                          fontSize: 10),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              songBottomSheet(
                                                  context,
                                                  index,
                                                  playlistSongsData,
                                                  widget.myPlaylistData);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.more_vert_outlined,
                                            color: AppColors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                    ),
                    sizeBoxHeight(5),
                    Bounce(
                      duration: const Duration(seconds: 2),
                      onPressed: () {
                        Get.off(
                          AddSongsScreen(
                            myPlaylistId: (widget.myPlaylistData.id)!,
                            playlistTitle: widget.playlistTitle,
                            checkedIds: checkedIds.toList(),
                          ),
                          transition: Transition.fade,
                        );
                        allSongsScreenController.allSongsList();
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const BoxDecoration(
                            color: Color(0xFF30343d),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.grey.shade400,
                            ),
                            sizeBoxWidth(6),
                            lable(
                              text: AppStrings.addMore,
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    sizeBoxHeight(15),
                  ],
                ),
              ),
            ),
          ],
        ),
        //    final prefs = await SharedPreferences.getInstance();
        // final authToken = prefs.getString('token') ?? '';

        bottomNavigationBar: Obx(
          () => (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
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
                          : (controller.isMiniPlayerOpenHome3.value) == true &&
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
        ),
      ),
    );
  }

 

  Future<dynamic> playlistBottomSheet(
    BuildContext context,
    String playlistTitle,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (context) {
        return SizedBox(
          // height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Scaffold(
              backgroundColor: const Color(0xFF30343d),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 95,
                      width: double.maxFinite,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: lable(
                        text: playlistTitle,
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                    ),
                    sizeBoxHeight(15),
                    GestureDetector(
                      onTap: () async {
                        Get.back();
                        playlistScreenController.isLoading.value == true
                            ? null
                            : setState(() {
                                isMiniPlayerOpen = true;
                                controller.initAudioPlayer();
                              });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isMiniPlayerOpen', true);
                      },
                      child: commonListTilePlaylist(
                        icon: Icons.play_arrow_outlined,
                        text: AppStrings.playNow,
                      ),
                    ),
                    commonListTilePlaylist(
                      icon: Icons.close,
                      text: AppStrings.deletePlaylist,
                    ),
                    commonListTilePlaylist(
                      icon: Icons.playlist_add_outlined,
                      text: AppStrings.addToQueue,
                    ),
                    commonListTilePlaylist(
                      icon: Icons.download,
                      text: AppStrings.download,
                    ),
                    sizeBoxHeight(17),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ac5b3),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: lable(
                          text: AppStrings.cancel,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Container(
                transform: Matrix4.translationValues(
                  0.0,
                  -70,
                  0.0,
                ),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF30343d),
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF30343d),
                    child: Icon(
                      Icons.music_note,
                      color: AppColors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerTop,
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> songBottomSheet(
      BuildContext context, int index, playlistSongsData, myPlaylistData) {
    log(index.toString());
    setState(() {
      playlistScreenController.index.value = index;
    });

    Future<void> downloadAudio(index) async {
      final url =
          playlistScreenController.allSongsListModel!.data![index].audio;
      final id = playlistScreenController.allSongsListModel!.data![index].id;

      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        final filePath = '${directory.path}/$id.mp3';
        log(filePath, name: 'file path audio');

        try {
          playlistScreenController.downloading.value = true;
          final dio = Dio();
          final response = await dio.download(
            url!,
            filePath,
            onReceiveProgress: (received, total) {
              playlistScreenController.downloadProgress.value =
                  received / total;
            },
          );

          if (response.statusCode == 200) {
            playlistScreenController.downloading.value = false;
            detailScreenController.addSongInDownloadlist(
                musicId: (playlistScreenController
                    .allSongsListModel!.data![index].id)!);
            detailScreenController.songExistsLocally.value = true;
            playlistScreenController.downloadProgress.value = 0.0;
            playlistScreenController.songsInPlaylist(playlistId: '');
            playlistScreenController
                .allSongsListModel!
                .data![playlistScreenController.index.value]
                .is_loadning = false;
            snackBar(AppStrings.audioDownloadSuccessfully);
          } else {
            final file = File(filePath);
            if (await file.exists()) {
              await file.delete();
            }
            playlistScreenController.downloading.value = false;
            snackBar('Failed to download audio');
          }
        } on DioException catch (_) {
          playlistScreenController.downloading.value = false;
          snackBar(AppStrings.internetNotAvailable);
        } catch (e) {
          final file = File(filePath);
          if (await file.exists()) {
            file.deleteSync();
          }
          playlistScreenController.downloading.value = false;
          if (kDebugMode) {
            print(e);
          }
          snackBar('Error :$e');
          return;
        }
      }
    }

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SizedBox(
            // height: 500,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Scaffold(
                backgroundColor: const Color(0xFF30343d),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 95,
                        width: double.maxFinite,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: Get.width * 0.6,
                          child: lable(
                            text: (playlistScreenController
                                .allSongsListModel!.data![index].title)!,
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      // sizeBoxHeight(2),
                      SizedBox(
                        width: Get.width * 0.85,
                        child: Align(
                          alignment: Alignment.center,
                          child: lable(
                            text: (playlistScreenController
                                .allSongsListModel!.data![index].description)!,
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      sizeBoxHeight(15),
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isMiniPlayerOpen', true);
                          await prefs.setBool('isMiniPlayerOpenHome1', false);
                          setState(() {
                            isMiniPlayerOpen = true;
                            controller.isMiniPlayerOpen.value = true;
                            controller.isMiniPlayerOpenDownloadSongs.value =
                                false;
                            controller.isMiniPlayerOpenHome1.value = false;
                            controller.isMiniPlayerOpenHome2.value = false;
                            controller.isMiniPlayerOpenHome3.value = false;
                            controller.isMiniPlayerOpenAllSongs.value = false;
                            controller.currentListTileIndex.value = index;
                            // audioPlayer.playing ? audioPlayer.stop() : null;
                            controller.initAudioPlayer();
                          });
                          await prefs.setInt(
                              'currentListTileIndex', currentListTileIndex);
                        },
                        child: commonListTilePlaylist(
                          icon: Icons.play_arrow_outlined,
                          text: AppStrings.playNow,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          playlistScreenController
                              .removeSongsFromPlaylist(
                            musicId: (playlistScreenController
                                .allSongsListModel!.data![index].id)!,
                            playlistId: (widget.myPlaylistData.id)!,
                          )
                              .then((value) {
                            setState(() {
                              checkedIds.remove(int.parse(
                                  (playlistScreenController
                                      .allSongsListModel!.data![index].id)!));
                              checkedIds.toList();
                            });

                            playlistScreenController.songsInPlaylist(
                              playlistId: (widget.myPlaylistData.id)!,
                            );
                          });
                          Get.back();
                          snackBar('Remove song from ${widget.playlistTitle}');
                        },
                        child: commonListTilePlaylist(
                          icon: Icons.close,
                          text: AppStrings.removeFromLibrary,
                        ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap: () async  {
                            playlistScreenController.index.value = index;
                            log(myPlaylistData.id.toString());
                            log((playlistScreenController
                                .allSongsListModel!
                                .data![playlistScreenController.index.value]
                                .id)!);
                            // setState(() {
                            playlistScreenController
                                .addQueueSong(
                                    musicId: (playlistScreenController
                                        .allSongsListModel!
                                        .data![playlistScreenController
                                            .index.value]
                                        .id)!,
                                    playlistId: (myPlaylistData.id)!)
                                .then((value) {
                              setState(() {
                                (playlistScreenController
                                            .allSongsListModel!
                                            .data![playlistScreenController
                                                .index.value]
                                            .is_queue) ==
                                        true
                                    ? playlistScreenController
                                        .allSongsListModel!
                                        .data![playlistScreenController
                                            .index.value]
                                        .is_queue = false
                                    : playlistScreenController
                                        .allSongsListModel!
                                        .data![playlistScreenController
                                            .index.value]
                                        .is_queue = true;
                              });
                              Get.back();
                              songBottomSheet(context, index, playlistSongsData,
                                  myPlaylistData);
                             playlistScreenController.queueAudioUrls;
                                
                              playlistScreenController.songsInPlaylist(
                                playlistId: (widget.myPlaylistData.id)!,
                              );
                                // final response = await playlistScreenController.queueSongsList(
                                //   playlistId: (widget.myPlaylistData.id)!);
                                //   response['']
                              // Get.back();
                            });
                            log((playlistScreenController
                                    .allSongsListModel!.data![index].is_queue)!
                                .toString());
                          },
                          child: commonListTilePlaylist(
                              icon: playlistScreenController
                                          .allSongsListModel!
                                          .data![playlistScreenController
                                              .index.value]
                                          .is_queue ==
                                      true
                                  ? Icons.check_box
                                  // containerIcon(
                                  //             height: 30,
                                  //             width: 30,
                                  //             icon: Icons.check,
                                  //             containerColor: Colors.green,
                                  //             iconColor: Colors.white,
                                  //           )
                                  : Icons.playlist_add_outlined,
                              iconSize: playlistScreenController
                                          .allSongsListModel!
                                          .data![playlistScreenController
                                              .index.value]
                                          .is_queue ==
                                      true
                                  ? 24.0
                                  : 30.0,
                              iconColor: playlistScreenController
                                          .allSongsListModel!
                                          .data![playlistScreenController
                                              .index.value]
                                          .is_queue ==
                                      true
                                  ? Colors.green
                                  : Colors.white,
                              text: AppStrings.addToQueue,
                              trailing: playlistScreenController
                                          .allSongsListModel!
                                          .data![playlistScreenController
                                              .index.value]
                                          .is_queue ==
                                      true
                                  ? Icon(
                                      Icons.add_to_queue_outlined,
                                      color: AppColors.white,
                                      size: 20,
                                    )
                                  : const SizedBox()),
                        ),
                      ),

                      Obx(
                        () => GestureDetector(
                          onTap: () async {
                            playlistScreenController.index.value = index;
                            log(playlistScreenController.index.value
                                .toString());
                            playlistScreenController
                                .allSongsListModel!
                                .data![playlistScreenController.index.value]
                                .is_loadning = true;
                            // });
                            log(playlistScreenController
                                .allSongsListModel!
                                .data![playlistScreenController.index.value]
                                .is_loadning
                                .toString());
                            final prefs = await SharedPreferences.getInstance();
                            final login = prefs.getBool('isLoggedIn') ?? '';
                            if (login == true) {
                              if (kDebugMode) {
                                print(playlistScreenController
                                    .downloadProgress.value);
                              }
                              Get.back();
                              // ignore: use_build_context_synchronously
                              songBottomSheet(context, index, playlistSongsData,
                                  myPlaylistData);
                              // setState(() {
                              detailScreenController.songExistsLocally.value ==
                                          true &&
                                      playlistScreenController
                                              .downloadProgress.value !=
                                          0.0
                                  ? null
                                  : downloadAudio(index);
                              // });
                            }
                            // else {
                            //   noLoginBottomSheet();
                            // }
                          },
                          child: ((playlistScreenController
                                      .allSongsListModel!
                                      .data![
                                          playlistScreenController.index.value]
                                      .is_loadning)! ==
                                  true)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 14, top: 5),
                                    child: Row(
                                      children: [
                                        Stack(
                                          // alignment: Alignment.centerLeft,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                value: playlistScreenController
                                                    .downloadProgress.value,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: containerIcon(
                                                icon: Icons.download,
                                                iconSize: 15,
                                              ),
                                            ),
                                            Positioned.fill(
                                              bottom: 1,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: lable(
                                                  text:
                                                      '${(playlistScreenController.downloadProgress.value * 100).toStringAsFixed(0)}%',
                                                  color:
                                                      AppColors.backgroundColor,
                                                  fontSize: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizeBoxWidth(22),
                                        lable(
                                          text: AppStrings.downloading,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : controller.playlisSongAudioUrl.contains(
                                          '${AppStrings.localPathMusic}/${playlistScreenController.allSongsListModel!.data![playlistScreenController.index.value].id}.mp3') ==
                                      true
                                  //     &&
                                  // playlistScreenController
                                  //         .downloading.value ==
                                  //     false && (playlistScreenController
                                  //     .allSongsListModel!.data![playlistScreenController.index.value].is_loadning) == false
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14, top: 5),
                                        child: Row(
                                          children: [
                                            containerIcon(
                                              height: 30,
                                              width: 30,
                                              icon: Icons.check,
                                              containerColor: Colors.green,
                                              iconColor: Colors.white,
                                            ),
                                            sizeBoxWidth(22),
                                            lable(
                                              text: AppStrings.downloaded,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : commonListTilePlaylist(
                                      icon: Icons.download,
                                      text: AppStrings.download,
                                    ),
                        ),
                      ),
                      sizeBoxHeight(17),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ac5b3),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: lable(
                            text: AppStrings.cancel,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Container(
                  transform: Matrix4.translationValues(
                    0.0,
                    -70,
                    0.0,
                  ),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF30343d),
                    ),
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: const Color(0xFF30343d),
                      child: Icon(
                        Icons.music_note,
                        color: AppColors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
              ),
            ),
          );
        });
  }

  Miniplayer miniplayer() {
    return Miniplayer(
      minHeight: 60,
      maxHeight: 60,
      builder: (height, percentage) {
        // _initAudioPlayer();
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
              //  Obx(
              //   () =>
              Container(
            color: const Color.fromARGB(255, 7, 18, 59),
            height: 60,
            width: Get.width,
            child: Row(
              children: [
                Obx(
                  () => ClipRRect(
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
                        ? controller.audioPlayer
                        : controller.audioPlayer,
                    size: 45),
              ],
            ),
          ),
          // ),
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
                ? controller.audioPlayer.positionStream
                : controller.audioPlayer.positionStream,
        bufferedPositionStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? controller.audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? controller.audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
       // Miniplayer miniplayer() {
  //   return Miniplayer(
  //     minHeight: 60,
  //     maxHeight: 60,
  //     builder: (height, percentage) {
  //       return GestureDetector(
  //         onTap: () async {
  //           Duration? duration;
  //           Duration? position;
  //           Duration? bufferedPosition;
  //           // Function(Duration)? onChangeEnd;

  //           final positionData = await _positionDataStream.first;

  //           duration = positionData.duration;
  //           position = positionData.position;
  //           bufferedPosition = positionData.bufferedPosition;

  //           if (kDebugMode) {
  //             log("$duration", name: 'duration');
  //             log("$position", name: 'position');
  //             log("$bufferedPosition", name: 'bufferedPosition');
  //             log("${(durationStream)}", name: 'durationStream');
  //             log("${(positionStream)}", name: 'positionStream');
  //             log("${(bufferedPositionStream)}",
  //                 name: 'bufferedPositionStream');
  //           }
  //           Get.to(
  //               DetailScreen(
  //                 index: currentListTileIndex,
  //                 type: 'playlist',
  //                 duration: duration,
  //                 position: position,
  //                 bufferedPosition: bufferedPosition,
  //                 durationStream: durationStream!,
  //                 positionStream: positionStream!,
  //                 bufferedPositionStream: bufferedPositionStream!,
  //                 audioPlayer: audioPlayer,
  //               ),
  //               transition: Transition.downToUp,
  //               duration: const Duration(milliseconds: 600));
  //         },
  //         child: Container(
  //           color: const Color.fromARGB(255, 7, 18, 59),
  //           child: Row(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(5),
  //                 child: Image.network(
  //                   // controller.audioPlayer != null
  //                   //     ? playlistScreenController.allSongsListModel!
  //                   //             .data![currentListTileIndexPrev!].image ??
  //                   //         'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
  //                   //     :
  //                   playlistScreenController.allSongsListModel!
  //                           .data![currentListTileIndex].image ??
  //                       'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
  //                   height: 60,
  //                   width: 60,
  //                   filterQuality: FilterQuality.high,
  //                 ),
  //               ),
  //               sizeBoxWidth(8),
  //               SizedBox(
  //                 width: Get.width * 0.6,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     lable(
  //                       text:
  //                           //  controller.audioPlayer != null
  //                           // ? (playlistScreenController.allSongsListModel!
  //                           //     .data![currentListTileIndexPrev!].title)!
  //                           //     :
  //                           (playlistScreenController.allSongsListModel!
  //                               .data![currentListTileIndex].title)!,
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                     lable(
  //                       text:
  //                           // controller.audioPlayer != null
  //                           // ?  (playlistScreenController.allSongsListModel!
  //                           //     .data![currentListTileIndexPrev!].description)!
  //                           //     :
  //                           (playlistScreenController.allSongsListModel!
  //                               .data![currentListTileIndex].description)!,
  //                       fontSize: 10,
  //                       color: Colors.grey,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               sizeBoxWidth(6),
  //               ControlButtons(audioPlayer, size: 45),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // // ignore: prefer_typing_uninitialized_variables
  // Stream<Duration>? positionStream;
  // // ignore: prefer_typing_uninitialized_variables
  // Stream<Duration>? bufferedPositionStream;
  // // ignore: prefer_typing_uninitialized_variables
  // Stream<Duration?>? durationStream;

  // Stream<PositionData> get _positionDataStream =>
  //     rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //       positionStream = audioPlayer.positionStream,
  //       bufferedPositionStream = audioPlayer.bufferedPositionStream,
  //       durationStream = audioPlayer.durationStream,
  //       (position, bufferedPosition, duration) => PositionData(
  //         position,
  //         bufferedPosition,
  //         duration ?? Duration.zero,
  //       ),
  //     );
}