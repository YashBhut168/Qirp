import 'dart:developer';
import 'dart:io';

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
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/album_screen/album_song_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/artist_screen/artist_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:siri_wave/siri_wave.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchScreenController searchScreenController =
      Get.put(SearchScreenController());
  TextEditingController searchController = TextEditingController();
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  // MainScreenController controller = MainScreenController();
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  //copy
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                sizeBoxHeight(20),
                commonTextField(
                  borderRadius: 35,
                  backgroundColor: const Color(0xFF383838),
                  cursorColor: Colors.grey,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 13, right: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  focusBorderColor: Colors.grey,
                  borderColor: Colors.transparent,
                  hintText: ' Search for songs, artists, albums..',
                  textColor: Colors.grey,
                  lableColor: Colors.grey,
                  controller: searchController,
                  onChanged: (p0) {
                    setState(() {
                      GlobVar.searchText = searchController.text;
                      searchScreenController.allSearchList(
                          searchText: searchController.text == ''
                              ? ''
                              : searchController.text);
                    });
                  },
                ),
                Obx(
                  () => searchScreenController.isLoading.value == true
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : searchScreenController.allSearchData.isEmpty
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                      AppAsstes.animation.searchAnimation),
                                  lable(
                                      text:
                                          'You can search songs, artists, albums name here.'),
                                ],
                              ),
                            )
                          // Center(
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         // Icon(Icons.star_outline_rounded,
                          //         //     color: AppColors.white, size: 200),
                          //         // sizeBoxHeight(6),
                          //         SizedBox(
                          //           height: 150,
                          //           width: 150,
                          //           child: Lottie.asset(AppAsstes.animation.searchAnimation,
                          //             fit: BoxFit.fill,
                          //           ),
                          //         ),
                          //         lable(text: "You don't have any favorite list."),
                          //       ],
                          //     ),
                          //   )
                          : Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Column(
                                    children: [
                                      sizeBoxHeight(10),
                                      ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: searchScreenController
                                              .allSearchModel!.data!.length,
                                          itemBuilder: (context, index) {
                                            var searchListData =
                                                searchScreenController
                                                    .allSearchModel!
                                                    .data![index];
                                            return ListTile(
                                              onTap: () async {
                                                if (searchListData.type ==
                                                    'artist') {
                                                  artistScreenController
                                                      .artistsSongsList(
                                                          artistId:
                                                              searchListData
                                                                  .id!);
                                                  Get.to(
                                                    const ArtistSongsScreen(),
                                                    transition:
                                                        Transition.leftToRight,
                                                  );
                                                } else if (searchListData
                                                        .type ==
                                                    'album') {
                                                  albumScreenController
                                                      .albumsSongsList(
                                                          albumId:
                                                              searchListData
                                                                  .id!);
                                                  Get.to(
                                                    const AlbumSongsScreen(),
                                                    transition:
                                                        Transition.leftToRight,
                                                  );
                                                } else
                                                // if (searchListData
                                                //         .type ==
                                                //     'song')
                                                {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) async {
                                                    controller
                                                        .updateCurrentListTileIndexSearchSongs(
                                                            index);
                                                  });
                                                  controller
                                                      .isMiniPlayerOpenSearchSongs
                                                      .value = true;
                                                  searchScreenController
                                                          .currentPlayingImage
                                                          .value =
                                                      (searchScreenController
                                                          .allSearchModel!
                                                          .data![index]
                                                          .image)!;
                                                  searchScreenController
                                                          .currentPlayingTitle
                                                          .value =
                                                      (searchScreenController
                                                          .allSearchModel!
                                                          .data![index]
                                                          .title)!;
                                                  searchScreenController
                                                          .currentPlayingDesc
                                                          .value =
                                                      (searchScreenController
                                                          .allSearchModel!
                                                          .data![index]
                                                          .description)!;
                                                  controller.searchSongsUrl =
                                                      [];
                                                  final localFilePath =
                                                      '${AppStrings.localPathMusic}/${searchScreenController.allSearchModel!.data![index].id}.mp3';
                                                  final file =
                                                      File(localFilePath);

                                                  controller
                                                      .addSearchSongsAudioUrlToList(file
                                                              .existsSync()
                                                          ? localFilePath
                                                          : (searchScreenController
                                                              .allSearchModel!
                                                              .data![index]
                                                              .audio!));
                                                  controller.searchSongsUrl =
                                                      controller.searchSongsUrl
                                                          .toSet()
                                                          .toList();
                                                  log('${controller.searchSongsUrl}',
                                                      name:
                                                          'controller.searchSongsUrl');
                                                  // setState(() {
                                                  controller.isMiniPlayerOpen
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenAdminPlaylistSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenDownloadSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenArtistSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenQueueSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenFavoriteSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenAlbumSongs
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenHome
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenHome1
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenHome2
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenHome3
                                                      .value = false;
                                                  controller
                                                      .isMiniPlayerOpenAllSongs
                                                      .value = false;
                                                  controller
                                                      .currentListTileIndexSearchSongs
                                                      .value = index;
                                                  // setState(() {
                                                  //   GlobVar.searchIndex = controller
                                                  //       .currentListTileIndexSearchSongs
                                                  //       .value;
                                                  //   print(
                                                  //       'searchIndex --> ${GlobVar.searchIndex}');
                                                  // });

                                                  controller.initAudioPlayer();
                                                  log(
                                                      controller
                                                          .currentListTileIndexSearchSongs
                                                          .value
                                                          .toString(),
                                                      name:
                                                          'currentListTileIndexSearchSongs log');
                                                  log("${controller.isMiniPlayerOpenSearchSongs.value}",
                                                      name:
                                                          "isMiniPlayerOpenSearchSongs");
                                                  homeScreenController
                                                      .addRecentSongs(
                                                          musicId:
                                                              searchScreenController
                                                                  .allSearchModel!
                                                                  .data![index]
                                                                  .id!)
                                                      .then((value) =>
                                                          homeScreenController
                                                              .recentSongsList());
                                                }

                                                //  else {
                                                //   null;
                                                // }
                                              },
                                              visualDensity:
                                                  const VisualDensity(
                                                horizontal: -4,
                                                vertical: -1,
                                              ),
                                              leading: Stack(
                                                children: [
                                                  Obx(
                                                    () => ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11),
                                                      child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                              controller.isMiniPlayerOpenAlbumSongs.value ==
                                                                  false &&
                                                              controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                                  false &&
                                                              controller.isMiniPlayerOpenArtistSongs.value ==
                                                                  false &&
                                                              controller.isMiniPlayerOpen.value ==
                                                                  false &&
                                                              controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                                  false &&
                                                              controller
                                                                      .isMiniPlayerOpenHome
                                                                      .value ==
                                                                  false &&
                                                              controller
                                                                      .isMiniPlayerOpenSearchSongs
                                                                      .value ==
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
                                                          ? Image.network(
                                                              searchListData
                                                                  .image!,
                                                              height: 70,
                                                              width: 70,
                                                              // fit: BoxFit.fill,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                            )
                                                          : ((controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && searchScreenController.allSearchModel != null) ||
                                                                      (controller.isMiniPlayerOpenAlbumSongs.value == true &&
                                                                          albumScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title &&
                                                                          albumScreenController.allSongsListModel != null) ||
                                                                      (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && artistScreenController.allSongsListModel != null) ||
                                                                      (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].title == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.adminPlaylistSongModel != null) ||
                                                                      (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == searchScreenController.allSearchModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                                      (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.allSongsListModel != null) ||
                                                                      (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == searchScreenController.allSearchModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                                      (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == searchScreenController.allSearchModel!.data![index].title) ||
                                                                      (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == searchScreenController.allSearchModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
                                                                      (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == searchScreenController.allSearchModel!.data![index].title)) &&
                                                                  searchListData.type == 'song'
                                                              ? Opacity(
                                                                  opacity: 0.4,
                                                                  child: Image.network(
                                                                    searchListData
                                                                        .image!,
                                                                    height: 70,
                                                                    width: 70,
                                                                    // fit: BoxFit.fill,
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .high,
                                                                  ))
                                                              : Image.network(
                                                                  searchListData
                                                                      .image!,
                                                                  height: 70,
                                                                  width: 70,
                                                                  // fit: BoxFit.fill,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                ),
                                                    ),
                                                  ),
                                                  Obx(() => Positioned.fill(
                                                        child: Center(
                                                          child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                                  controller.isMiniPlayerOpenAlbumSongs.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpenArtistSongs.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpen.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpenHome.value ==
                                                                      false &&
                                                                  controller.isMiniPlayerOpenSearchSongs.value ==
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
                                                              : (((controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && searchScreenController.allSearchModel != null) || (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].title == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.adminPlaylistSongModel != null) || (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && albumScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && artistScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == searchScreenController.allSearchModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == searchScreenController.allSearchModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) || (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == searchScreenController.allSearchModel!.data![index].title) || (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == searchScreenController.allSearchModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == searchScreenController.allSearchModel!.data![index].title)) &&
                                                                      controller.musicPlay.value == true &&
                                                                      searchListData.type == 'song')
                                                                  ? ColorFiltered(
                                                                      // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                                                                      colorFilter: const ColorFilter
                                                                          .mode(
                                                                          Colors
                                                                              .grey,
                                                                          BlendMode
                                                                              .modulate),
                                                                      child: Transform
                                                                          .scale(
                                                                        scale:
                                                                            2.2,
                                                                        child: SiriWaveform
                                                                            .ios9(
                                                                          controller:
                                                                              controller.siriWaveController,
                                                                          options:
                                                                              const IOS9SiriWaveformOptions(
                                                                            height:
                                                                                130,
                                                                            width:
                                                                                25,
                                                                            showSupportBar:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              title: Obx(
                                                () => lable(
                                                  text: searchListData.title!,
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
                                                          controller
                                                                  .isMiniPlayerOpenHome
                                                                  .value ==
                                                              false &&
                                                          controller
                                                                  .isMiniPlayerOpenSearchSongs
                                                                  .value ==
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
                                                      ? AppColors.white
                                                      : ((controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && searchScreenController.allSearchModel != null) ||
                                                                  (controller.isMiniPlayerOpenAlbumSongs.value == true &&
                                                                      albumScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title &&
                                                                      albumScreenController.allSongsListModel != null) ||
                                                                  (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.currentPlayingAdminTitle.value == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.adminPlaylistSongModel != null) ||
                                                                  (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.currentPlayingTitle.value == searchScreenController.allSearchModel!.data![index].title && artistScreenController.allSongsListModel != null) ||
                                                                  (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == searchScreenController.allSearchModel!.data![index].title && downloadSongScreenController.allSongsListModel != null) ||
                                                                  (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == searchScreenController.allSearchModel!.data![index].title && playlistScreenController.allSongsListModel != null) ||
                                                                  (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == searchScreenController.allSearchModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                                  (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == searchScreenController.allSearchModel!.data![index].title) ||
                                                                  (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == searchScreenController.allSearchModel!.data![index].title && queueSongsScreenController.allSongsListModel != null) ||
                                                                  (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == searchScreenController.allSearchModel!.data![index].title)) &&
                                                              searchListData.type == 'song'
                                                          ? const Color(0xFF2ac5b3)
                                                          : AppColors.white,
                                                ),
                                              ),
                                              subtitle: lable(
                                                text: searchListData.type!,
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            );
                                          }),
                                      sizeBoxHeight(10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                ),
                // Expanded(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Lottie.asset(AppAsstes.animation.searchAnimation),
                //       lable(text: 'You can search music name here.'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
