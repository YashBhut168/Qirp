import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class QueueSongsScreen extends StatefulWidget {
  const QueueSongsScreen({super.key});

  @override
  State<QueueSongsScreen> createState() => _QueueSongsScreenState();
}

class _QueueSongsScreenState extends State<QueueSongsScreen> {
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
    queueSongsScreenController.queueSongsListWithoutPlaylist();
    fetchData();

    setState(() {
      controller.isMiniPlayerOpenQueueSongs.value == true ||
              controller.isMiniPlayerOpenDownloadSongs.value == true ||
              controller.isMiniPlayerOpen.value == true ||
              controller.isMiniPlayerOpenHome1.value == true ||
              controller.isMiniPlayerOpenHome2.value == true ||
              controller.isMiniPlayerOpenHome3.value == true ||
              controller.isMiniPlayerOpenAllSongs.value == true
          ? controller.audioPlayer.play()
          : null;
      controller.currentListTileIndexQueueSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndex.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
    });
    log("${controller.isMiniPlayerOpenQueueSongs.value}",
        name: "isMiniPlayerOpenQueueSongs");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
        name: "isMiniPlayerOpenDownloadSongs");
    log("${controller.isMiniPlayerOpen.value}", name: "isMiniPlayerOpen");
    log("${controller.isMiniPlayerOpenHome1.value}",
        name: "isMiniPlayerOpenHome1");
    log("${controller.isMiniPlayerOpenHome2.value}",
        name: "isMiniPlayerOpenHome2");
    log("${controller.isMiniPlayerOpenHome3.value}",
        name: "isMiniPlayerOpenHome3");

    log("${controller.queueSongsUrl}", name: "queueSongsUrl");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
        name: "isMiniPlayerOpenDownloadSongs");
    allSongsScreenController.allSongsList();
    downloadSongScreenController.downloadSongsList();
    GlobVar.playlistId == '' ? null : playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);
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
  Widget build(BuildContext context) {

    controller.queueSongsUrl = [];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: lable(
          text: AppStrings.queueSongs,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => queueSongsScreenController.isLoading.value == true
            // &&
            //         playlistScreenController.isLoading.value == true &&
            //         isLoading == true &&
            //         allSongsScreenController.isLoading.value == true &&
            //         downloadSongScreenController.isLoading.value == true
            // &&
            //         downloadSongScreenController.allSongsListModel == null
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : queueSongsScreenController.allSongsListModel == null ||
                    queueSongsScreenController
                        .allSongsListModel!.data!.isEmpty
                ? Center(
                    child: lable(text: 'Queue song list empty'),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          sizeBoxHeight(10),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: queueSongsScreenController
                                  .allSongsListModel!.data!.length,
                              itemBuilder: (context, index) {
                                var queueSongListData =
                                    queueSongsScreenController
                                        .allSongsListModel!.data![index];

                                final localFilePath =
                                    '${AppStrings.localPathMusic}/${queueSongsScreenController.allSongsListModel!.data![index].id}.mp3';
                                final file = File(localFilePath);
                                controller.addQueueSongsAudioUrlToList(
                                    file.existsSync()
                                        ? localFilePath
                                        : (queueSongsScreenController
                                            .allSongsListModel!
                                            .data![index]
                                            .audio)!);
                                controller.queueSongsUrl =
                                    controller.queueSongsUrl.toSet().toList();
                                log("${controller.queueSongsUrl}");

                                return ListTile(
                                  onTap: () async {
                                    setState(() {
                                      controller.isMiniPlayerOpenQueueSongs
                                          .value = true;
                                      log("${controller.isMiniPlayerOpenQueueSongs.value}",
                                          name: "isMiniPlayerOpenQueueSongs");
                                      log("${controller.isMiniPlayerOpenDownloadSongs.value}",
                                          name:
                                              "isMiniPlayerOpenDownloadSongs");
                                      log("${controller.isMiniPlayerOpen.value}",
                                          name: "isMiniPlayerOpen");
                                      log("${controller.isMiniPlayerOpenHome1.value}",
                                          name: "isMiniPlayerOpenHome1");
                                      log("${controller.isMiniPlayerOpenHome2.value}",
                                          name: "isMiniPlayerOpenHome2");
                                      log("${controller.isMiniPlayerOpenHome3.value}",
                                          name: "isMiniPlayerOpenHome3");
                                      log("${controller.isMiniPlayerOpenAllSongs.value}",
                                          name: "isMiniPlayerOpenAllSongs");
                                      controller.isMiniPlayerOpenDownloadSongs
                                          .value = false;
                                      controller.isMiniPlayerOpen.value = false;
                                      controller.isMiniPlayerOpenHome1.value =
                                          false;
                                      controller.isMiniPlayerOpenHome2.value =
                                          false;
                                      controller.isMiniPlayerOpenHome3.value =
                                          false;
                                      controller.isMiniPlayerOpenAllSongs
                                          .value = false;
                                      controller.currentListTileIndexQueueSongs
                                          .value = index;
                                      controller
                                          .updateCurrentListTileIndexQueueSongs(
                                              index);
                                      controller.initAudioPlayer();
                                      log(
                                          controller
                                              .currentListTileIndexQueueSongs
                                              .value
                                              .toString(),
                                          name:
                                              'currentListTileIndexQueueSongs download log');
                                    });
                                    homeScreenController.addRecentSongs(
                                        musicId: queueSongListData.id!);
                                    homeScreenController.recentSongsList();
                                  },
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -1),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.network(
                                      (queueSongListData.image) ??
                                          'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                      height: 70,
                                      width: 70,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                  title: Obx(
                                    () => lable(
                                      text: (queueSongListData.title)!,
                                      fontSize: 12,
                                      color: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                              controller.isMiniPlayerOpen.value ==
                                                  false &&
                                              controller.isMiniPlayerOpenHome1.value ==
                                                  false &&
                                              controller.isMiniPlayerOpenHome2.value ==
                                                  false &&
                                              controller.isMiniPlayerOpenHome3.value ==
                                                  false &&
                                              controller.isMiniPlayerOpenAllSongs.value ==
                                                  false &&
                                              controller.isMiniPlayerOpenQueueSongs.value ==
                                                  false)
                                          ? Colors.white
                                          : (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == queueSongsScreenController.allSongsListModel!.data![index].title && controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null) ||
                                                  (GlobVar.playlistId != '' && controller.isMiniPlayerOpen.value == true &&
                                                      playlistScreenController.allSongsListModel !=
                                                          null &&
                                                      playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title ==
                                                          queueSongsScreenController
                                                              .allSongsListModel!
                                                              .data![index]
                                                              .title) ||
                                                  (controller.isMiniPlayerOpenHome1.value == true &&
                                                      categoryData1 != null &&
                                                      categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                          queueSongsScreenController
                                                              .allSongsListModel!
                                                              .data![index]
                                                              .title) ||
                                                  (controller.isMiniPlayerOpenHome2.value == true &&
                                                      categoryData2 != null &&
                                                      categoryData2!.data![controller.currentListTileIndexCategory2.value].title == queueSongsScreenController.allSongsListModel!.data![index].title) ||
                                                  (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == queueSongsScreenController.allSongsListModel!.data![index].title) ||
                                                  (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == queueSongsScreenController.allSongsListModel!.data![index].title) ||
                                                  (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == queueSongsScreenController.allSongsListModel!.data![index].title)
                                              ? const Color(0xFF2ac5b3)
                                              // ignore: unrelated_type_equality_checks
                                              // : controller.isMiniPlayerOpenQueueSongs == false
                                              //     ? Colors.white
                                              : Colors.white,
                                    ),
                                  ),
                                  subtitle: lable(
                                    text: (queueSongListData.description)!,
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: Obx(
        () => (controller.isMiniPlayerOpenQueueSongs.value) == true &&
                queueSongsScreenController.allSongsListModel != null
            // &&
            // (controller.isMiniPlayerOpenHome1.value) == false
            ? BottomAppBar(
                elevation: 0,
                height: 60,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                color: AppColors.backgroundColor,
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
      ),
    );
  }

  Miniplayer miniplayer() {
    return Miniplayer(
      minHeight: 60,
      maxHeight: 60,
      builder: (height, percentage) {
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
                  categoryData1: categoryData1,
                  categoryData2: categoryData2,
                  categoryData3: categoryData3,
                ),
                transition: Transition.downToUp,
                duration: const Duration(milliseconds: 600));
          },
          child:
              //  Obx(
              //   () =>
              Container(
            color: AppColors.bottomNavColor,
            height: 60,
            width: Get.width,
            child: Row(
              children: [
                Obx(
                  () => ClipRRect(
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
                                  (controller.isMiniPlayerOpenQueueSongs.value) ==
                                      false &&
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
                              ? downloadSongScreenController
                                      .allSongsListModel!
                                      .data![controller
                                          .currentListTileIndexDownloadSongs
                                          .value]
                                      .image ??
                                  'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                              : playlistScreenController.allSongsListModel != null &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpen.value) ==
                                          true &&
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
                                          (controller.isMiniPlayerOpenQueueSongs.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) == true &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                      : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                          : categoryData3 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                              : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
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
                                  ? (downloadSongScreenController
                                      .allSongsListModel!
                                      .data![controller
                                          .currentListTileIndexDownloadSongs
                                          .value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpen.value) == true &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                      : (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
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
                                      ? (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
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
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? controller.audioPlayer.positionStream
                : controller.audioPlayer.positionStream,
        bufferedPositionStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? controller.audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream =
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
                    controller.isMiniPlayerOpen.value == true ||
                    controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true ||
                    controller.isMiniPlayerOpenQueueSongs.value == true
                ? controller.audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}
