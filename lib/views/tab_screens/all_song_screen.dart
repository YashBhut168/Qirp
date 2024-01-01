import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
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
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siri_wave/siri_wave.dart';

class AllSongScreen extends StatefulWidget {
  final String myPlaylistId;
  final String playlistTitle;

  const AllSongScreen(
      {super.key, required this.myPlaylistId, required this.playlistTitle});

  @override
  State<AllSongScreen> createState() => _AllSongScreenState();
}

class _AllSongScreenState extends State<AllSongScreen> {
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
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
  SearchScreenController searchScreenController = Get.put(SearchScreenController());

  TextEditingController searchController = TextEditingController();

  final apiHelper = ApiHelper();

  bool isLoading = false;
  CategoryData? categoryData1;
  CategoryData? categoryData2;
  CategoryData? categoryData3;

  @override
  void initState() {
    super.initState();
    fetchData();
    homeScreenController.homeCategories();
    allSongsScreenController.allSongsList();
    log("${allSongsScreenController.filteredAllSongsTitles}",
        name: 'filteredAllSongsTitles');
    downloadSongScreenController.downloadSongsList();
    GlobVar.playlistId == ''
        ? null
        : playlistScreenController.songsInPlaylist(
            playlistId: GlobVar.playlistId);
    log("${controller.isMiniPlayerOpenAllSongs.value}",
        name: 'controller.isMiniPlayerOpenAllSongs.value');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // ignore: unnecessary_null_comparison
    if (allSongsScreenController.isLikeAllSongData != null) {
      allSongsScreenController.filteredAllSongsTitles = List.generate(
        allSongsScreenController.isLikeAllSongData.length,
        (index) =>
            (allSongsScreenController.allSongsListModel!.data![index].title) ??
            '',
      );
      allSongsScreenController.filteredAllSongsIds = List.generate(
        allSongsScreenController.isLikeAllSongData.length,
        (index) =>
            (allSongsScreenController.allSongsListModel!.data![index].id) ?? '',
      );
      allSongsScreenController.filteredAllSongsAudios = List.generate(
        allSongsScreenController.isLikeAllSongData.length,
        (index) =>
            (allSongsScreenController.allSongsListModel!.data![index].audio) ??
            '',
      );
      allSongsScreenController.filteredAllSongsDesc = List.generate(
        allSongsScreenController.isLikeAllSongData.length,
        (index) =>
            (allSongsScreenController
                .allSongsListModel!.data![index].description) ??
            'song',
      );
      // print('allSongsScreenController.filteredAllSongsDesc ----> ${allSongsScreenController.filteredAllSongsDesc}');
      allSongsScreenController.filteredAllSongsImage = List.generate(
        allSongsScreenController.isLikeAllSongData.length,
        (index) =>
            (allSongsScreenController.allSongsListModel!.data![index].image) ??
            '',
      );
    } else {
      allSongsScreenController.filteredAllSongsTitles = [];
    }
    // });
  }

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
    log("${controller.allSongsUrl.toList()}");

    controller.allSongsUrl = [];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Icon(
          Icons.menu,
          color: AppColors.white,
        ),
        title: lable(
            text: AppStrings.allSongs,
            fontSize: 18,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: commonTextField(
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
                  hintText: 'What are you looking for?',
                  textColor: Colors.grey,
                  lableColor: Colors.grey,
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      allSongsScreenController.filterAllSonglistTitles(query);
                    });
                  },
                ),
              ),
              sizeBoxHeight(10),
              Obx(
                () => allSongsScreenController.isLoading.value == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : allSongsScreenController.allSongsListModel == null
                        // && (categoryData1 != null || categoryData2 != null || categoryData3 != null)
                        ? Center(
                            child: lable(text: 'All song list is empty'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allSongsScreenController
                                .filteredAllSongsTitles.length,
                            itemBuilder: (context, index) {
                              // var allSongsListData = allSongsScreenController
                              //     .allSongsListModel!.data![index];
                              log('${allSongsScreenController.filteredAllSongsTitles}',
                                  name: 'filteredAllSongsTitles');

                              final localFilePath =
                                  '${AppStrings.localPathMusic}/${allSongsScreenController.filteredAllSongsIds[index]}.mp3';
                              final file = File(localFilePath);

                              controller.addAllSongsAudioUrlToList(
                                  file.existsSync()
                                      ? localFilePath
                                      : (allSongsScreenController
                                          .filteredAllSongsAudios[index]));
                              controller.allSongsUrl =
                                  controller.allSongsUrl.toSet().toList();
                              return GestureDetector(
                                onTap: () async {
                                  // controller.isMiniPlayerOpen.value == true
                                  //     ? (controller.audioPlayer)!.dispose()
                                  //     : null;
                                  setState(() {
                                    // (controller.audioPlayer)!.load();
                                    controller.isMiniPlayerOpen.value = false;
                                    controller.isMiniPlayerOpenDownloadSongs
                                        .value = false;
                                    controller.isMiniPlayerOpenAdminPlaylistSongs
                                        .value = false;
                                        controller.isMiniPlayerOpenArtistSongs
                                            .value = false;
                                    controller.isMiniPlayerOpenQueueSongs
                                        .value = false;
                                    controller.isMiniPlayerOpenFavoriteSongs
                                        .value = false;
                                    controller.isMiniPlayerOpenAlbumSongs
                                                        .value = false;
                                    controller.isMiniPlayerOpenHome.value =
                                        false;
                                    controller.isMiniPlayerOpenHome1.value =
                                        false;
                                    controller.isMiniPlayerOpenHome2.value =
                                        false;
                                    controller.isMiniPlayerOpenHome3.value =
                                        false;
                                    controller.isMiniPlayerOpenSearchSongs.value = false;
                                    controller.isMiniPlayerOpenAllSongs.value =
                                        true;
                                    controller.currentListTileIndexAllSongs
                                        .value = index;
                                    controller
                                        .updateCurrentListTileIndexAllSongs(
                                            index);
                                    controller.initAudioPlayer();
                                    log(
                                        controller
                                            .currentListTileIndexAllSongs.value
                                            .toString(),
                                        name:
                                            'currentListTileIndexAllSongs home log');
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.reload();

                                  await prefs.setBool(
                                      'isMiniPlayerOpen', false);
                                  await prefs.setBool(
                                      'isMiniPlayerOpenAllSongs', true);
                                  await prefs.setInt('allSongsIndex', index);
                                  homeScreenController
                                      .addRecentSongs(
                                          musicId: allSongsScreenController
                                              .filteredAllSongsIds[index])
                                      .then((value) => homeScreenController
                                          .recentSongsList());

                                  log("${categoryData1!.data![controller.currentListTileIndexCategory1.value].title}",
                                      name: 'ca1');
                                },
                                child: ListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -1),
                                  leading: Stack(
                                    children: [
                                      Obx(
                                        () => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(11),
                                            child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                    controller.isMiniPlayerOpen.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                                    controller.isMiniPlayerOpenAlbumSongs.value ==
                                                    false &&
                                                    controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
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
                                                    controller.isMiniPlayerOpenFavoriteSongs
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenQueueSongs
                                                            .value ==
                                                        false)
                                                ? Image.network((allSongsScreenController.filteredAllSongsImage[index]),
                                                    height: 70,
                                                    width: 70,
                                                    filterQuality:
                                                        FilterQuality.high)
                                                : (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == allSongsScreenController.filteredAllSongsAudios[index] && allSongsScreenController.allSongsListModel != null) ||
                                                        (controller.isMiniPlayerOpenHome1.value == true &&
                                                            categoryData1 !=
                                                                null &&
                                                            categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                                allSongsScreenController
                                                                    .allSongsListModel!
                                                                    .data![index]
                                                                    .title) ||
                                                        (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == allSongsScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                        (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel!.data!.isNotEmpty && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel!.data!.isNotEmpty && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                        (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == allSongsScreenController.allSongsListModel!.data![index].title && playlistScreenController.allSongsListModel != null)
                                                    ?
                                                    // Stack(
                                                    //     children: [
                                                    Opacity(
                                                        opacity: 0.4,
                                                        child: Image.network(
                                                          (allSongsScreenController
                                                                  .filteredAllSongsImage[
                                                              index]),
                                                          height: 70,
                                                          width: 70,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                        ),
                                                      )
                                                    //     BackdropFilter(
                                                    //       filter:
                                                    //           ImageFilter
                                                    //               .blur(
                                                    //         sigmaX: 0.7,
                                                    //         sigmaY: 0.7,
                                                    //       ),
                                                    //       blendMode: BlendMode.srcOver,
                                                    //       child: const SizedBox(
                                                    //         height: 70,
                                                    //         width: 70,
                                                    //       ),
                                                    //     )
                                                    //   ],
                                                    // )
                                                    : Image.network(
                                                        (allSongsScreenController
                                                                .filteredAllSongsImage[
                                                            index]),
                                                        height: 70,
                                                        width: 70,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                      )),
                                      ),
                                      Obx(
                                        () => Positioned.fill(
                                          child: Center(
                                            child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                    controller.isMiniPlayerOpen.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                                    controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                      false &&
                                                    controller.isMiniPlayerOpenHome.value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenAlbumSongs.value ==
                                                    false &&
                                                    controller
                                                            .isMiniPlayerOpenHome1
                                                            .value ==
                                                        false &&
                                                    controller.isMiniPlayerOpenSearchSongs.value ==
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
                                                            .isMiniPlayerOpenFavoriteSongs
                                                            .value ==
                                                        false &&
                                                    controller
                                                            .isMiniPlayerOpenQueueSongs
                                                            .value ==
                                                        false)
                                                ? const SizedBox()
                                                : (((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == allSongsScreenController.filteredAllSongsAudios[index] && allSongsScreenController.allSongsListModel != null) ||
                                                            (controller.isMiniPlayerOpenHome1.value == true &&
                                                                categoryData1 !=
                                                                    null &&
                                                                categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                                    allSongsScreenController
                                                                        .allSongsListModel!
                                                                        .data![index]
                                                                        .title) ||
                                                            (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == allSongsScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                            (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel!.data!.isNotEmpty && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel!.data!.isNotEmpty && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                            (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == allSongsScreenController.allSongsListModel!.data![index].title && playlistScreenController.allSongsListModel != null)) &&
                                                        controller.musicPlay.value == true)
                                                    ? ColorFiltered(
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.grey,
                                                                BlendMode
                                                                    .modulate),
                                                        child: Transform.scale(
                                                          scale: 2.2,
                                                          child:
                                                              SiriWaveform.ios9(
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
                                      text: (allSongsScreenController
                                          .filteredAllSongsTitles[index]),
                                      fontSize: 12,
                                      color:
                                          // allSongsScreenController
                                          //                 .allSongsListModel!
                                          //                 .data![
                                          //             controller
                                          //                 .currentListTileIndexAllSongs
                                          //                 .value] ==
                                          //         allSongsScreenController
                                          //             .allSongsListModel!
                                          //             .data![index]
                                          (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                  controller.isMiniPlayerOpen.value ==
                                                      false &&
                                                  controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                                  controller.isMiniPlayerOpenAlbumSongs.value ==
                                                    false &&
                                                  controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
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
                                                  controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                      false &&
                                                  controller
                                                          .isMiniPlayerOpenQueueSongs
                                                          .value ==
                                                      false)
                                              ? Colors.white
                                              : (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == allSongsScreenController.filteredAllSongsAudios[index] && allSongsScreenController.allSongsListModel != null) ||
                                                      (controller.isMiniPlayerOpenHome1.value == true &&
                                                          categoryData1 !=
                                                              null &&
                                                          categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                              allSongsScreenController
                                                                  .allSongsListModel!
                                                                  .data![index]
                                                                  .title) ||
                                                      (controller.isMiniPlayerOpenHome2.value == true &&
                                                          categoryData2 !=
                                                              null &&
                                                          categoryData2!.data![controller.currentListTileIndexCategory2.value].title ==
                                                              allSongsScreenController
                                                                  .allSongsListModel!
                                                                  .data![index]
                                                                  .title) ||
                                                      (controller.isMiniPlayerOpenHome3.value == true &&
                                                          categoryData3 != null &&
                                                          categoryData3!.data![controller.currentListTileIndexCategory3.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel!.data!.isNotEmpty && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == allSongsScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                      (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel!.data!.isNotEmpty && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == allSongsScreenController.allSongsListModel!.data![index].title) ||
                                                      (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == allSongsScreenController.allSongsListModel!.data![index].title && playlistScreenController.allSongsListModel != null)
                                                  ? const Color(0xFF2ac5b3)
                                                  : Colors.white,
                                    ),
                                  ),
                                  subtitle: lable(
                                    text: (allSongsScreenController
                                        .filteredAllSongsDesc[index]),
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ListTile(
//   visualDensity: const VisualDensity(
//       horizontal: -4, vertical: -1),
//   leading: ClipRRect(
//     borderRadius: BorderRadius.circular(11),
//     child: Image.network(
//       (allSongsListData.image) ??
//           'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
//       height: 70,
//       width: 70,
//       filterQuality: FilterQuality.high,
//     ),
//   ),
//   title: lable(text: (allSongsListData.title)!),
//   subtitle:
//       lable(text: (allSongsListData.description)!),
//       trailing: Checkbox(value: null,),
// );
