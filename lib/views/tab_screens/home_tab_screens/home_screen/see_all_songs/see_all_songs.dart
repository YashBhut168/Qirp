//-----------------------------------------

// after home category dynamic

import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/controllers/album_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/artist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_model.dart';
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
import 'package:siri_wave/siri_wave.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

// ignore: must_be_immutable
class SeeAllSongScreen extends StatefulWidget {
  Data? homeCategoryData;
  SeeAllSongScreen({super.key, this.homeCategoryData});

  @override
  State<SeeAllSongScreen> createState() => _SeeAllSongScreenState();
}

class _SeeAllSongScreenState extends State<SeeAllSongScreen> {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AlbumScreenController albumScreenController = Get.put(AlbumScreenController());
  ArtistScreenController artistScreenController = Get.put(ArtistScreenController());

  @override
  void initState() {
    super.initState();
    // fetchData();
    downloadSongScreenController.downloadSongsList();
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   playlistScreenController.isPlaylistSongsEmpty.value == true ? controller.isMiniPlayerOpen.value = false : controller.isMiniPlayerOpen.value = true;
    // });
    favoriteSongScreenController.favoriteSongsList();
    queueSongsScreenController.queueSongsListWithoutPlaylist();

    setState(() {
      (controller.isMiniPlayerOpenQueueSongs.value == true ||
                  controller.isMiniPlayerOpenDownloadSongs.value == true ||
                  controller.isMiniPlayerOpen.value == true ||
                  controller.isMiniPlayerOpenHome1.value == true ||
                  controller.isMiniPlayerOpenHome2.value == true ||
                  controller.isMiniPlayerOpenHome3.value == true ||
                  controller.isMiniPlayerOpenAllSongs.value == true ||
                  controller.isMiniPlayerOpenAlbumSongs.value == true ||
                  controller.isMiniPlayerOpenArtistSongs.value == true ||
                  controller.isMiniPlayerOpenFavoriteSongs.value == true) &&
              controller.musicPlay.value == true
          ? controller.audioPlayer.play()
          : null;
      controller.currentListTileIndexQueueSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndex.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
      controller.currentListTileIndexFavoriteSongs.value;
      controller.currentListTileIndexAlbumSongs.value;
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
    log("${controller.isMiniPlayerOpenFavoriteSongs.value}",
        name: "isMiniPlayerOpenFavoriteSongs");

    log("${controller.queueSongsUrl}", name: "queueSongsUrl");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
        name: "isMiniPlayerOpenDownloadSongs");
    // playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);
  }

  

  @override
  Widget build(BuildContext context) {
    setState(() {
      controller.categoryAudioUrl = [];
    });
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: AppColors.white,
          ),
        ),
        title: lable(
            text: widget.homeCategoryData!.category ?? '',
            fontSize: 18,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
                  itemCount: widget.homeCategoryData!.categoryData!.length,
                  // > 3 ?  widget.categoryData!.data!.length = 3 : widget.categoryData!.data!.length ,
                  itemBuilder: (context, index) {
                    
                    var categoryListData =
                        widget.homeCategoryData!.categoryData![index];
                    final localFilePath =
                        '${AppStrings.localPathMusic}/${widget.homeCategoryData!.categoryData![index].id}.mp3';
                    final file = File(localFilePath);
                    controller.addCategoryAudioUrlToList(file.existsSync()
                        ? localFilePath
                        : (widget
                            .homeCategoryData!.categoryData![index].audio)!);
                    controller.categoryAudioUrl =
                        controller.categoryAudioUrl.toSet().toList();
                    log(controller.categoryAudioUrl.toString(), name: 'see all url');
                    return GestureDetector(
                      onTap: () async {
                        setState(() {

                          controller.isMiniPlayerOpenHome.value = true;
                          controller.isMiniPlayerOpenFavoriteSongs.value =
                              false;
                          controller.isMiniPlayerOpenDownloadSongs.value =
                              false;
                          controller.isMiniPlayerOpenArtistSongs
                                            .value = false;
                          controller.isMiniPlayerOpenQueueSongs.value = false;
                          controller.isMiniPlayerOpen.value = false;
                          controller.isMiniPlayerOpenAlbumSongs.value = false;
                          controller.isMiniPlayerOpenHome1.value = false;
                          controller.isMiniPlayerOpenHome2.value = false;
                          controller.isMiniPlayerOpenHome3.value = false;
                          controller.isMiniPlayerOpenAllSongs.value = false;


                          controller.currentListTileIndexCategory.value = GlobVar.currentCategoryIndex; 
                          controller.currentListTileIndexCategoryData.value = index;
                    log("${controller.currentListTileIndexCategoryData.value}", name: 'see all current index');
                    log("${controller.currentListTileIndexCategory.value}", name: 'see all current category index');

                          // controller.updateCurrentListTileIndexCategory(index);
                          controller.initAudioPlayer();
                        });
                        homeScreenController.addRecentSongs(
                            musicId: categoryListData.id!);
                        homeScreenController.recentSongsList();
                      },
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -1),
                        leading: Stack(
                          children: [
                            Obx(
                              () => ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                        controller.isMiniPlayerOpen.value ==
                                            false &&
                                            controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                        controller.isMiniPlayerOpenFavoriteSongs.value ==
                                            false &&
                                        controller.isMiniPlayerOpenHome.value ==
                                            false &&
                                        controller.isMiniPlayerOpenAlbumSongs.value ==
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
                                    ? Image.network(
                                        (categoryListData.image) ??
                                            'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                        height: 70,
                                        width: 70,
                                        filterQuality: FilterQuality.high,
                                      )
                                    : (controller.isMiniPlayerOpenHome.value == true &&
                                                homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title ==
                                                    categoryListData.title) ||
                                            (controller.isMiniPlayerOpen.value == true &&
                                                GlobVar.playlistId != '' &&
                                                playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title ==
                                                    categoryListData.title &&
                                                playlistScreenController.allSongsListModel !=
                                                    null)
                                                    ||
                                            (controller.isMiniPlayerOpenArtistSongs.value == true &&
                                                artistScreenController.currentPlayingTitle.value ==
                                                    categoryListData.title &&
                                                artistScreenController.allSongsListModel !=
                                                    null)
                                                     ||
                                            (controller.isMiniPlayerOpenQueueSongs.value == true &&
                                                queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title ==
                                                    categoryListData.title &&
                                                queueSongsScreenController.allSongsListModel !=
                                                    null) ||
                                            (controller.isMiniPlayerOpenAllSongs.value == true &&
                                                allSongsScreenController.allSongsListModel != null &&
                                                allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == categoryListData.title) ||
                                            (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == categoryListData.title) ||
                                            (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].title == categoryListData.title) ||
                                            (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == categoryListData.title)
                                        ? Opacity(
                                            opacity: 0.4,
                                            child: Image.network(
                                              (categoryListData.image) ??
                                                  'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                              height: 70,
                                              width: 70,
                                              filterQuality: FilterQuality.high,
                                            ),
                                          )
                                        : Image.network(
                                            (categoryListData.image) ??
                                                'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                            height: 70,
                                            width: 70,
                                            filterQuality: FilterQuality.high,
                                          ),
                              ),
                            ),
                            Obx(
                              () => Positioned.fill(
                                child: Center(
                                  child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                          controller.isMiniPlayerOpen.value ==
                                              false &&
                                          controller.isMiniPlayerOpenFavoriteSongs.value ==
                                              false &&
                                          controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                          controller.isMiniPlayerOpenAlbumSongs.value ==
                                            false &&
                                          controller.isMiniPlayerOpenHome.value ==
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
                                      ? const SizedBox()
                                      : (((controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == categoryListData.title) ||
                                                  (controller.isMiniPlayerOpen.value == true &&
                                                      GlobVar.playlistId !=
                                                          '' &&
                                                      playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title ==
                                                          categoryListData
                                                              .title &&
                                                      playlistScreenController.allSongsListModel !=
                                                          null) 
                                                          ||
                                            (controller.isMiniPlayerOpenArtistSongs.value == true &&
                                                artistScreenController.currentPlayingTitle.value ==
                                                    categoryListData.title &&
                                                artistScreenController.allSongsListModel !=
                                                    null)
                                                          ||
                                                  (controller.isMiniPlayerOpenQueueSongs.value == true &&
                                                      queueSongsScreenController
                                                              .allSongsListModel!
                                                              .data![controller.currentListTileIndexQueueSongs.value]
                                                              .title ==
                                                          categoryListData.title &&
                                                      queueSongsScreenController.allSongsListModel != null) ||
                                                  (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == categoryListData.title) ||
                                                  (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == categoryListData.title) ||
                                                  (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == categoryListData.title) ||
                                                  (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].title == categoryListData.title) ||
                                                  (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == categoryListData.title)) &&
                                              controller.musicPlay.value == true)
                                          ? ColorFiltered(
                                              // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.grey,
                                                      BlendMode.modulate),
                                              child: Transform.scale(
                                                scale: 2.2,
                                                child: SiriWaveform.ios9(
                                                  controller: controller
                                                      .siriWaveController,
                                                  options:
                                                      const IOS9SiriWaveformOptions(
                                                    height: 130,
                                                    width: 25,
                                                    showSupportBar: false,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Obx(() => lable(
                            text: (categoryListData.title)!,
                            fontSize: 12,
                            color: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                    controller.isMiniPlayerOpen.value ==
                                        false &&
                                    controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                    controller.isMiniPlayerOpenAlbumSongs.value ==
                                                    false &&
                                    controller.isMiniPlayerOpenFavoriteSongs.value ==
                                        false &&
                                    controller.isMiniPlayerOpenHome.value ==
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
                                : (controller.isMiniPlayerOpenHome.value == true &&
                                            homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title ==
                                                categoryListData.title) ||
                                        (GlobVar.playlistId != '' &&
                                            playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title ==
                                                categoryListData.title &&
                                            playlistScreenController.allSongsListModel !=
                                                null &&
                                            controller.isMiniPlayerOpen.value ==
                                                true) 
                                                ||
                                            (controller.isMiniPlayerOpenArtistSongs.value == true &&
                                                artistScreenController.currentPlayingTitle.value ==
                                                    categoryListData.title &&
                                                artistScreenController.allSongsListModel !=
                                                    null)
                                                ||
                                        (controller.isMiniPlayerOpenQueueSongs.value == true &&
                                            queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title ==
                                                categoryListData.title &&
                                            queueSongsScreenController.allSongsListModel !=
                                                null) ||
                                        (controller.isMiniPlayerOpenAllSongs.value == true &&
                                            allSongsScreenController.allSongsListModel != null &&
                                            allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == categoryListData.title) ||
                                        (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == categoryListData.title) ||
                                        (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].title == categoryListData.title) ||
                                        (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == categoryListData.title)

                                    // (categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                    //         widget.categoryData!.data![index]
                                    //             .title &&
                                    //     controller
                                    //             .isMiniPlayerOpenHome1.value ==
                                    //         true) ||
                                    // (categoryData2 != null && categoryData1!.data![controller.currentListTileIndexCategory2.value].title ==
                                    //         widget.categoryData!.data![index]
                                    //             .title &&
                                    //     controller
                                    //             .isMiniPlayerOpenHome2.value ==
                                    //         true) ||
                                    // (categoryData3 != null && categoryData1!.data![controller.currentListTileIndexCategory3.value].title ==
                                    //         widget.categoryData!.data![index].title &&
                                    //     controller.isMiniPlayerOpenHome3.value == true)
                                    ? const Color(0xFF2ac5b3)
                                    : Colors.white)),
                        subtitle: lable(
                          text: (categoryListData.description)!,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                artistScreenController.allSongsListModel != null
            ? BottomAppBar(
                elevation: 0,
                height: 60,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                color: AppColors.bottomNavColor,
                child: miniplayer())
            : (controller.isMiniPlayerOpenAlbumSongs.value) == true &&
                    albumScreenController.allSongsListModel != null
                ? BottomAppBar(
                    elevation: 0,
                    height: 60,
                    padding: EdgeInsets.zero,
                    clipBehavior: Clip.none,
                    color: AppColors.bottomNavColor,
                    child: miniplayer())
                : (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
                        favoriteSongScreenController.allSongsListModel != null
                    ? BottomAppBar(
                        elevation: 0,
                        height: 60,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.none,
                        color: AppColors.bottomNavColor,
                        child: miniplayer())
                    : (controller.isMiniPlayerOpenQueueSongs.value) == true &&
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
                        : (controller.isMiniPlayerOpenDownloadSongs.value) ==
                                    true &&
                                downloadSongScreenController.allSongsListModel !=
                                    null
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
                                    color: AppColors.backgroundColor,
                                    child: miniplayer())
                                : (controller.isMiniPlayerOpenHome.value) ==
                                            true &&
                                        homeScreenController
                                            .homeCategoryData.isNotEmpty
                                    ? BottomAppBar(
                                        elevation: 0,
                                        height: 60,
                                        padding: EdgeInsets.zero,
                                        clipBehavior: Clip.none,
                                        color: AppColors.backgroundColor,
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
                                              : controller.isMiniPlayerOpenAllSongs
                                                          .value ==
                                                      true
                                                  ? controller
                                                      .currentListTileIndexAllSongs
                                                      .value
                                                  : controller
                                                      .currentListTileIndex
                                                      .value,
                  type: controller.isMiniPlayerOpenHome.value == true
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
                  // categoryData1: categoryData1,
                  // categoryData2: categoryData2,
                  // categoryData3: categoryData3,
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
                        artistScreenController.allSongsListModel != null &&
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
                                    false
                            ? artistScreenController.currentPlayingImage.value
                            // artistScreenController
                            //         .allSongsListModel!
                            //         .data![controller
                            //             .currentListTileIndexArtistSongs.value]
                            //         .image ??
                            //     'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
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
                                ? albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : homeScreenController.homeCategoryData.isNotEmpty &&
                                        (controller.isMiniPlayerOpenHome.value) ==
                                            true &&
                                        (controller.isMiniPlayerOpenArtistSongs.value) ==
                                            false &&
                                        (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                            false &&
                                        (controller
                                                .isMiniPlayerOpenFavoriteSongs
                                                .value) ==
                                            false &&
                                        (controller
                                                .isMiniPlayerOpenDownloadSongs
                                                .value) ==
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
                                    ? homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].image ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                    : favoriteSongScreenController.allSongsListModel != null &&
                                            (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
                                            (controller.isMiniPlayerOpenArtistSongs.value) == false &&
                                            (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                            (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                            (controller.isMiniPlayerOpen.value) == false &&
                                            (controller.isMiniPlayerOpenHome.value) == false &&
                                            (controller.isMiniPlayerOpenHome1.value) == false &&
                                            (controller.isMiniPlayerOpenHome2.value) == false &&
                                            (controller.isMiniPlayerOpenHome3.value) == false &&
                                            (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                            (controller.isMiniPlayerOpenQueueSongs.value) == false
                                        ? favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : queueSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true
                                            ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : downloadSongScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                : playlistScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    ? playlistScreenController.currentPlayingImage.isNotEmpty
                                                        ? playlistScreenController.currentPlayingImage.value
                                                        : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    // : (controller.isMiniPlayerOpenHome1.value) == true && categoryData1 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    //     ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    //     : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    //         ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    //         : categoryData3 != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    //             ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                              : (controller.isMiniPlayerOpenAlbumSongs.value) == true &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                                      .data![controller
                                          .currentListTileIndexAlbumSongs.value]
                                      .title)!
                                  : homeScreenController.homeCategoryData.isNotEmpty &&
                                          (controller.isMiniPlayerOpenHome.value) ==
                                              true &&
                                          (controller
                                                  .isMiniPlayerOpenArtistSongs
                                                  .value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                          (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) == false
                                      ? (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].title)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                          ? (favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                              ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? playlistScreenController.currentPlayingTitle.isNotEmpty
                                                          ? playlistScreenController.currentPlayingTitle.value
                                                          : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                                      // : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      // ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                                      // : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      //     ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                                      //     : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      // ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                          ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                          : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                                  (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                      false &&
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
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false
                              ? artistScreenController.currentPlayingDesc.value
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                      (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (albumScreenController
                                      .allSongsListModel!
                                      .data![controller
                                          .currentListTileIndexAlbumSongs.value]
                                      .description)!
                                  : homeScreenController.homeCategoryData.isNotEmpty &&
                                          (controller.isMiniPlayerOpenHome.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpenArtistSongs.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                              false &&
                                          (controller
                                                  .isMiniPlayerOpenFavoriteSongs
                                                  .value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) == false
                                      ? (homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].description)!
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
                                                      // : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      //     ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                                      //     : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      //         ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                                      //         : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      //             ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
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
                            // (controller.isMiniPlayerOpenHome1.value) == true ||
                            // (controller.isMiniPlayerOpenHome2.value) == true ||
                            // (controller.isMiniPlayerOpenHome3.value) == true ||
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
                ? controller.audioPlayer.positionStream
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
                ? controller.audioPlayer.bufferedPositionStream
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
                ? controller.audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}









//------------------------------------------

// Before home category dynamic

// import 'dart:developer';
// import 'dart:io';

// import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
// import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
// import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
// import 'package:edpal_music_app_ui/utils/common_method.dart';
// import 'package:edpal_music_app_ui/utils/globVar.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:miniplayer/miniplayer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rxdart/rxdart.dart' as rxdart;
// import 'package:siri_wave/siri_wave.dart';

// // ignore: must_be_immutable
// class SeeAllSongScreen extends StatefulWidget {
//   CategoryData? categoryData;
//   SeeAllSongScreen({super.key, this.categoryData});

//   @override
//   State<SeeAllSongScreen> createState() => _SeeAllSongScreenState();
// }

// class _SeeAllSongScreenState extends State<SeeAllSongScreen> {
//   final HomeScreenController homeScreenController =
//       Get.put(HomeScreenController());
//   final MainScreenController controller =
//       Get.put(MainScreenController(initialIndex: 0));
//   AllSongsScreenController allSongsScreenController =
//       Get.put(AllSongsScreenController());
//   QueueSongsScreenController queueSongsScreenController =
//       Get.put(QueueSongsScreenController());
//   DownloadSongScreenController downloadSongScreenController =
//       Get.put(DownloadSongScreenController());
//   FavoriteSongScreenController favoriteSongScreenController = Get.put(FavoriteSongScreenController());
//   PlaylistScreenController playlistScreenController =
//       Get.put(PlaylistScreenController());

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     downloadSongScreenController.downloadSongsList();
//     //  WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   playlistScreenController.isPlaylistSongsEmpty.value == true ? controller.isMiniPlayerOpen.value = false : controller.isMiniPlayerOpen.value = true;
//     // });
//     favoriteSongScreenController.favoriteSongsList();
//     queueSongsScreenController.queueSongsListWithoutPlaylist();

//     setState(() {
//       (controller.isMiniPlayerOpenQueueSongs.value == true ||
//               controller.isMiniPlayerOpenDownloadSongs.value == true ||
//               controller.isMiniPlayerOpen.value == true ||
//               controller.isMiniPlayerOpenHome1.value == true ||
//               controller.isMiniPlayerOpenHome2.value == true ||
//               controller.isMiniPlayerOpenHome3.value == true ||
//               controller.isMiniPlayerOpenAllSongs.value == true ||
//               controller.isMiniPlayerOpenFavoriteSongs.value == true) && controller.musicPlay.value == true
//           ? controller.audioPlayer.play()
//           : null;
//       controller.currentListTileIndexQueueSongs.value;
//       controller.currentListTileIndexDownloadSongs.value;
//       controller.currentListTileIndex.value;
//       controller.currentListTileIndexAllSongs.value;
//       controller.currentListTileIndexCategory1.value;
//       controller.currentListTileIndexCategory2.value;
//       controller.currentListTileIndexCategory3.value;
//       controller.currentListTileIndexFavoriteSongs.value;
//     });
//     log("${controller.isMiniPlayerOpenQueueSongs.value}",
//         name: "isMiniPlayerOpenQueueSongs");
//     log("${controller.isMiniPlayerOpenDownloadSongs.value}",
//         name: "isMiniPlayerOpenDownloadSongs");
//     log("${controller.isMiniPlayerOpen.value}", name: "isMiniPlayerOpen");
//     log("${controller.isMiniPlayerOpenHome1.value}",
//         name: "isMiniPlayerOpenHome1");
//     log("${controller.isMiniPlayerOpenHome2.value}",
//         name: "isMiniPlayerOpenHome2");
//     log("${controller.isMiniPlayerOpenHome3.value}",
//         name: "isMiniPlayerOpenHome3");
//     log("${controller.isMiniPlayerOpenFavoriteSongs.value}",
//         name: "isMiniPlayerOpenFavoriteSongs");

//     log("${controller.queueSongsUrl}", name: "queueSongsUrl");
//     log("${controller.isMiniPlayerOpenDownloadSongs.value}",
//         name: "isMiniPlayerOpenDownloadSongs");
//       // playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);

//   }

//   final apiHelper = ApiHelper();

//   bool isLoading = false;
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
//         isLoading = false;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       isLoading = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       controller.allSongsUrl = [];
//     });

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_outlined,
//             size: 20,
//             color: AppColors.white,
//           ),
//         ),
//         title: lable(
//             text: widget.categoryData!.message ?? '',
//             fontSize: 18,
//             letterSpacing: 0.5,
//             fontWeight: FontWeight.w600),
//         centerTitle: true,
//         // automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: Column(
//             children: [
//               sizeBoxHeight(10),
//               (categoryData1 == null ||
//                       categoryData2 == null ||
//                       categoryData3 == null)
//                   ? Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.white,
//                       ),
//                     )
//                   : ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: widget.categoryData!.data!.length,
//                       // > 3 ?  widget.categoryData!.data!.length = 3 : widget.categoryData!.data!.length ,
//                       itemBuilder: (context, index) {
//                         var categoryListData =
//                             widget.categoryData!.data![index];
//                         final localFilePath =
//                             '${AppStrings.localPathMusic}/${widget.categoryData!.data![index].id}.mp3';
//                         final file = File(localFilePath);
//                         controller.addAllSongsAudioUrlToList(file.existsSync()
//                             ? localFilePath
//                             : (widget.categoryData!.data![index].audio)!);
//                         controller.allSongsUrl =
//                             controller.allSongsUrl.toSet().toList();
//                         log(controller.allSongsUrl.toString());

//                         (widget.categoryData!.message)! == "Category1"
//                             ? controller.category1AudioUrl =
//                                 controller.category1AudioUrl.toSet().toList()
//                             : (widget.categoryData!.message)! == "Category2"
//                                 ? controller.category2AudioUrl = controller
//                                     .category2AudioUrl
//                                     .toSet()
//                                     .toList()
//                                 : (widget.categoryData!.message)! == "Category3"
//                                     ? controller.category3AudioUrl = controller
//                                         .category3AudioUrl
//                                         .toSet()
//                                         .toList()
//                                     : Null;
//                         return GestureDetector(
//                           onTap: () async {
//                             homeScreenController
//                                 .updateCategoryData(widget.categoryData!);

//                             // controller.isMiniPlayerOpen.value == true
//                             //     ? (controller.audioPlayer)!.dispose()
//                             //     : null;
//                             setState(() {
//                               controller.isMiniPlayerOpen.value == false;
//                               controller.isMiniPlayerOpenFavoriteSongs.value == false;
//                               controller.isMiniPlayerOpenHome1.value =
//                                   (widget.categoryData!.message)! == "Category1"
//                                       ? true
//                                       : false;
//                               controller.isMiniPlayerOpenHome2.value =
//                                   (widget.categoryData!.message)! == "Category2"
//                                       ? true
//                                       : false;
//                               controller.isMiniPlayerOpenHome3.value =
//                                   (widget.categoryData!.message)! == "Category3"
//                                       ? true
//                                       : false;
//                               controller.isMiniPlayerOpenAllSongs.value = false;

//                               (widget.categoryData!.message)! == "Category1"
//                                   ? controller.currentListTileIndexCategory1
//                                       .value = index
//                                   : (widget.categoryData!.message)! ==
//                                           "Category2"
//                                       ? controller.currentListTileIndexCategory2
//                                           .value = index
//                                       : (widget.categoryData!.message)! ==
//                                               "Category3"
//                                           ? controller
//                                               .currentListTileIndexCategory3
//                                               .value = index
//                                           : null;

//                               (widget.categoryData!.message)! == "Category1"
//                                   ? controller
//                                       .updateCurrentListTileIndexCategory1(
//                                           index)
//                                   : (widget.categoryData!.message)! ==
//                                           "Category2"
//                                       ? controller
//                                           .updateCurrentListTileIndexCategory2(
//                                               index)
//                                       : (widget.categoryData!.message)! ==
//                                               "Category3"
//                                           ? controller
//                                               .updateCurrentListTileIndexCategory3(
//                                                   index)
//                                           : null;
//                               controller.initAudioPlayer();
//                               // controller.audioPlayer!.load();
//                             });
//                             final prefs = await SharedPreferences.getInstance();
//                             prefs.reload();
//                             await prefs.setBool('isMiniPlayerOpen', false);

//                             (widget.categoryData!.message)! == "Category1"
//                                 ? await prefs.setBool(
//                                     'isMiniPlayerOpenHome1', true)
//                                 : (widget.categoryData!.message)! == "Category2"
//                                     ? await prefs.setBool(
//                                         'isMiniPlayerOpenHome2', true)
//                                     : (widget.categoryData!.message)! ==
//                                             "Category3"
//                                         ? await prefs.setBool(
//                                             'isMiniPlayerOpenHome3', true)
//                                         : null;

//                             (widget.categoryData!.message)! == "Category1"
//                                 ? await prefs.setInt('category1Index', index)
//                                 : (widget.categoryData!.message)! == "Category2"
//                                     ? await prefs.setInt(
//                                         'category2Index', index)
//                                     : (widget.categoryData!.message)! ==
//                                             "Category3"
//                                         ? await prefs.setInt(
//                                             'category3Index', index)
//                                         : null;

//                             homeScreenController.addRecentSongs(
//                                 musicId: categoryListData.id!);
//                             homeScreenController.recentSongsList();
//                           },
//                           child: ListTile(
//                             visualDensity: const VisualDensity(
//                                 horizontal: -4, vertical: -1),
//                             leading: Stack(
//                               children: [
//                                 Obx(
//                                   () => ClipRRect(
//                                     borderRadius: BorderRadius.circular(11),
//                                     child:
//                                     (controller.isMiniPlayerOpenDownloadSongs.value == false &&
//                                               controller.isMiniPlayerOpen.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenFavoriteSongs.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome1.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome2.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome3.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenAllSongs.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenQueueSongs.value ==
//                                                   false)
//                                           ? Image.network(
//                                       (categoryListData.image) ??
//                                           'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
//                                       height: 70,
//                                       width: 70,
//                                       filterQuality: FilterQuality.high,
//                                     )
//                                           : (categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == widget.categoryData!.data![index].title && controller.isMiniPlayerOpenHome1.value == true) ||
//                                                   (controller.isMiniPlayerOpenHome2.value == true &&
//                                                       categoryData2 != null &&
//                                                       categoryData2!.data![controller.currentListTileIndexCategory2.value].title ==
//                                                           widget
//                                                               .categoryData!
//                                                               .data![index]
//                                                               .title) ||
//                                                   (controller.isMiniPlayerOpenHome3.value == true &&
//                                                       categoryData3 != null &&
//                                                       categoryData3!.data![controller.currentListTileIndexCategory3.value].title ==
//                                                           widget
//                                                               .categoryData!
//                                                               .data![index]
//                                                               .title) ||
//                                                   (GlobVar.playlistId != '' &&
//                                                       playlistScreenController
//                                                               .allSongsListModel!
//                                                               .data![controller.currentListTileIndex.value]
//                                                               .title ==
//                                                           widget.categoryData!.data![index].title &&
//                                                       playlistScreenController.allSongsListModel != null &&
//                                                       controller.isMiniPlayerOpen.value == true) ||
//                                                   (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == widget.categoryData!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
//                                                   (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == widget.categoryData!.data![index].title) ||
//                                                   (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == widget.categoryData!.data![index].title) ||
//                                                   (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == widget.categoryData!.data![index].title)
//                                               ? Opacity(
//                                                 opacity: 0.4,
//                                                 child: Image.network(
//                                                                                     (categoryListData.image) ??
//                                                                                         'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
//                                                                                     height: 70,
//                                                                                     width: 70,
//                                                                                     filterQuality: FilterQuality.high,
//                                                                                   ),
//                                               ) :
//                                      Image.network(
//                                       (categoryListData.image) ??
//                                           'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
//                                       height: 70,
//                                       width: 70,
//                                       filterQuality: FilterQuality.high,
//                                     ),
//                                   ),
//                                 ),
//                                 Obx(
//                                   () => Positioned.fill(
//                                     child: Center(
//                                       child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
//                                               controller.isMiniPlayerOpen.value ==
//                                                   false &&
//                                                   controller.isMiniPlayerOpenFavoriteSongs.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome1.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome2.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenHome3.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenAllSongs.value ==
//                                                   false &&
//                                               controller.isMiniPlayerOpenQueueSongs.value ==
//                                                   false)
//                                           ? const SizedBox()
//                                           : (((categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == widget.categoryData!.data![index].title && controller.isMiniPlayerOpenHome1.value == true) ||
//                                                   (controller.isMiniPlayerOpenHome2.value == true &&
//                                                       categoryData2 != null &&
//                                                       categoryData2!.data![controller.currentListTileIndexCategory2.value].title ==
//                                                           widget
//                                                               .categoryData!
//                                                               .data![index]
//                                                               .title) ||
//                                                   (controller.isMiniPlayerOpenHome3.value == true &&
//                                                       categoryData3 != null &&
//                                                       categoryData3!.data![controller.currentListTileIndexCategory3.value].title ==
//                                                           widget
//                                                               .categoryData!
//                                                               .data![index]
//                                                               .title) ||
//                                                   (GlobVar.playlistId != '' &&
//                                                       playlistScreenController
//                                                               .allSongsListModel!
//                                                               .data![controller.currentListTileIndex.value]
//                                                               .title ==
//                                                           widget.categoryData!.data![index].title &&
//                                                       playlistScreenController.allSongsListModel != null &&
//                                                       controller.isMiniPlayerOpen.value == true) ||
//                                                   (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == widget.categoryData!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
//                                                   (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == widget.categoryData!.data![index].title) ||
//                                                   (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == widget.categoryData!.data![index].title) ||
//                                                   (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == widget.categoryData!.data![index].title)) &&   
//                                                                       controller.musicPlay.value == true)
//                                               ? ColorFiltered(
//                                                   // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
//                                                   colorFilter:
//                                                       const ColorFilter.mode(
//                                                           Colors.grey,
//                                                           BlendMode.modulate),
//                                                   child: Transform.scale(
//                                                     scale: 2.2,
//                                                     child: SiriWaveform.ios9(
//                                                       controller: controller
//                                                           .siriWaveController,
//                                                       options:
//                                                           const IOS9SiriWaveformOptions(
//                                                         height: 130,
//                                                         width: 25,
//                                                         showSupportBar: false,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : const SizedBox(),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             title: Obx(() => lable(
//                                 text: (categoryListData.title)!,
//                                 fontSize: 12,
//                                 color: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
//                                         controller.isMiniPlayerOpen.value ==
//                                             false &&
//                                         controller.isMiniPlayerOpenFavoriteSongs.value ==
//                                                   false &&
//                                         controller.isMiniPlayerOpenHome1.value ==
//                                             false &&
//                                         controller.isMiniPlayerOpenHome2.value ==
//                                             false &&
//                                         controller.isMiniPlayerOpenHome3.value ==
//                                             false &&
//                                         controller.isMiniPlayerOpenAllSongs.value ==
//                                             false &&
//                                         controller.isMiniPlayerOpenQueueSongs.value ==
//                                             false)
//                                     ? Colors.white
//                                     : (categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == widget.categoryData!.data![index].title && controller.isMiniPlayerOpenHome1.value == true) ||
//                                             (controller.isMiniPlayerOpenHome2.value == true &&
//                                                 categoryData2 != null &&
//                                                 categoryData2!.data![controller.currentListTileIndexCategory2.value].title ==
//                                                     widget.categoryData!
//                                                         .data![index].title) ||
//                                             (controller.isMiniPlayerOpenHome3.value == true &&
//                                                 categoryData3 != null &&
//                                                 categoryData3!.data![controller.currentListTileIndexCategory3.value].title ==
//                                                     widget.categoryData!
//                                                         .data![index].title) ||
//                                             (GlobVar.playlistId != '' &&
//                                                 playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title ==
//                                                     widget.categoryData!.data![index].title &&
//                                                 playlistScreenController.allSongsListModel != null &&
//                                                 controller.isMiniPlayerOpen.value == true) ||
//                                             (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == widget.categoryData!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
//                                             (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == widget.categoryData!.data![index].title) ||
//                                                   (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == widget.categoryData!.data![index].title) ||
//                                             (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == widget.categoryData!.data![index].title)

//                                         // (categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
//                                         //         widget.categoryData!.data![index]
//                                         //             .title &&
//                                         //     controller
//                                         //             .isMiniPlayerOpenHome1.value ==
//                                         //         true) ||
//                                         // (categoryData2 != null && categoryData1!.data![controller.currentListTileIndexCategory2.value].title ==
//                                         //         widget.categoryData!.data![index]
//                                         //             .title &&
//                                         //     controller
//                                         //             .isMiniPlayerOpenHome2.value ==
//                                         //         true) ||
//                                         // (categoryData3 != null && categoryData1!.data![controller.currentListTileIndexCategory3.value].title ==
//                                         //         widget.categoryData!.data![index].title &&
//                                         //     controller.isMiniPlayerOpenHome3.value == true)
//                                         ? const Color(0xFF2ac5b3)
//                                         : Colors.white)),
//                             subtitle: lable(
//                               text: (categoryListData.description)!,
//                               fontSize: 11,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         );
//                       }),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Obx(
//         () => 
//         (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
//                 favoriteSongScreenController.allSongsListModel != null
//             // &&
//             // (controller.isMiniPlayerOpenHome1.value) == false
//             ? BottomAppBar(
//                 elevation: 0,
//                 height: 60,
//                 padding: EdgeInsets.zero,
//                 clipBehavior: Clip.none,
//                 color: AppColors.backgroundColor,
//                 child: miniplayer())
//             : 
//         (controller.isMiniPlayerOpenQueueSongs.value) == true &&
//                 queueSongsScreenController.allSongsListModel != null
//             // &&
//             // (controller.isMiniPlayerOpenHome1.value) == false
//             ? BottomAppBar(
//                 elevation: 0,
//                 height: 60,
//                 padding: EdgeInsets.zero,
//                 clipBehavior: Clip.none,
//                 color: AppColors.backgroundColor,
//                 child: miniplayer())
//             : (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
//                     downloadSongScreenController.allSongsListModel != null
//                 // &&
//                 // (controller.isMiniPlayerOpenHome1.value) == false
//                 ? BottomAppBar(
//                     elevation: 0,
//                     height: 60,
//                     padding: EdgeInsets.zero,
//                     clipBehavior: Clip.none,
//                     color: AppColors.backgroundColor,
//                     child: miniplayer())
//                 : (controller.isMiniPlayerOpen.value) == true &&
//                         playlistScreenController.allSongsListModel != null && playlistScreenController.isLikePlaylistData.isNotEmpty
//                     // &&
//                     // (controller.isMiniPlayerOpenHome1.value) == false
//                     ? BottomAppBar(
//                         elevation: 0,
//                         height: 60,
//                         padding: EdgeInsets.zero,
//                         clipBehavior: Clip.none,
//                         color: AppColors.backgroundColor,
//                         child: miniplayer())
//                     : (controller.isMiniPlayerOpenHome1.value) == true &&
//                             categoryData1 != null
//                         ? BottomAppBar(
//                             elevation: 0,
//                             height: 60,
//                             padding: EdgeInsets.zero,
//                             clipBehavior: Clip.none,
//                             color: AppColors.backgroundColor,
//                             child: miniplayer())
//                         : (controller.isMiniPlayerOpenHome2.value) == true &&
//                                 categoryData2 != null
//                             ? BottomAppBar(
//                                 elevation: 0,
//                                 height: 60,
//                                 padding: EdgeInsets.zero,
//                                 clipBehavior: Clip.none,
//                                 color: AppColors.backgroundColor,
//                                 child: miniplayer())
//                             : (controller.isMiniPlayerOpenHome3.value) ==
//                                         true &&
//                                     categoryData3 != null
//                                 ? BottomAppBar(
//                                     elevation: 0,
//                                     height: 60,
//                                     padding: EdgeInsets.zero,
//                                     clipBehavior: Clip.none,
//                                     color: AppColors.backgroundColor,
//                                     child: miniplayer())
//                                 : (controller.isMiniPlayerOpenAllSongs.value) ==
//                                             true &&
//                                         allSongsScreenController
//                                                 .allSongsListModel!.data !=
//                                             null
//                                     ? BottomAppBar(
//                                         elevation: 0,
//                                         height: 60,
//                                         padding: EdgeInsets.zero,
//                                         clipBehavior: Clip.none,
//                                         color: AppColors.backgroundColor,
//                                         child: miniplayer())
//                                     : const SizedBox(),
//         //  Column(
//         //   mainAxisSize: MainAxisSize.min,
//         //   children: [
//         //     ((controller.isMiniPlayerOpenHome1.value) == true &&
//         //                 widget.categoryData != null) ||
//         //             ((controller.isMiniPlayerOpenHome2.value) == true &&
//         //                 widget.categoryData != null) ||
//         //             ((controller.isMiniPlayerOpenHome3.value) == true &&
//         //                 widget.categoryData != null)
//         //         ? BottomAppBar(
//         //             elevation: 0,
//         //             height: 60,
//         //             padding: EdgeInsets.zero,
//         //             clipBehavior: Clip.none,
//         //             color: AppColors.backgroundColor,
//         //             child: miniplayer())
//         //         : const SizedBox(),
//         //   ],
//         // ),
//       ),
//     );
//   }

//   Miniplayer miniplayer() {
//     return Miniplayer(
//       minHeight: 60,
//       maxHeight: 60,
//       builder: (height, percentage) {
//         // _initAudioPlayer();
//         return GestureDetector(
//           onTap: () async {
//             Duration? duration;
//             Duration? position;
//             Duration? bufferedPosition;

//             final positionData = await _positionDataStream.first;

//             duration = positionData.duration;
//             position = positionData.position;
//             bufferedPosition = positionData.bufferedPosition;

//             if (kDebugMode) {
//               log("$duration", name: 'duration');
//               log("$position", name: 'position');
//               log("$bufferedPosition", name: 'bufferedPosition');
//               log("${(durationStream)}", name: 'durationStream');
//               log("${(positionStream)}", name: 'positionStream');
//               log("${(bufferedPositionStream)}",
//                   name: 'bufferedPositionStream');
//             }
//             Get.to(
//                 DetailScreen(
//                   index: controller.isMiniPlayerOpenFavoriteSongs.value == true
//                       ? controller.currentListTileIndexFavoriteSongs.value
//                       : controller.isMiniPlayerOpenQueueSongs.value == true
//                           ? controller.currentListTileIndexQueueSongs.value
//                           : controller.isMiniPlayerOpenDownloadSongs.value ==
//                                   true
//                               ? controller
//                                   .currentListTileIndexDownloadSongs.value
//                               : controller.isMiniPlayerOpen.value == true
//                                   ? controller.currentListTileIndex.value
//                                   : controller.isMiniPlayerOpenHome1.value ==
//                                           true
//                                       ? controller
//                                           .currentListTileIndexCategory1.value
//                                       : controller.isMiniPlayerOpenHome2
//                                                   .value ==
//                                               true
//                                           ? controller
//                                               .currentListTileIndexCategory2
//                                               .value
//                                           : controller.isMiniPlayerOpenHome3
//                                                       .value ==
//                                                   true
//                                               ? controller
//                                                   .currentListTileIndexCategory3
//                                                   .value
//                                               : controller.isMiniPlayerOpenAllSongs
//                                                           .value ==
//                                                       true
//                                                   ? controller
//                                                       .currentListTileIndexAllSongs
//                                                       .value
//                                                   : controller
//                                                       .currentListTileIndex
//                                                       .value,
//                   type: controller.isMiniPlayerOpenHome1.value == true ||
//                           controller.isMiniPlayerOpenHome2.value == true ||
//                           controller.isMiniPlayerOpenHome3.value == true
//                       ? 'home'
//                       : controller.isMiniPlayerOpenAllSongs.value == true
//                           ? 'allSongs'
//                           : controller.isMiniPlayerOpen.value == true
//                               ? 'playlist'
//                               : controller.isMiniPlayerOpenDownloadSongs
//                                           .value ==
//                                       true
//                                   ? 'download song'
//                                   : controller.isMiniPlayerOpenQueueSongs
//                                               .value ==
//                                           true
//                                       ? 'queue song'
//                                       : controller.isMiniPlayerOpenFavoriteSongs
//                                                   .value ==
//                                               true
//                                           ? 'favorite song'
//                                       : '',
//                   duration: duration,
//                   position: position,
//                   bufferedPosition: bufferedPosition,
//                   durationStream: durationStream!,
//                   positionStream: positionStream!,
//                   bufferedPositionStream: bufferedPositionStream!,
//                   audioPlayer: controller.isMiniPlayerOpenHome1.value == true ||
//                           controller.isMiniPlayerOpenHome2.value == true ||
//                           controller.isMiniPlayerOpenHome3.value == true ||
//                           controller.isMiniPlayerOpenAllSongs.value == true ||
//                           controller.isMiniPlayerOpen.value == true ||
//                           controller.isMiniPlayerOpenDownloadSongs.value ==
//                               true ||
//                           controller.isMiniPlayerOpenQueueSongs.value == true ||
//                           controller.isMiniPlayerOpenFavoriteSongs.value == true
//                       ? controller.audioPlayer
//                       : controller.audioPlayer,
//                   categoryData1: categoryData1,
//                   categoryData2: categoryData2,
//                   categoryData3: categoryData3,
//                 ),
//                 transition: Transition.downToUp,
//                 duration: const Duration(milliseconds: 600));
//           },
//           child:
//               //  Obx(
//               //   () =>
//               Container(
//             color: AppColors.bottomNavColor,
//             height: 60,
//             width: Get.width,
//             child: Row(
//               children: [
//                 Obx(
//                   () => ClipRRect(
//                     borderRadius: BorderRadius.circular(5),
//                     child: Image.network(
//                       favoriteSongScreenController.allSongsListModel != null &&
//                               (controller.isMiniPlayerOpenFavoriteSongs.value) ==
//                                   true &&
//                               (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                   false &&
//                               (controller.isMiniPlayerOpen.value) == false &&
//                               (controller.isMiniPlayerOpenHome1.value) ==
//                                   false &&
//                               (controller.isMiniPlayerOpenHome2.value) ==
//                                   false &&
//                               (controller.isMiniPlayerOpenHome3.value) ==
//                                   false &&
//                               (controller.isMiniPlayerOpenAllSongs.value) ==
//                                   false &&
//                               (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                   false
//                           ? favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].image ??
//                               'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                           : queueSongsScreenController.allSongsListModel != null &&
//                                   (controller.isMiniPlayerOpenFavoriteSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpen.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome1.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome2.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome3.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenAllSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                       true
//                               ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ??
//                                   'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                               : downloadSongScreenController.allSongsListModel != null &&
//                                       (controller.isMiniPlayerOpenFavoriteSongs.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                           true &&
//                                       (controller.isMiniPlayerOpen.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome1.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome2.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome3.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenAllSongs.value) ==
//                                           false
//                                   ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ??
//                                       'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                   : playlistScreenController.allSongsListModel != null &&
//                                           (controller.isMiniPlayerOpenQueueSongs
//                                                   .value) ==
//                                               false &&
//                                           (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
//                                           (controller.isMiniPlayerOpen.value) == true &&
//                                           (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
//                                           (controller.isMiniPlayerOpenHome1.value) == false &&
//                                           (controller.isMiniPlayerOpenHome2.value) == false &&
//                                           (controller.isMiniPlayerOpenHome3.value) == false &&
//                                           (controller.isMiniPlayerOpenAllSongs.value) == false
//                                       ? playlistScreenController.currentPlayingImage.isNotEmpty
//                                           ? playlistScreenController.currentPlayingImage.value
//                                           : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                       : categoryData1 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                           ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                           : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                               ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                               : categoryData3 != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                                   ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                                   : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
//                                                       ? allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
//                                                       : '',
//                       height: 60,
//                       width: 60,
//                       filterQuality: FilterQuality.high,
//                     ),
//                   ),
//                 ),
//                 sizeBoxWidth(8),
//                 Obx(
//                   () => SizedBox(
//                     width: Get.width * 0.6,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         lable(
//                           text: (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
//                                   (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpen.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome1.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome2.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome3.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenAllSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                       false
//                               ? (favoriteSongScreenController
//                                   .allSongsListModel!
//                                   .data![controller
//                                       .currentListTileIndexFavoriteSongs.value]
//                                   .title)!
//                               : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
//                                       (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                           true &&
//                                       (controller.isMiniPlayerOpen.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome1.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome2.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome3.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenAllSongs.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                           false
//                                   ? (queueSongsScreenController
//                                       .allSongsListModel!
//                                       .data![controller
//                                           .currentListTileIndexQueueSongs.value]
//                                       .title)!
//                                   : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
//                                           (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
//                                           (controller.isMiniPlayerOpenQueueSongs.value) == false &&
//                                           (controller.isMiniPlayerOpen.value) == false &&
//                                           (controller.isMiniPlayerOpenHome1.value) == false &&
//                                           (controller.isMiniPlayerOpenHome2.value) == false &&
//                                           (controller.isMiniPlayerOpenHome3.value) == false &&
//                                           (controller.isMiniPlayerOpenAllSongs.value) == false
//                                       ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title)!
//                                       : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                           ? playlistScreenController.currentPlayingTitle.isNotEmpty
//                                               ? playlistScreenController.currentPlayingTitle.value
//                                               : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
//                                           : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                               ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
//                                               : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                                   ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
//                                                   : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                                       ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
//                                                       : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
//                                                           ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
//                                                           : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         lable(
//                           text: (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
//                                   (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpen.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome1.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome2.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenHome3.value) ==
//                                       false &&
//                                   (controller.isMiniPlayerOpenAllSongs.value) ==
//                                       false
//                               ? (favoriteSongScreenController
//                                   .allSongsListModel!
//                                   .data![controller
//                                       .currentListTileIndexFavoriteSongs.value]
//                                   .description)!
//                               : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
//                                       (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                           true &&
//                                       (controller.isMiniPlayerOpenDownloadSongs.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpen.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome1.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome2.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenHome3.value) ==
//                                           false &&
//                                       (controller.isMiniPlayerOpenAllSongs.value) ==
//                                           false
//                                   ? (queueSongsScreenController
//                                       .allSongsListModel!
//                                       .data![controller
//                                           .currentListTileIndexQueueSongs.value]
//                                       .description)!
//                                   : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
//                                           (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                               false &&
//                                           (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
//                                           (controller.isMiniPlayerOpen.value) == false &&
//                                           (controller.isMiniPlayerOpenHome1.value) == false &&
//                                           (controller.isMiniPlayerOpenHome2.value) == false &&
//                                           (controller.isMiniPlayerOpenHome3.value) == false &&
//                                           (controller.isMiniPlayerOpenAllSongs.value) == false
//                                       ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].description)!
//                                       : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                           ? playlistScreenController.currentPlayingDesc.isNotEmpty
//                                               ? playlistScreenController.currentPlayingDesc.value
//                                               : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
//                                           : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                               ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
//                                               : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                                   ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
//                                                   : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
//                                                       ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
//                                                       : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
//                                                           ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].description)!
//                                                           : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].description)!,
//                           fontSize: 10,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 sizeBoxWidth(6),
//                 ControlButtons(
//                     (controller.isMiniPlayerOpenDownloadSongs.value) == true ||
//                             (controller.isMiniPlayerOpen.value) == true ||
//                             (controller.isMiniPlayerOpenHome1.value) == true ||
//                             (controller.isMiniPlayerOpenHome2.value) == true ||
//                             (controller.isMiniPlayerOpenHome3.value) == true ||
//                             (controller.isMiniPlayerOpenAllSongs.value) ==
//                                 true ||
//                             (controller.isMiniPlayerOpenQueueSongs.value) ==
//                                 true
//                         ? controller.audioPlayer
//                         : controller.audioPlayer,
//                     size: 45),
//               ],
//             ),
//           ),
//           // ),
//         );
//       },
//     );
//   }

//   // ignore: prefer_typing_uninitialized_variables
//   Stream<Duration>? positionStream;
//   // ignore: prefer_typing_uninitialized_variables
//   Stream<Duration>? bufferedPositionStream;
//   // ignore: prefer_typing_uninitialized_variables
//   Stream<Duration?>? durationStream;

//   // Stream<PositionData> get _positionDataStream =>
//   //     rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//   //       positionStream = controller.isMiniPlayerOpenHome1.value == true ||
//   //               controller.isMiniPlayerOpenHome2.value == true ||
//   //               controller.isMiniPlayerOpenHome3.value == true ||
//   //               controller.isMiniPlayerOpenAllSongs.value == true
//   //           ? controller.audioPlayer.positionStream
//   //           : controller.audioPlayer.positionStream,
//   //       bufferedPositionStream =
//   //           controller.isMiniPlayerOpenHome1.value == true ||
//   //                   controller.isMiniPlayerOpenHome2.value == true ||
//   //                   controller.isMiniPlayerOpenHome3.value == true ||
//   //                   controller.isMiniPlayerOpenAllSongs.value == true
//   //               ? controller.audioPlayer.bufferedPositionStream
//   //               : controller.audioPlayer.bufferedPositionStream,
//   //       durationStream = controller.isMiniPlayerOpenHome1.value == true ||
//   //               controller.isMiniPlayerOpenHome2.value == true ||
//   //               controller.isMiniPlayerOpenHome3.value == true ||
//   //               controller.isMiniPlayerOpenAllSongs.value == true
//   //           ? controller.audioPlayer.durationStream
//   //           : controller.audioPlayer.durationStream,
//   //       (position, bufferedPosition, duration) => PositionData(
//   //         position,
//   //         bufferedPosition,
//   //         duration ?? Duration.zero,
//   //       ),
//   //     );
//   Stream<PositionData> get _positionDataStream =>
//       rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         positionStream =
//             controller.isMiniPlayerOpenDownloadSongs.value == true ||
//                     controller.isMiniPlayerOpen.value == true ||
//                     controller.isMiniPlayerOpenHome1.value == true ||
//                     controller.isMiniPlayerOpenHome2.value == true ||
//                     controller.isMiniPlayerOpenHome3.value == true ||
//                     controller.isMiniPlayerOpenAllSongs.value == true ||
//                     controller.isMiniPlayerOpenQueueSongs.value == true ||
//                     (controller.isMiniPlayerOpenFavoriteSongs.value) == true
//                 ? controller.audioPlayer.positionStream
//                 : controller.audioPlayer.positionStream,
//         bufferedPositionStream =
//             controller.isMiniPlayerOpenDownloadSongs.value == true ||
//                     controller.isMiniPlayerOpen.value == true ||
//                     controller.isMiniPlayerOpenHome1.value == true ||
//                     controller.isMiniPlayerOpenHome2.value == true ||
//                     controller.isMiniPlayerOpenHome3.value == true ||
//                     controller.isMiniPlayerOpenAllSongs.value == true ||
//                     controller.isMiniPlayerOpenQueueSongs.value == true ||
//                     (controller.isMiniPlayerOpenFavoriteSongs.value) == true
//                 ? controller.audioPlayer.bufferedPositionStream
//                 : controller.audioPlayer.bufferedPositionStream,
//         durationStream =
//             controller.isMiniPlayerOpenDownloadSongs.value == true ||
//                     controller.isMiniPlayerOpen.value == true ||
//                     controller.isMiniPlayerOpenHome1.value == true ||
//                     controller.isMiniPlayerOpenHome2.value == true ||
//                     controller.isMiniPlayerOpenHome3.value == true ||
//                     controller.isMiniPlayerOpenAllSongs.value == true ||
//                     controller.isMiniPlayerOpenQueueSongs.value == true ||
//                     (controller.isMiniPlayerOpenFavoriteSongs.value) == true
//                 ? controller.audioPlayer.durationStream
//                 : controller.audioPlayer.durationStream,
//         (position, bufferedPosition, duration) => PositionData(
//           position,
//           bufferedPosition,
//           duration ?? Duration.zero,
//         ),
//       );
// }
