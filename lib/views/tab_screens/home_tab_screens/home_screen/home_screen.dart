// ignore: unused_import
import 'dart:developer';
import 'dart:io';
// import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/extenstions.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/see_all_songs/see_all_songs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siri_wave/siri_wave.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  final apiHelper = ApiHelper();

  @override
  void initState() {
    // fetchData();
    homeScreenController.recentSongsList();
    // homeScreenController.homeCategories();
    setState(() {
      log(controller.isMiniPlayerOpen.value.toString(),
          name: 'home::: isMiniPlayerOpen');
      log(controller.isMiniPlayerOpenHome1.value.toString(),
          name: 'home::: isMiniPlayerOpenHome1');
      log(controller.isMiniPlayerOpenHome2.value.toString(),
          name: 'home::: isMiniPlayerOpenHome2');
      log(controller.isMiniPlayerOpenHome3.value.toString(),
          name: 'home::: isMiniPlayerOpenHome3');
      log(controller.isMiniPlayerOpenAllSongs.value.toString(),
          name: 'home::: isMiniPlayerOpenAllSongs');
      log(controller.currentListTileIndexCategory1.value.toString(),
          name: 'home::: currentListTileIndexCategory1');
      log(controller.currentListTileIndexAllSongs.value.toString(),
          name: 'home::: currentListTileIndexAllSongs');
      log(controller.currentListTileIndexDownloadSongs.value.toString(),
          name: 'home::: currentListTileIndexDownloadSongs');
      log(controller.currentListTileIndexQueueSongs.value.toString(),
          name: 'home::: currentListTileIndexQueueSongs');
      log(controller.currentListTileIndexFavoriteSongs.value.toString(),
          name: 'home::: currentListTileIndexFavoriteSongs');
    });
    super.initState();
    sharedPref();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen') ?? false;
    bool? login = prefs.getBool('isLoggedIn');
    GlobVar.login = login;
    log("$login", name: "login");
    log("$isMiniPlayerOpen");
    int currentListTileIndex = prefs.getInt('currentListTileIndex') ?? 0;
    log("$currentListTileIndex");
    // controller.toggleMiniPlayer(isMiniPlayerOpen);
    controller.updateCurrentListTileIndex(currentListTileIndex);
  }

  // bool isLoading = false;
  // CategoryData? categoryData1;
  // CategoryData? categoryData2;
  // CategoryData? categoryData3;

  // Future<void> fetchData() async {
  //   setState(() {
  //     if (mounted) {
  //       isLoading = true;
  //     }
  //   });

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final login = prefs.getBool('isLoggedIn') ?? '';
  //     if (kDebugMode) {
  //       print(login);
  //     }
  //     final categoryData1Json = login == false
  //         ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory1')
  //         : await apiHelper.fetchHomeCategoryData('category1');
  //     final categoryData2Json = login == false
  //         ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory2')
  //         : await apiHelper.fetchHomeCategoryData('category2');
  //     final categoryData3Json = login == false
  //         ? await apiHelper.noAuthFetchHomeCategoryData('noauthcategory3')
  //         : await apiHelper.fetchHomeCategoryData('category3');

  //     categoryData1 = CategoryData.fromJson(categoryData1Json);
  //     categoryData2 = CategoryData.fromJson(categoryData2Json);
  //     categoryData3 = CategoryData.fromJson(categoryData3Json);

  //     setState(() {
  //       if (mounted) {
  //         isLoading = false;
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //       isLoading = false;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    log("${controller.category1AudioUrl.toList()}");
    log("${controller.category2AudioUrl.toList()}");
    log("${controller.category3AudioUrl.toList()}");
    log("${controller.categoryAudioUrl.toList()}");

    controller.category1AudioUrl = [];
    controller.category2AudioUrl = [];
    controller.category3AudioUrl = [];

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var systemOverlayStyle = const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.bottomNavColor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body:
            // categoryData1 == null ||
            //         categoryData2 == null ||
            //         categoryData3 == null
            //     // ||
            Obx(
          () => homeScreenController.isLoadingHome.value == true
              // ||
              // // ignore: unnecessary_null_comparison
              // homeScreenController.allSongsListModel == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.white,
                ))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // GlobVar.login == true ?
                        SizedBox(
                          height: h * 0.01,
                        ),
                        // : const SizedBox(),

                        ///---------------------- recent song
                        GlobVar.login == true
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: lable(
                                  text: AppStrings.recentlyPlayed,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.35,
                                ),
                              )
                            : const SizedBox(),
                        GlobVar.login == true
                            ? SizedBox(
                                height: h * 0.005,
                              )
                            : const SizedBox(),
                        GlobVar.login == true
                            ? SizedBox(
                                height: h * 0.225,
                                child: Obx(
                                  () =>
                                      // homeScreenController.allSongsListModel ==
                                      //             null ||
                                      homeScreenController.data.isEmpty
                                          ? Center(
                                              child: lable(
                                                  text: 'No recent songs'),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: homeScreenController
                                                  .data.length,
                                              itemBuilder: (context, index) {
                                                log('${homeScreenController.data.length}',
                                                    name: 'recent list length');
                                                return GestureDetector(
                                                  onTap: () async {},
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(1, 0, 1, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: h * 0.02,
                                                        ),
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  (homeScreenController
                                                                      .data[
                                                                          index]
                                                                      .image),
                                                              placeholder:
                                                                  (context,
                                                                      url) {
                                                                return const SizedBox();
                                                              },
                                                              height: 110,
                                                              width: 110,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                            )
                                                            //  Image.network(
                                                            //   (homeScreenController
                                                            //           .data[index].image) ??
                                                            //       'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                                            //   height: 110,
                                                            //   width: 110,
                                                            //   filterQuality:
                                                            //       FilterQuality.high,
                                                            // ),
                                                            ),
                                                        SizedBox(
                                                          height: h * 0.01,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.28,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: lable(
                                                              text:
                                                                  (homeScreenController
                                                                      .data[
                                                                          index]
                                                                      .title)!,
                                                              fontSize: 12,
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                ),
                              )
                            : const SizedBox(),
                        GlobVar.login == true
                            ? SizedBox(
                                height: h * 0.035,
                              )
                            : const SizedBox(),

                        ///---------------------- category song dynamic

                        Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                homeScreenController.homeCategoryData.length,
                            itemBuilder: (context, categoryIndex) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: lable(
                                      text: homeScreenController
                                          .homeCategoryData[categoryIndex]
                                          .category,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.005,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: h * 0.20,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: homeScreenController
                                                .homeCategoryData[categoryIndex]
                                                .categoryData
                                                .length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  controller.categoryAudioUrl =
                                                      [];
                                                  controller
                                                      .currentListTileIndexCategory
                                                      .value = categoryIndex;
                                                  controller
                                                      .currentListTileIndexCategoryData
                                                      .value = index;
                                                  if (kDebugMode) {
                                                    print(
                                                        'current ListTile Index Category----> ${controller.currentListTileIndexCategory.value}');
                                                    print(
                                                        "current music index ------> ${controller.currentListTileIndexCategoryData.value}");
                                                  }
                                                  setState(() {
                                                    Future.delayed(const Duration(milliseconds: 600));
                                                    // GlobVar.homeCateIndex =
                                                    //     controller
                                                    //         .currentListTileIndexCategory
                                                    //         .value;
                                                    // GlobVar.homeCateSongIndex =
                                                    //     controller
                                                    //         .currentListTileIndexCategoryData
                                                    //         .value;
                                                    // if (kDebugMode) {
                                                    //   print(
                                                    //       'GlobVar home Cate Index----> ${GlobVar.homeCateIndex}');
                                                    //   print(
                                                    //       "GlobVar home Cate Song Index ------> ${GlobVar.homeCateSongIndex}");
                                                    // }
                                                    // ignore: unused_local_variable
                                                    var categorySongIds =
                                                        List.generate(
                                                            homeScreenController
                                                                .homeCategoryData[
                                                                    controller
                                                                        .currentListTileIndexCategory
                                                                        .value]
                                                                .categoryData
                                                                .length,
                                                            (index) {
                                                      // ignore: unused_local_variable
                                                      var categoyIdUrl =
                                                          homeScreenController
                                                              .homeCategoryData[
                                                                  controller
                                                                      .currentListTileIndexCategory
                                                                      .value]
                                                              .categoryData[
                                                                  index]
                                                              .id!;
                                                      final localFilePath =
                                                          '${AppStrings.localPathMusic}/${homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[index].id!}.mp3';
                                                      final file =
                                                          File(localFilePath);
                                                      controller.addCategoryAudioUrlToList(file
                                                              .existsSync()
                                                          ? localFilePath
                                                          : (homeScreenController
                                                              .homeCategoryData[
                                                                  controller
                                                                      .currentListTileIndexCategory
                                                                      .value]
                                                              .categoryData[
                                                                  index]
                                                              .audio)!);
                                                      // print(
                                                      // 'allsongaudios-----> ${allSongAudios}');
                                                      controller
                                                              .categoryAudioUrl =
                                                          controller
                                                              .categoryAudioUrl
                                                              .toSet()
                                                              .toList();
                                                      log("${controller.categoryAudioUrl}",
                                                          name:
                                                              'category list');
                                                    });
                                                    controller
                                                        .isMiniPlayerOpenHome
                                                        .value = true;
                                                    controller
                                                        .isMiniPlayerOpenFavoriteSongs
                                                        .value = false;
                                                    controller
                                                        .isMiniPlayerOpenDownloadSongs
                                                        .value = false;
                                                    controller
                                                        .isMiniPlayerOpenQueueSongs
                                                        .value = false;
                                                    controller.isMiniPlayerOpen
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
                                                    // controller
                                                    //     .currentListTileIndexCategoryData
                                                    //     .value = index;
                                                    log("${controller.isMiniPlayerOpenFavoriteSongs.value}",
                                                        name:
                                                            "isMiniPlayerOpenFavoriteSongs");
                                                    log("${controller.isMiniPlayerOpenQueueSongs.value}",
                                                        name:
                                                            "isMiniPlayerOpenQueueSongs");
                                                    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
                                                        name:
                                                            "isMiniPlayerOpenDownloadSongs");
                                                    log("${controller.isMiniPlayerOpen.value}",
                                                        name:
                                                            "isMiniPlayerOpen");
                                                    log("${controller.isMiniPlayerOpenHome.value}",
                                                        name:
                                                            "isMiniPlayerOpenHome");
                                                    log("${controller.isMiniPlayerOpenHome1.value}",
                                                        name:
                                                            "isMiniPlayerOpenHome1");
                                                    log("${controller.isMiniPlayerOpenHome2.value}",
                                                        name:
                                                            "isMiniPlayerOpenHome2");
                                                    log("${controller.isMiniPlayerOpenHome3.value}",
                                                        name:
                                                            "isMiniPlayerOpenHome3");
                                                    log("${controller.isMiniPlayerOpenAllSongs.value}",
                                                        name:
                                                            "isMiniPlayerOpenAllSongs");
                                                    // controller
                                                    //     .currentListTileIndexCategory
                                                    //     .value = categoryIndex;
                                                    // controller
                                                    //     .currentListTileIndexCategoryData
                                                    //     .value = index;
                                                    // if (kDebugMode) {
                                                    //   print(
                                                    //       'current ListTileIndex Category----> ${controller.currentListTileIndexCategory.value}');
                                                    //   print(
                                                    //       "current music index ------> ${controller.currentListTileIndexCategoryData.value}");
                                                    // }
                                                    // controller
                                                    //     .updateCurrentListTileIndexCategory(
                                                    //         index);
                                                    controller
                                                        .initAudioPlayer();
                                                    log(
                                                        controller
                                                            .currentListTileIndexCategoryData
                                                            .value
                                                            .toString(),
                                                        name:
                                                            'current ListTileIndex CategoryData home log');
                                                  });
                                                  homeScreenController
                                                      .addRecentSongs(
                                                          musicId: homeScreenController
                                                              .homeCategoryData[
                                                                  controller
                                                                      .currentListTileIndexCategory
                                                                      .value]
                                                              .categoryData[
                                                                  index]
                                                              .id!)
                                                      .then((value) =>
                                                          homeScreenController
                                                              .recentSongsList());
                                                },
                                                child: Padding(
                                                  // padding: const EdgeInsets.symmetric(
                                                  //     horizontal: 8),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 13, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: h * 0.02,
                                                      ),
                                                      Stack(
                                                        children: [
                                                          Obx(
                                                            () => ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                                      controller.isMiniPlayerOpen.value ==
                                                                          false &&
                                                                      controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                                          false &&
                                                                      controller.isMiniPlayerOpenHome.value ==
                                                                          false &&
                                                                      controller.isMiniPlayerOpenHome1.value ==
                                                                          false &&
                                                                      controller.isMiniPlayerOpenHome2.value == false &&
                                                                      controller.isMiniPlayerOpenHome3.value == false &&
                                                                      controller.isMiniPlayerOpenAllSongs.value == false &&
                                                                      controller.isMiniPlayerOpenQueueSongs.value == false)
                                                                  ? CachedNetworkImage(
                                                                      imageUrl: (homeScreenController
                                                                          .homeCategoryData[
                                                                              categoryIndex]
                                                                          .categoryData[
                                                                              index]
                                                                          .image!),
                                                                      placeholder:
                                                                          (context,
                                                                              url) {
                                                                        return const SizedBox();
                                                                      },
                                                                      height:
                                                                          110,
                                                                      width:
                                                                          110,
                                                                      filterQuality:
                                                                          FilterQuality
                                                                              .high,
                                                                    )
                                                                  : ((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                                                                          (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData.isNotEmpty && (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].title!) == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          // (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          // (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          // (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                          (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!) && playlistScreenController.allSongsListModel != null))
                                                                      ? Opacity(
                                                                          opacity:
                                                                              0.4,
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                (homeScreenController.homeCategoryData[categoryIndex].categoryData[index].image!),
                                                                            placeholder:
                                                                                (context, url) {
                                                                              return const SizedBox();
                                                                            },
                                                                            height:
                                                                                110,
                                                                            width:
                                                                                110,
                                                                            filterQuality:
                                                                                FilterQuality.high,
                                                                          ),
                                                                        )
                                                                      : CachedNetworkImage(
                                                                          imageUrl: (homeScreenController
                                                                              .homeCategoryData[categoryIndex]
                                                                              .categoryData[index]
                                                                              .image!),
                                                                          placeholder:
                                                                              (context, url) {
                                                                            return const SizedBox();
                                                                          },
                                                                          height:
                                                                              110,
                                                                          width:
                                                                              110,
                                                                          filterQuality:
                                                                              FilterQuality.high,
                                                                        ),
                                                            ),
                                                          ),
                                                          Obx(
                                                            () =>
                                                                Positioned.fill(
                                                              child: Center(
                                                                child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                                        controller.isMiniPlayerOpen.value ==
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
                                                                        controller.isMiniPlayerOpenQueueSongs.value ==
                                                                            false)
                                                                    ? const SizedBox()
                                                                    : (((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                                                                                (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData.isNotEmpty && (homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData![controller.currentListTileIndexCategoryData.value].title!) == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                // (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                // (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                // (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!)) ||
                                                                                (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (homeScreenController.homeCategoryData[categoryIndex].categoryData![index].title!) && playlistScreenController.allSongsListModel != null)) &&
                                                                            controller.musicPlay.value == true)
                                                                        ? ColorFiltered(
                                                                            // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                                                                            colorFilter:
                                                                                const ColorFilter.mode(
                                                                              Colors.grey,
                                                                              BlendMode.modulate,
                                                                            ),
                                                                            child:
                                                                                Transform.scale(
                                                                              scale: 2.2,
                                                                              child: SiriWaveform.ios9(
                                                                                controller: controller.siriWaveController,
                                                                                options: const IOS9SiriWaveformOptions(
                                                                                  height: 110,
                                                                                  width: 35,
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
                                                      SizedBox(
                                                        height: h * 0.01,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.28,
                                                        child: lable(
                                                          text: (homeScreenController
                                                                  .homeCategoryModel!
                                                                  .data![
                                                                      categoryIndex]
                                                                  .categoryData![
                                                                      index]
                                                                  .title)!
                                                              .capitalizeFirstLetter(),
                                                          fontSize: 10,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        sizeBoxWidth(15),
                                        commonViewAll(
                                          onTap: () {
                                            GlobVar.currentCategoryIndex =
                                                categoryIndex;
                                            // controller
                                            //     .currentListTileIndexCategory
                                            //     .value = categoryIndex;

                                            Get.to(
                                              SeeAllSongScreen(
                                                homeCategoryData:
                                                    (homeScreenController
                                                        .homeCategoryModel!
                                                        .data![categoryIndex]),
                                              ),
                                            );
                                          },
                                          // onTapData: (homeScreenController
                                          //     .homeCategoryModel!
                                          //     .data![categoryIndex]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.035,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        // ///---------------------- category song1
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: lable(
                        //     text: AppStrings.newReleases,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.w500,
                        //     letterSpacing: 0.35,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: h * 0.005,
                        // ),
                        // isLoading
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     : SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         physics: const BouncingScrollPhysics(),
                        //         child: Row(
                        //           children: [
                        //             SizedBox(
                        //               height: h * 0.20,
                        //               child: ListView.builder(
                        //                 scrollDirection: Axis.horizontal,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 2),
                        //                 physics:
                        //                     const NeverScrollableScrollPhysics(),
                        //                 shrinkWrap: true,
                        //                 itemCount:
                        //                     categoryData1!.data!.length,
                        //                 itemBuilder: (context, index) {
                        //                   final localFilePath =
                        //                       '${AppStrings.localPathMusic}/${categoryData1!.data![index].id}.mp3';
                        //                   final file = File(localFilePath);
                        //                   controller
                        //                       .addCategory1AudioUrlToList(
                        //                           file.existsSync()
                        //                               ? localFilePath
                        //                               : (categoryData1!
                        //                                   .data![index]
                        //                                   .audio)!);
                        //                   controller.category1AudioUrl =
                        //                       controller.category1AudioUrl
                        //                           .toSet()
                        //                           .toList();
                        //                   log("${controller.category1AudioUrl}",
                        //                       name: 'cat 1 list');
                        //                   return GestureDetector(
                        //                     onTap: () async {
                        //                       homeScreenController
                        //                           .updateCategoryData(
                        //                               categoryData1!);

                        //                       setState(() {
                        //                         controller
                        //                             .isMiniPlayerOpenFavoriteSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenDownloadSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenQueueSongs
                        //                             .value = false;
                        //                         controller.isMiniPlayerOpen
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome1
                        //                             .value = true;
                        //                         controller
                        //                             .isMiniPlayerOpenHome2
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome3
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenAllSongs
                        //                             .value = false;
                        //                         controller
                        //                             .currentListTileIndexCategory1
                        //                             .value = index;
                        //                         log("${controller.isMiniPlayerOpenFavoriteSongs.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenFavoriteSongs");
                        //                         log("${controller.isMiniPlayerOpenQueueSongs.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenQueueSongs");
                        //                         log("${controller.isMiniPlayerOpenDownloadSongs.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenDownloadSongs");
                        //                         log("${controller.isMiniPlayerOpen.value}",
                        //                             name: "isMiniPlayerOpen");
                        //                         log("${controller.isMiniPlayerOpenHome1.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenHome1");
                        //                         log("${controller.isMiniPlayerOpenHome2.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenHome2");
                        //                         log("${controller.isMiniPlayerOpenHome3.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenHome3");
                        //                         log("${controller.isMiniPlayerOpenAllSongs.value}",
                        //                             name:
                        //                                 "isMiniPlayerOpenAllSongs");
                        //                         controller
                        //                             .updateCurrentListTileIndexCategory1(
                        //                                 index);
                        //                         controller.initAudioPlayer();
                        //                         log(
                        //                             controller
                        //                                 .currentListTileIndexCategory1
                        //                                 .value
                        //                                 .toString(),
                        //                             name:
                        //                                 'currentListTileIndexCategory1 home log');
                        //                       });

                        //                       final prefs =
                        //                           await SharedPreferences
                        //                               .getInstance();
                        //                       prefs.reload();

                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpen', false);
                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpenHome1',
                        //                           true);
                        //                       await prefs.setInt(
                        //                           'category1Index', index);
                        //                       homeScreenController
                        //                           .addRecentSongs(
                        //                               musicId: categoryData1!
                        //                                   .data![index].id!)
                        //                           .then((value) =>
                        //                               homeScreenController
                        //                                   .recentSongsList());
                        //                     },
                        //                     child: Padding(
                        //                       // padding: const EdgeInsets.symmetric(
                        //                       //     horizontal: 8),
                        //                       padding:
                        //                           const EdgeInsets.fromLTRB(
                        //                               0, 0, 13, 0),
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.start,
                        //                         children: [
                        //                           SizedBox(
                        //                             height: h * 0.02,
                        //                           ),
                        //                           Stack(
                        //                             children: [
                        //                               Obx(
                        //                                 () => ClipRRect(
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               3),
                        //                                   child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpen.value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome1
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenFavoriteSongs
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome2
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome3
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenAllSongs
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenQueueSongs
                        //                                                   .value ==
                        //                                               false)
                        //                                       ? CachedNetworkImage(
                        //                                           imageUrl: (categoryData1!
                        //                                               .data![
                        //                                                   index]
                        //                                               .image!),
                        //                                           placeholder:
                        //                                               (context,
                        //                                                   url) {
                        //                                             return const SizedBox();
                        //                                           },
                        //                                           height: 110,
                        //                                           width: 110,
                        //                                           filterQuality:
                        //                                               FilterQuality
                        //                                                   .high,
                        //                                         )
                        //                                       : ((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData1!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                        //                                               (controller.isMiniPlayerOpenHome1.value == true &&
                        //                                                   categoryData1 != null &&
                        //                                                   categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData1!.data![index].title!) && playlistScreenController.allSongsListModel != null))
                        //                                           ? Opacity(
                        //                                               opacity:
                        //                                                   0.4,
                        //                                               child:
                        //                                                   CachedNetworkImage(
                        //                                                 imageUrl: (categoryData1!
                        //                                                     .data![index]
                        //                                                     .image!),
                        //                                                 placeholder:
                        //                                                     (context, url) {
                        //                                                   return const SizedBox();
                        //                                                 },
                        //                                                 height:
                        //                                                     110,
                        //                                                 width:
                        //                                                     110,
                        //                                                 filterQuality:
                        //                                                     FilterQuality.high,
                        //                                               ),
                        //                                             )
                        //                                           : CachedNetworkImage(
                        //                                               imageUrl: (categoryData1!
                        //                                                   .data![index]
                        //                                                   .image!),
                        //                                               placeholder:
                        //                                                   (context,
                        //                                                       url) {
                        //                                                 return const SizedBox();
                        //                                               },
                        //                                               height:
                        //                                                   110,
                        //                                               width:
                        //                                                   110,
                        //                                               filterQuality:
                        //                                                   FilterQuality.high,
                        //                                             ),
                        //                                   // Image.network(
                        //                                   //   (categoryData1!.data![index]
                        //                                   //           .image) ??
                        //                                   //       'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                        //                                   //   height: 110,
                        //                                   //   width: 110,
                        //                                   //   filterQuality:
                        //                                   //       FilterQuality.high,
                        //                                   // ),
                        //                                 ),
                        //                               ),
                        //                               Obx(
                        //                                 () => Positioned.fill(
                        //                                   child: Center(
                        //                                     child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                             controller.isMiniPlayerOpen.value ==
                        //                                                 false &&
                        //                                             controller.isMiniPlayerOpenHome1.value ==
                        //                                                 false &&
                        //                                             controller.isMiniPlayerOpenHome2.value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome3
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenAllSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenFavoriteSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenQueueSongs
                        //                                                     .value ==
                        //                                                 false)
                        //                                         ? const SizedBox()
                        //                                         : (((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData1!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                        //                                                     (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData1!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData1!.data![index].title!) && playlistScreenController.allSongsListModel != null)) &&
                        //                                                 controller.musicPlay.value == true)
                        //                                             ? ColorFiltered(
                        //                                                 // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                        //                                                 colorFilter: const ColorFilter
                        //                                                     .mode(
                        //                                                     Colors.grey,
                        //                                                     BlendMode.modulate),
                        //                                                 child:
                        //                                                     //     AudioWave(
                        //                                                     //   height:
                        //                                                     //       22,
                        //                                                     //   width:
                        //                                                     //       22,
                        //                                                     //   spacing:
                        //                                                     //       3,
                        //                                                     //   bars: [
                        //                                                     //     AudioWaveBar(
                        //                                                     //         heightFactor: 0.7,
                        //                                                     //         color: Colors.blue.shade900),
                        //                                                     //     AudioWaveBar(
                        //                                                     //         heightFactor: 0.8,
                        //                                                     //         color: Colors.blue.shade900),
                        //                                                     //     AudioWaveBar(
                        //                                                     //         heightFactor: 1,
                        //                                                     //         color: Colors.blue.shade900),
                        //                                                     //     AudioWaveBar(
                        //                                                     //         heightFactor: 0.9,color: Colors.blue),
                        //                                                     //   ],
                        //                                                     // ),
                        //                                                     Transform.scale(
                        //                                                   scale:
                        //                                                       2.2,
                        //                                                   child:
                        //                                                       SiriWaveform.ios9(
                        //                                                     controller: controller.siriWaveController,
                        //                                                     options: const IOS9SiriWaveformOptions(
                        //                                                       height: 110,
                        //                                                       width: 35,
                        //                                                       showSupportBar: false,
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                               )
                        //                                             : const SizedBox(),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                           SizedBox(
                        //                             height: h * 0.01,
                        //                           ),
                        //                           SizedBox(
                        //                             width: w * 0.28,
                        //                             child: lable(
                        //                                 text: (categoryData1!
                        //                                         .data![index]
                        //                                         .title)!
                        //                                     .capitalizeFirstLetter(),
                        //                                 fontSize: 10),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //             sizeBoxWidth(15),
                        //             // commonViewAll(onTapData: categoryData1),
                        //           ],
                        //         ),
                        //       ),
                        // SizedBox(
                        //   height: h * 0.035,
                        // ),

                        // ///---------------------- category song2
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: lable(
                        //     text: categoryData2!.message ?? '',
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w600,
                        //     letterSpacing: 0.5,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: h * 0.005,
                        // ),
                        // isLoading
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     : SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         physics: const BouncingScrollPhysics(),
                        //         child: Row(
                        //           children: [
                        //             SizedBox(
                        //               height: h * 0.20,
                        //               // width: w * 0.4,
                        //               child: ListView.builder(
                        //                 scrollDirection: Axis.horizontal,
                        //                 physics:
                        //                     const NeverScrollableScrollPhysics(),
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 2),
                        //                 shrinkWrap: true,
                        //                 itemCount:
                        //                     categoryData2!.data!.length,
                        //                 itemBuilder: (context, index) {
                        //                   final localFilePath =
                        //                       '${AppStrings.localPathMusic}/${categoryData2!.data![index].id}.mp3';
                        //                   final file = File(localFilePath);
                        //                   controller
                        //                       .addCategory2AudioUrlToList(
                        //                           file.existsSync()
                        //                               ? localFilePath
                        //                               : (categoryData2!
                        //                                   .data![index]
                        //                                   .audio)!);
                        //                   controller.category2AudioUrl =
                        //                       controller.category2AudioUrl
                        //                           .toSet()
                        //                           .toList();
                        //                   return GestureDetector(
                        //                     onTap: () async {
                        //                       homeScreenController
                        //                           .updateCategoryData(
                        //                               categoryData2!);

                        //                       // controller.isMiniPlayerOpen.value == true
                        //                       //     ? (controller.audioPlayer).dispose()
                        //                       //     : null;
                        //                       setState(() {
                        //                         // (controller.audioPlayer).load();
                        //                         controller
                        //                             .isMiniPlayerOpenFavoriteSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenDownloadSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenQueueSongs
                        //                             .value = false;
                        //                         controller.isMiniPlayerOpen
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome1
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome2
                        //                             .value = true;
                        //                         controller
                        //                             .isMiniPlayerOpenHome3
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenAllSongs
                        //                             .value = false;
                        //                         controller
                        //                             .currentListTileIndexCategory2
                        //                             .value = index;
                        //                         controller
                        //                             .updateCurrentListTileIndexCategory2(
                        //                                 index);

                        //                         log(
                        //                             controller
                        //                                 .category2AudioUrl
                        //                                 .toString(),
                        //                             name:
                        //                                 'currentListTileIndexCategory2 home log');
                        //                       });
                        //                       controller.initAudioPlayer();
                        //                       final prefs =
                        //                           await SharedPreferences
                        //                               .getInstance();
                        //                       prefs.reload();

                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpen', false);
                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpenHome2',
                        //                           true);
                        //                       await prefs.setInt(
                        //                           'category2Index', index);
                        //                       homeScreenController
                        //                           .addRecentSongs(
                        //                               musicId: categoryData2!
                        //                                   .data![index].id!);
                        //                       homeScreenController
                        //                           .recentSongsList();

                        //                       // Get.to(
                        //                       //   DetailScreen(
                        //                       //     index: index,
                        //                       //     type: 'home',
                        //                       //   ),
                        //                       // );
                        //                     },
                        //                     child: Padding(
                        //                       padding:
                        //                           const EdgeInsets.fromLTRB(
                        //                               0, 0, 13, 0),
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.start,
                        //                         children: [
                        //                           SizedBox(
                        //                             height: h * 0.02,
                        //                           ),
                        //                           Stack(
                        //                             children: [
                        //                               Obx(
                        //                                 () => ClipRRect(
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               3),
                        //                                   child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpen.value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome1
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome2
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenHome3
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenAllSongs
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenFavoriteSongs
                        //                                                   .value ==
                        //                                               false &&
                        //                                           controller
                        //                                                   .isMiniPlayerOpenQueueSongs
                        //                                                   .value ==
                        //                                               false)
                        //                                       ? CachedNetworkImage(
                        //                                           imageUrl: (categoryData2!
                        //                                               .data![
                        //                                                   index]
                        //                                               .image!),
                        //                                           placeholder:
                        //                                               (context,
                        //                                                   url) {
                        //                                             return const SizedBox();
                        //                                           },
                        //                                           height: 110,
                        //                                           width: 110,
                        //                                           filterQuality:
                        //                                               FilterQuality
                        //                                                   .high,
                        //                                         )
                        //                                       : (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData2!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                        //                                               (controller.isMiniPlayerOpenHome1.value == true &&
                        //                                                   categoryData1 != null &&
                        //                                                   categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                               (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData2!.data![index].title!) && playlistScreenController.allSongsListModel != null)
                        //                                           ? Opacity(
                        //                                               opacity:
                        //                                                   0.4,
                        //                                               child:
                        //                                                   CachedNetworkImage(
                        //                                                 imageUrl: (categoryData2!
                        //                                                     .data![index]
                        //                                                     .image!),
                        //                                                 placeholder:
                        //                                                     (context, url) {
                        //                                                   return const SizedBox();
                        //                                                 },
                        //                                                 height:
                        //                                                     110,
                        //                                                 width:
                        //                                                     110,
                        //                                                 filterQuality:
                        //                                                     FilterQuality.high,
                        //                                               ),
                        //                                             )
                        //                                           : CachedNetworkImage(
                        //                                               imageUrl: (categoryData2!
                        //                                                   .data![index]
                        //                                                   .image!),
                        //                                               placeholder:
                        //                                                   (context,
                        //                                                       url) {
                        //                                                 return const SizedBox();
                        //                                               },
                        //                                               height:
                        //                                                   110,
                        //                                               width:
                        //                                                   110,
                        //                                               filterQuality:
                        //                                                   FilterQuality.high,
                        //                                             ),
                        //                                 ),
                        //                               ),
                        //                               Obx(
                        //                                 () => Positioned.fill(
                        //                                   child: Center(
                        //                                     child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                             controller.isMiniPlayerOpen.value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome1
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome2
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome3
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenAllSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenFavoriteSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenQueueSongs
                        //                                                     .value ==
                        //                                                 false)
                        //                                         ? const SizedBox()
                        //                                         : (((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData2!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                        //                                                     (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData2!.data![index].title!) && playlistScreenController.allSongsListModel != null)) &&
                        //                                                 controller.musicPlay.value == true)
                        //                                             ? ColorFiltered(
                        //                                                 // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),
                        //                                                 colorFilter: ColorFilter.mode(
                        //                                                     Colors.grey.shade500,
                        //                                                     BlendMode.modulate),
                        //                                                 child:
                        //                                                     Transform.scale(
                        //                                                   scale:
                        //                                                       2.2,
                        //                                                   child:
                        //                                                       SiriWaveform.ios9(
                        //                                                     controller: controller.siriWaveController,
                        //                                                     options: const IOS9SiriWaveformOptions(
                        //                                                       height: 110,
                        //                                                       width: 35,
                        //                                                       showSupportBar: false,
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                               )
                        //                                             : const SizedBox(),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                           SizedBox(
                        //                             height: h * 0.01,
                        //                           ),
                        //                           SizedBox(
                        //                             width: w * 0.28,
                        //                             child: Align(
                        //                               alignment:
                        //                                   Alignment.center,
                        //                               child: Center(
                        //                                 child: lable(
                        //                                     text: (categoryData2!
                        //                                             .data![
                        //                                                 index]
                        //                                             .title)!
                        //                                         .capitalizeFirstLetter(),
                        //                                     fontSize: 10),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //             sizeBoxWidth(15),
                        //             // commonViewAll(onTapData: categoryData2),
                        //           ],
                        //         ),
                        //       ),
                        // SizedBox(
                        //   height: h * 0.035,
                        // ),

                        // ///---------------------- category song3
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: lable(
                        //     text: categoryData3!.message ?? '',
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w600,
                        //     letterSpacing: 0.5,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: h * 0.005,
                        // ),
                        // isLoading
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     : SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         physics: const BouncingScrollPhysics(),
                        //         child: Row(
                        //           children: [
                        //             SizedBox(
                        //               height: h * 0.20,
                        //               child: ListView.builder(
                        //                 scrollDirection: Axis.horizontal,
                        //                 physics:
                        //                     const NeverScrollableScrollPhysics(),
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 2),
                        //                 shrinkWrap: true,
                        //                 itemCount:
                        //                     categoryData3!.data!.length,
                        //                 itemBuilder: (context, index) {
                        //                   final localFilePath =
                        //                       '${AppStrings.localPathMusic}/${categoryData3!.data![index].id}.mp3';
                        //                   final file = File(localFilePath);
                        //                   controller
                        //                       .addCategory3AudioUrlToList(
                        //                           file.existsSync()
                        //                               ? localFilePath
                        //                               : (categoryData3!
                        //                                   .data![index]
                        //                                   .audio)!);
                        //                   controller.category3AudioUrl =
                        //                       controller.category3AudioUrl
                        //                           .toSet()
                        //                           .toList();
                        //                   return GestureDetector(
                        //                     onTap: () async {
                        //                       homeScreenController
                        //                           .updateCategoryData(
                        //                               categoryData3!);

                        //                       // controller.isMiniPlayerOpen.value == true
                        //                       //     ? (controller.audioPlayer)!.dispose()
                        //                       //     : null;

                        //                       setState(() {
                        //                         // (controller.audioPlayer)!.load();
                        //                         controller
                        //                             .isMiniPlayerOpenDownloadSongs
                        //                             .value = false;
                        //                         controller.isMiniPlayerOpen
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenQueueSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenQueueSongs
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome1
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome2
                        //                             .value = false;
                        //                         controller
                        //                             .isMiniPlayerOpenHome3
                        //                             .value = true;
                        //                         controller
                        //                             .isMiniPlayerOpenAllSongs
                        //                             .value = false;
                        //                         controller
                        //                             .currentListTileIndexCategory3
                        //                             .value = index;
                        //                         controller
                        //                             .updateCurrentListTileIndexCategory3(
                        //                                 index);
                        //                         controller.initAudioPlayer();
                        //                         log(
                        //                             controller
                        //                                 .currentListTileIndexCategory3
                        //                                 .value
                        //                                 .toString(),
                        //                             name:
                        //                                 'currentListTileIndexCategory3 home log');
                        //                       });
                        //                       final prefs =
                        //                           await SharedPreferences
                        //                               .getInstance();
                        //                       prefs.reload();

                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpen', false);
                        //                       await prefs.setBool(
                        //                           'isMiniPlayerOpenHome3',
                        //                           true);
                        //                       await prefs.setInt(
                        //                           'category3Index', index);
                        //                       homeScreenController
                        //                           .addRecentSongs(
                        //                               musicId: categoryData3!
                        //                                   .data![index].id!);
                        //                       homeScreenController
                        //                           .recentSongsList();

                        //                       // Get.to(
                        //                       //   DetailScreen(
                        //                       //     index: index,
                        //                       //     type: 'home',
                        //                       //   ),
                        //                       // );
                        //                     },
                        //                     child: Padding(
                        //                       padding:
                        //                           const EdgeInsets.fromLTRB(
                        //                               0, 0, 13, 0),
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.start,
                        //                         children: [
                        //                           SizedBox(
                        //                             height: h * 0.02,
                        //                           ),
                        //                           Stack(
                        //                             children: [
                        //                               Obx(
                        //                                 () => ClipRRect(
                        //                                     borderRadius:
                        //                                         BorderRadius.circular(
                        //                                             3),
                        //                                     child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                             controller.isMiniPlayerOpen.value ==
                        //                                                 false &&
                        //                                             controller.isMiniPlayerOpenHome1.value == false &&
                        //                                             controller.isMiniPlayerOpenHome2.value == false &&
                        //                                             controller.isMiniPlayerOpenHome3.value == false &&
                        //                                             controller.isMiniPlayerOpenAllSongs.value == false &&
                        //                                             controller.isMiniPlayerOpenFavoriteSongs.value == false &&
                        //                                             controller.isMiniPlayerOpenQueueSongs.value == false)
                        //                                         ? CachedNetworkImage(
                        //                                             imageUrl: (categoryData3!
                        //                                                 .data![
                        //                                                     index]
                        //                                                 .image!),
                        //                                             placeholder:
                        //                                                 (context,
                        //                                                     url) {
                        //                                               return const SizedBox();
                        //                                             },
                        //                                             height:
                        //                                                 110,
                        //                                             width:
                        //                                                 110,
                        //                                             filterQuality:
                        //                                                 FilterQuality
                        //                                                     .high,
                        //                                           )
                        //                                         : (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData3!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) || (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData2!.data![index].title!)) || (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData3!.data![index].title!)) || (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData3!.data![index].title!) && playlistScreenController.allSongsListModel != null)
                        //                                             ?
                        //                                             // Stack(
                        //                                             //     children: [
                        //                                             Opacity(
                        //                                                 opacity:
                        //                                                     0.4,
                        //                                                 child:
                        //                                                     CachedNetworkImage(
                        //                                                   imageUrl:
                        //                                                       (categoryData3!.data![index].image!),
                        //                                                   placeholder:
                        //                                                       (context, url) {
                        //                                                     return const SizedBox();
                        //                                                   },
                        //                                                   height:
                        //                                                       110,
                        //                                                   width:
                        //                                                       110,
                        //                                                   filterQuality:
                        //                                                       FilterQuality.high,
                        //                                                 ),
                        //                                               )
                        //                                             //     BackdropFilter(
                        //                                             //       filter: ImageFilter.blur(
                        //                                             //         sigmaX: 0.7,
                        //                                             //         sigmaY: 0.7,
                        //                                             //       ),
                        //                                             //       blendMode: BlendMode.srcOver,
                        //                                             //       child: const SizedBox(
                        //                                             //         height: 110,
                        //                                             //         width: 110,
                        //                                             //       ),
                        //                                             //     )
                        //                                             //   ],
                        //                                             // )
                        //                                             : CachedNetworkImage(
                        //                                                 imageUrl: (categoryData3!
                        //                                                     .data![index]
                        //                                                     .image!),
                        //                                                 placeholder:
                        //                                                     (context, url) {
                        //                                                   return const SizedBox();
                        //                                                 },
                        //                                                 height:
                        //                                                     110,
                        //                                                 width:
                        //                                                     110,
                        //                                                 filterQuality:
                        //                                                     FilterQuality.high,
                        //                                               )),
                        //                               ),
                        //                               Obx(
                        //                                 () => Positioned.fill(
                        //                                   child: Center(
                        //                                     child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpen
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome1
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome2
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenHome3
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenAllSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenFavoriteSongs
                        //                                                     .value ==
                        //                                                 false &&
                        //                                             controller
                        //                                                     .isMiniPlayerOpenQueueSongs
                        //                                                     .value ==
                        //                                                 false)
                        //                                         ? const SizedBox()
                        //                                         : (((controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongAudios[controller.currentListTileIndexAllSongs.value] == (categoryData3!.data![index].audio!) && allSongsScreenController.allSongsListModel != null) ||
                        //                                                     (controller.isMiniPlayerOpenHome1.value == true && categoryData1 != null && categoryData1!.data![controller.currentListTileIndexCategory1.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel != null && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == (categoryData2!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel!.data!.isNotEmpty && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == (categoryData3!.data![index].title!)) ||
                        //                                                     (controller.isMiniPlayerOpen.value == true && GlobVar.playlistId != '' && playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title == (categoryData3!.data![index].title!) && playlistScreenController.allSongsListModel != null)) &&
                        //                                                 controller.musicPlay.value == true)
                        //                                             ? ColorFiltered(
                        //                                                 // filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 9.0),

                        //                                                 colorFilter:
                        //                                                     const ColorFilter.mode(
                        //                                                   Colors.grey,
                        //                                                   BlendMode.modulate,
                        //                                                 ),
                        //                                                 child:
                        //                                                     Transform.scale(
                        //                                                   scale:
                        //                                                       2.2,
                        //                                                   child:
                        //                                                       SiriWaveform.ios9(
                        //                                                     controller: controller.siriWaveController,
                        //                                                     options: const IOS9SiriWaveformOptions(
                        //                                                       height: 110,
                        //                                                       width: 35,
                        //                                                       showSupportBar: false,
                        //                                                     ),
                        //                                                   ),
                        //                                                 ),
                        //                                               )
                        //                                             : const SizedBox(),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                           SizedBox(
                        //                             height: h * 0.01,
                        //                           ),
                        //                           SizedBox(
                        //                             width: w * 0.28,
                        //                             child: Align(
                        //                               alignment:
                        //                                   Alignment.center,
                        //                               child: Center(
                        //                                 child: lable(
                        //                                     text: (categoryData3!
                        //                                             .data![
                        //                                                 index]
                        //                                             .title)!
                        //                                         .capitalizeFirstLetter(),
                        //                                     fontSize: 10),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //             sizeBoxWidth(15),
                        //             // commonViewAll(onTapData: categoryData3),
                        //           ],
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// 2 nd way

// import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:edpal_music_app_ui/utils/assets.dart';
// import 'package:edpal_music_app_ui/utils/common_widgets.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatefulWidget {
//   // HomeScreen() {
//   //   // Call fetchData for each category when the HomeScreen is created
//   //   for (var index = 0; index < 1; index++) {
//   //     homeScreenController.fetchData(index);
//   //   }
//   // }

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//  HomeScreenController? homeScreenController;
//   @override
//   void initState() {
//    homeScreenController =
//         Get.put(HomeScreenController());

//     for (var index = 0; index < 1; index++) {
//       homeScreenController!.fetchData(index);
//     }
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         leading: const Icon(
//           Icons.menu,
//           color: AppColors.white,
//         ),
//         title: Image.asset(AppAsstes.appIconOrange, scale: 8),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: Column(
//             children: [
//               SizedBox(height: h * 0.01),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.asset(AppAsstes.banner),
//               ),
//               SizedBox(height: h * 0.035),
//               for (var index = 0; index < 1; index++)
//                 buildCategorySection(
//                   categoryData: homeScreenController!.categoryDataList[index],
//                   categoryName: homeScreenController!.categoryNames[index],
//                   h: h,
//                   controller: homeScreenController!,
//                   index: index,
//                   context: context,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCategorySection({
//     CategoryData? categoryData,
//     required String categoryName,
//     double? h,
//     required HomeScreenController controller,
//     required int index,
//     required BuildContext context,
//   }) {
//     var h = MediaQuery.of(context).size.height;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             lable(
//               text: categoryData?.message ?? categoryName,
//             ),
//             lable(text: AppStrings.seeAll),
//           ],
//         ),
//         SizedBox(height: h * 0.02),
//         Obx(
//           () {
//             if (controller.isLoading.value) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (controller.categoryDataList == null) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return SizedBox(
//                 height: h * 0.25,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: categoryData!.data!.length,
//                   itemBuilder: (context, itemIndex) {
//                     final item = categoryData.data![itemIndex];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 3),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.network(
//                               item.image ?? '',
//                               height: 120,
//                               width: 120,
//                             ),
//                           ),
//                           SizedBox(height: h * 0.01),
//                           SizedBox(
//                             width: 120,
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Center(
//                                 child: lable(
//                                   text: item.title ?? '',
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
