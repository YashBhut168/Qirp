import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edpal_music_app_ui/controllers/admin_playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/album_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/artist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/search_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
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
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:siri_wave/siri_wave.dart';

class AdminPlaylistSongsScreen extends StatefulWidget {
  const AdminPlaylistSongsScreen({super.key});

  @override
  State<AdminPlaylistSongsScreen> createState() =>
      _AdminPlaylistSongsScreenState();
}

class _AdminPlaylistSongsScreenState extends State<AdminPlaylistSongsScreen> {
  AdminPlaylistScreenController adminPlaylistScreenController =
      Get.put(AdminPlaylistScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());
  SearchScreenController searchScreenController =
      Get.put(SearchScreenController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(
          () => lable(
            text: playlistScreenController.isLoading.value == true
                ? 'PlayList Songs'
                : playlistScreenController.adminPlaylistSongModel!.message!,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => playlistScreenController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : playlistScreenController.isLikePlaylistData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Lottie.asset(
                            AppAsstes.animation.downloadPlaylistAnimation,
                            fit: BoxFit.fill,
                          ),
                        ),
                        lable(
                            text:
                                "Sorry, the list of playlisgt songs is currently unavailable."),
                      ],
                    ),
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
                            itemCount: playlistScreenController
                                .adminPlaylistSongModel!.data!.length,
                            itemBuilder: (context, index) {
                              var playlistSongsData = playlistScreenController
                                  .isLikePlaylistData[index];
                              final localFilePath =
                                  '${AppStrings.localPathMusic}/${playlistScreenController.adminPlaylistSongModel!.data![index].id}.mp3';
                              final file = File(localFilePath);
                              controller.addAdminPlaylistSongsAudioUrlToList(
                                  file.existsSync()
                                      ? localFilePath
                                      : (playlistScreenController
                                          .adminPlaylistSongModel!
                                          .data![index]
                                          .audio)!);
                              controller.adminPlaylistSongsUrl = controller
                                  .adminPlaylistSongsUrl
                                  .toSet()
                                  .toList();
                              // log("albumSongsUrl---> ${controller.albumSongsUrl}");
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      setState(() {
                                        controller.isMiniPlayerOpenArtistSongs
                                            .value = false;
                                        controller.isMiniPlayerOpenAlbumSongs
                                            .value = false;
                                        controller.isMiniPlayerOpenDownloadSongs
                                            .value = false;
                                        controller
                                            .isMiniPlayerOpenAdminPlaylistSongs
                                            .value = true;
                                        log("${controller.isMiniPlayerOpenAdminPlaylistSongs.value}",
                                            name:
                                                "isMiniPlayerOpenAdminPlaylistSongs");
                                        controller.isMiniPlayerOpenQueueSongs
                                            .value = false;
                                        controller.isMiniPlayerOpenFavoriteSongs
                                            .value = false;
                                        controller.isMiniPlayerOpen.value =
                                            false;
                                        controller.isMiniPlayerOpenHome.value =
                                            false;
                                        controller.isMiniPlayerOpenSearchSongs
                                            .value = false;
                                        controller.isMiniPlayerOpenHome1.value =
                                            false;
                                        controller.isMiniPlayerOpenHome2.value =
                                            false;
                                        controller.isMiniPlayerOpenHome3.value =
                                            false;
                                        controller.isMiniPlayerOpenAllSongs
                                            .value = false;
                                        controller
                                            .currentListTileIndexAdminPlaylistSongs
                                            .value = index;
                                        controller
                                            .updateCurrentListTileIndexAdminPlaylistSongs(
                                                index);

                                        controller.initAudioPlayer();

                                        log(
                                            controller
                                                .currentListTileIndexAdminPlaylistSongs
                                                .value
                                                .toString(),
                                            name:
                                                'currentListTileIndexAlbumSongs');
                                      });
                                      homeScreenController.addRecentSongs(
                                          musicId: playlistSongsData.id!);
                                      homeScreenController.recentSongsList();
                                    },
                                    visualDensity: const VisualDensity(
                                        horizontal: -3, vertical: -0),
                                    leading: Stack(
                                      children: [
                                        Obx(
                                          () => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                    controller.isMiniPlayerOpenAlbumSongs.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenArtistSongs.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpen.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenSearchSongs.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenHome.value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenHome1
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenHome2
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenHome3
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenAllSongs
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenQueueSongs
                                                            .value ==
                                                        false)
                                                ? CachedNetworkImage(
                                                    imageUrl: (playlistSongsData
                                                        .image!),
                                                    placeholder:
                                                        (context, url) {
                                                      return const SizedBox();
                                                    },
                                                    height: 70,
                                                    width: 70,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.fill,
                                                  )
                                                : (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.currentPlayingAdminTitle.value == playlistScreenController.adminPlaylistSongModel!.data![index].title && playlistScreenController.adminPlaylistSongModel != null) ||
                                                        (controller.isMiniPlayerOpenAlbumSongs.value == true &&
                                                            albumScreenController
                                                                    .currentPlayingTitle
                                                                    .value ==
                                                                playlistScreenController
                                                                    .adminPlaylistSongModel!
                                                                    .data![index]
                                                                    .title &&
                                                            albumScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && playlistScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                        (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && searchScreenController.allSearchModel != null) ||
                                                        (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title)
                                                    ? Opacity(
                                                        opacity: 0.4,
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                              (playlistSongsData
                                                                  .image!),
                                                          placeholder:
                                                              (context, url) {
                                                            return const SizedBox();
                                                          },
                                                          height: 70,
                                                          width: 70,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          fit: BoxFit.fill,
                                                        ))
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            (playlistSongsData
                                                                .image!),
                                                        placeholder:
                                                            (context, url) {
                                                          return const SizedBox();
                                                        },
                                                        height: 70,
                                                        width: 70,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        fit: BoxFit.fill,
                                                      ),
                                          ),
                                        ),
                                        Obx(
                                          () => Positioned.fill(
                                            child: Center(
                                              child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                      controller.isMiniPlayerOpenAlbumSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenArtistSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpen.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenSearchSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenHome.value ==
                                                          false &&
                                                      controller
                                                              .isMiniPlayerOpenHome1
                                                              .value ==
                                                          false &&
                                                      controller
                                                              .isMiniPlayerOpenHome2
                                                              .value ==
                                                          false &&
                                                      controller
                                                              .isMiniPlayerOpenHome3
                                                              .value ==
                                                          false &&
                                                      controller
                                                              .isMiniPlayerOpenAllSongs
                                                              .value ==
                                                          false &&
                                                      controller
                                                              .isMiniPlayerOpenQueueSongs
                                                              .value ==
                                                          false)
                                                  ? const SizedBox()
                                                  : (((controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.currentPlayingAdminTitle.value == playlistScreenController.adminPlaylistSongModel!.data![index].title && playlistScreenController.adminPlaylistSongModel != null) ||
                                                              (controller.isMiniPlayerOpenAlbumSongs.value == true &&
                                                                  albumScreenController
                                                                          .currentPlayingTitle
                                                                          .value ==
                                                                      playlistScreenController
                                                                          .adminPlaylistSongModel!
                                                                          .data![index]
                                                                          .title &&
                                                                  albumScreenController.allSongsListModel != null) ||
                                                              (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                              (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                              (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && playlistScreenController.allSongsListModel != null) ||
                                                              (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                              (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
                                                              (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && searchScreenController.allSearchModel != null) ||
                                                              (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title)) &&
                                                          controller.musicPlay.value == true)
                                                      ? ColorFiltered(
                                                          // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                                                          colorFilter:
                                                              const ColorFilter
                                                                  .mode(
                                                                  Colors.grey,
                                                                  BlendMode
                                                                      .modulate),
                                                          child:
                                                              Transform.scale(
                                                            scale: 2.2,
                                                            child: SiriWaveform
                                                                .ios9(
                                                              controller: controller
                                                                  .siriWaveController,
                                                              options:
                                                                  const IOS9SiriWaveformOptions(
                                                                height: 130,
                                                                width: 25,
                                                                showSupportBar:
                                                                    false,
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
                                    title: Obx(
                                      () => lable(
                                        text: (playlistSongsData.title)!,
                                        fontSize: 12,
                                        color: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                controller.isMiniPlayerOpenAlbumSongs.value ==
                                                    false &&
                                                controller.isMiniPlayerOpenArtistSongs.value ==
                                                    false &&
                                                controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                    false &&
                                                controller.isMiniPlayerOpen.value ==
                                                    false &&
                                                controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                    false &&
                                                controller.isMiniPlayerOpenSearchSongs.value ==
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
                                            ? AppColors.white
                                            : ((controller.isMiniPlayerOpenAdminPlaylistSongs.value == true &&
                                                        playlistScreenController
                                                                .currentPlayingAdminTitle
                                                                .value ==
                                                            playlistScreenController
                                                                .adminPlaylistSongModel!
                                                                .data![index]
                                                                .title &&
                                                        playlistScreenController.adminPlaylistSongModel !=
                                                            null) ||
                                                    (controller.isMiniPlayerOpenAlbumSongs.value == true &&
                                                        albumScreenController.currentPlayingTitle.value ==
                                                            playlistScreenController
                                                                .adminPlaylistSongModel!
                                                                .data![index]
                                                                .title &&
                                                        albumScreenController.allSongsListModel != null) ||
                                                    (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                    (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                    (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && playlistScreenController.allSongsListModel != null) ||
                                                    (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                    (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title) ||
                                                    (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
                                                    (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title && searchScreenController.allSearchModel != null) ||
                                                    (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.adminPlaylistSongModel!.data![index].title))
                                                ? const Color(0xFF2ac5b3)
                                                : AppColors.white,
                                      ),
                                    ),
                                    subtitle: lable(
                                      text: (playlistSongsData.description)!,
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  sizeBoxHeight(10),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: Obx(
        () => (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == true &&
                playlistScreenController.adminPlaylistSongModel != null
            // &&
            // (controller.isMiniPlayerOpenHome1.value) == false
            ? BottomAppBar(
                elevation: 0,
                height: 60,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                color: AppColors.bottomNavColor,
                child: miniplayer())
            : (controller.isMiniPlayerOpenSearchSongs.value) == true &&
                    searchScreenController.allSearchModel != null
                // &&
                // (controller.isMiniPlayerOpenHome1.value) == false
                ? BottomAppBar(
                    elevation: 0,
                    height: 60,
                    padding: EdgeInsets.zero,
                    clipBehavior: Clip.none,
                    color: AppColors.bottomNavColor,
                    child: miniplayer())
                : (controller.isMiniPlayerOpenArtistSongs.value) == true &&
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
                                favoriteSongScreenController.allSongsListModel !=
                                    null
                            ? BottomAppBar(
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
                                    color: AppColors.backgroundColor,
                                    child: miniplayer())
                                : (controller.isMiniPlayerOpenDownloadSongs.value) == true &&
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
                                        : (controller.isMiniPlayerOpenHome.value) == true &&
                                                homeScreenController
                                                    .homeCategoryData.isNotEmpty
                                            ? BottomAppBar(elevation: 0, height: 60, padding: EdgeInsets.zero, clipBehavior: Clip.none, color: AppColors.backgroundColor, child: miniplayer())
                                            : (controller.isMiniPlayerOpenAllSongs.value) == true && allSongsScreenController.allSongsListModel!.data != null
                                                ? BottomAppBar(elevation: 0, height: 60, padding: EdgeInsets.zero, clipBehavior: Clip.none, color: AppColors.backgroundColor, child: miniplayer())
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
                  index: controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                          true
                      ? controller.currentListTileIndexAdminPlaylistSongs.value
                      : controller.isMiniPlayerOpenSearchSongs.value == true
                          ? controller.currentListTileIndexSearchSongs.value
                          : controller.isMiniPlayerOpenArtistSongs.value == true
                              ? controller.currentListTileIndexArtistSongs.value
                              : controller.isMiniPlayerOpenAlbumSongs.value ==
                                      true
                                  ? controller
                                      .currentListTileIndexAlbumSongs.value
                                  : controller.isMiniPlayerOpenFavoriteSongs.value ==
                                          true
                                      ? controller
                                          .currentListTileIndexFavoriteSongs
                                          .value
                                      : controller.isMiniPlayerOpenQueueSongs.value ==
                                              true
                                          ? controller
                                              .currentListTileIndexQueueSongs
                                              .value
                                          : controller.isMiniPlayerOpenDownloadSongs
                                                      .value ==
                                                  true
                                              ? controller
                                                  .currentListTileIndexDownloadSongs
                                                  .value
                                              : controller.isMiniPlayerOpen.value ==
                                                      true
                                                  ? controller
                                                      .currentListTileIndex
                                                      .value
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
                                                  : controller.isMiniPlayerOpenSearchSongs
                                                              .value ==
                                                          true
                                                      ? 'search'
                                                      : controller.isMiniPlayerOpenAdminPlaylistSongs
                                                                  .value ==
                                                              true
                                                          ? 'admin playlist'
                                                          : '',
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
                          controller.isMiniPlayerOpenArtistSongs.value ==
                              true ||
                          controller.isMiniPlayerOpenSearchSongs.value ==
                              true ||
                          controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                              true
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
                        (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == true &&
                                playlistScreenController.adminPlaylistSongModel !=
                                    null &&
                                (controller.isMiniPlayerOpenSearchSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                    false &&
                                (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                            ? playlistScreenController
                                .currentPlayingAdminImage.value
                            // playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].image ??
                            // 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : searchScreenController.allSearchModel != null &&
                                    (controller.isMiniPlayerOpenSearchSongs.value) ==
                                        true &&
                                    (controller.isMiniPlayerOpenAdminPlaylistSongs
                                            .value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenAlbumSongs.value) ==
                                        false &&
                                    (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                                ? searchScreenController
                                        .allSearchModel!
                                        .data![controller
                                            .currentListTileIndexSearchSongs
                                            .value]
                                        .image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                                        (controller.isMiniPlayerOpenSearchSongs.value) ==
                                            false &&
                                        (controller
                                                .isMiniPlayerOpenAdminPlaylistSongs
                                                .value) ==
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
                                        (controller.isMiniPlayerOpenHome.value) == false &&
                                        (controller.isMiniPlayerOpenHome1.value) == false &&
                                        (controller.isMiniPlayerOpenHome2.value) == false &&
                                        (controller.isMiniPlayerOpenHome3.value) == false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                        (controller.isMiniPlayerOpenQueueSongs.value) == false &&
                                        artistScreenController.allSongsListModel != null
                                    ? artistScreenController.currentPlayingImage.value
                                    // artistScreenController
                                    //         .allSongsListModel!
                                    //         .data![controller
                                    //             .currentListTileIndexArtistSongs.value]
                                    //         .image ??
                                    : albumScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenAlbumSongs.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                        ? albumScreenController.currentPlayingImage.value
                                        // albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : favoriteSongScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                            ? favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : queueSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true
                                                ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                : downloadSongScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    : playlistScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        ? playlistScreenController.currentPlayingImage.isNotEmpty
                                                            ? playlistScreenController.currentPlayingImage.value
                                                            : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        // : (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && categoryData1 != null && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        //     ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        //     : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        //         ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        //         : categoryData3 != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        //             ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        : homeScreenController.homeCategoryData.isNotEmpty && (controller.isMiniPlayerOpenHome.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                            ? homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                            : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                          text: (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                  (controller.isMiniPlayerOpenArtistSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
                                      true &&
                                  (controller.isMiniPlayerOpenQueueSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenSearchSongs.value) ==
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
                              ? playlistScreenController
                                  .currentPlayingAdminTitle.value
                              // (playlistScreenController
                              //     .adminPlaylistSongModel!
                              //     .data![controller
                              //         .currentListTileIndexAdminPlaylistSongs.value]
                              //     .title)!
                              : (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenSearchSongs.value) ==
                                          true &&
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
                                  ? (searchScreenController
                                      .allSearchModel!
                                      .data![controller
                                          .currentListTileIndexSearchSongs
                                          .value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenArtistSongs.value) == true &&
                                          (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                          (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false &&
                                          (controller.isMiniPlayerOpenSearchSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) == false &&
                                          (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) == false &&
                                          (controller.isMiniPlayerOpenHome.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                          (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                      ? artistScreenController.currentPlayingTitle.value
                                      : (controller.isMiniPlayerOpenAlbumSongs.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                          ? albumScreenController.currentPlayingTitle.value
                                          //  (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].title)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                              ? (favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                                  ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? playlistScreenController.currentPlayingTitle.isNotEmpty
                                                              ? playlistScreenController.currentPlayingTitle.value
                                                              : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                                          // : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          //     ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                                          //     : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          //         ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                                          //         : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          //             ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                                          : homeScreenController.homeCategoryData.isNotEmpty && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == true && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
                                                              ? (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].title)!
                                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                                  ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                                  : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                  (controller.isMiniPlayerOpenSearchSongs.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
                                      true &&
                                  (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                              ? playlistScreenController
                                  .currentPlayingAdminDesc.value
                              // (playlistScreenController
                              //     .adminPlaylistSongModel!
                              //     .data![controller
                              //         .currentListTileIndexAdminPlaylistSongs.value]
                              //     .description)!
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                      (controller.isMiniPlayerOpenSearchSongs.value) ==
                                          true &&
                                      (controller
                                              .isMiniPlayerOpenAdminPlaylistSongs
                                              .value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
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
                                  ? (searchScreenController
                                      .allSearchModel!
                                      .data![controller
                                          .currentListTileIndexSearchSongs
                                          .value]
                                      .description)!
                                  : homeScreenController.homeCategoryData.isNotEmpty &&
                                          (controller.isMiniPlayerOpenHome.value) == true &&
                                          (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false &&
                                          (controller.isMiniPlayerOpenArtistSongs.value) == false &&
                                          (controller.isMiniPlayerOpenSearchSongs.value) == false &&
                                          (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                          (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                          (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                          (controller.isMiniPlayerOpen.value) == false &&
                                          (controller.isMiniPlayerOpenHome1.value) == false &&
                                          (controller.isMiniPlayerOpenHome2.value) == false &&
                                          (controller.isMiniPlayerOpenHome3.value) == false &&
                                          (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                          (controller.isMiniPlayerOpenQueueSongs.value) == false
                                      ? (homeScreenController.homeCategoryModel!.data![controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].description)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == true && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? artistScreenController.currentPlayingDesc.value
                                          // (artistScreenController.allSongsListModel!.data![controller.currentListTileIndexArtistSongs.value].description)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == true && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? albumScreenController.currentPlayingDesc.value
                                              // (albumScreenController.allSongsListModel!.data![controller.currentListTileIndexAlbumSongs.value].description)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].description)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].description)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].description)!
                                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              ? playlistScreenController.currentPlayingDesc.isNotEmpty
                                                                  ? playlistScreenController.currentPlayingDesc.value
                                                                  : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
                                                              // : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              //     ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                                              //     : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              //         ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                                              //         : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                              //             ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
                                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                                true ||
                            (controller.isMiniPlayerOpenSearchSongs.value) ==
                                true ||
                            (controller.isMiniPlayerOpenAdminPlaylistSongs
                                    .value) ==
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
        positionStream = controller.isMiniPlayerOpenDownloadSongs.value ==
                    true ||
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
                    (controller.isMiniPlayerOpenArtistSongs.value) == true ||
                    (controller.isMiniPlayerOpenSearchSongs.value) == true ||
                    (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
                        true
                ? controller.audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream = controller.isMiniPlayerOpenDownloadSongs.value ==
                    true ||
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
            ? controller.audioPlayer.durationStream
            : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}
