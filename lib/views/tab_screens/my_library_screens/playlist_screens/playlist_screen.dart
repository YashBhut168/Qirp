import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/looking_for_songs_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/playlist_songs_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlylistScreen extends StatefulWidget {
  const PlylistScreen({super.key});

  @override
  State<PlylistScreen> createState() => _PlylistScreenState();
}

class _PlylistScreenState extends State<PlylistScreen> {
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
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

  TextEditingController searchController = TextEditingController();
  TextEditingController playlistNameController = TextEditingController();
  GlobalKey<FormState> myKey7 = GlobalKey<FormState>();

  // List<String> playlistTitles = [];
  // List<String> filteredPlaylistTitles = [];

  @override
  void initState() {
    super.initState();
    detailScreenController.fetchMyPlaylistData();
    // fetchMyPlaylistData();
    fetchData();
    playlistScreenController.songsInPlaylist(playlistId: GlobVar.playlistId);

    // sharedPref();
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   playlistScreenController.isPlaylistSongsEmpty.value == true ? controller.isMiniPlayerOpen.value = false : controller.isMiniPlayerOpen.value = true;
    // });
    setState(() {
      (controller.isMiniPlayerOpenDownloadSongs.value == true ||
                  controller.isMiniPlayerOpen.value == true ||
                  controller.isMiniPlayerOpenHome.value == true ||
                  controller.isMiniPlayerOpenHome1.value == true ||
                  controller.isMiniPlayerOpenHome2.value == true ||
                  controller.isMiniPlayerOpenHome3.value == true ||
                  controller.isMiniPlayerOpenAllSongs.value == true ||
                  controller.isMiniPlayerOpenQueueSongs.value == true ||
                  controller.isMiniPlayerOpenFavoriteSongs.value == true) &&
              controller.musicPlay.value == true
          ? controller.audioPlayer.play()
          : null;
      controller.currentListTileIndexQueueSongs.value;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndex.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexCategory.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
      controller.currentListTileIndexFavoriteSongs.value;
    });
    log(controller.isMiniPlayerOpen.value.toString(),
        name: 'playlistScreen::: isMiniPlayerOpen');
    log(controller.isMiniPlayerOpenHome.value.toString(),
        name: 'playlistScreen::: isMiniPlayerOpenHome');
    log(controller.isMiniPlayerOpenHome1.value.toString(),
        name: 'playlistScreen::: isMiniPlayerOpenHome1');
    log(controller.isMiniPlayerOpenHome2.value.toString(),
        name: 'playlistScreen::: isMiniPlayerOpenHome2');
    log(controller.isMiniPlayerOpenHome3.value.toString(),
        name: 'playlistScreen::: isMiniPlayerOpenHome3');
    log(controller.isMiniPlayerOpenAllSongs.value.toString(),
        name: 'queue::: isMiniPlayerOpenAllSongs');
    log(controller.currentListTileIndexCategory1.value.toString(),
        name: 'playlistScreen::: currentListTileIndexCategory1');
    log(controller.currentListTileIndexAllSongs.value.toString(),
        name: 'playlistScreen::: currentListTileIndexAllSongs');
    log(controller.currentListTileIndexDownloadSongs.value.toString(),
        name: 'playlistScreen::: currentListTileIndexDownloadSongs');
    log(controller.currentListTileIndexQueueSongs.value.toString(),
        name: 'playlistScreen::: currentListTileIndexQueueSongs');
    log(controller.currentListTileIndexFavoriteSongs.value.toString(),
        name: 'playlistScreen::: currentListTileIndexFavoriteSongs');

    log("${controller.queueSongsUrl}", name: "queueSongsUrl");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}");
    // allSongsScreenController.allSongsList();
    downloadSongScreenController.downloadSongsList();
    queueSongsScreenController.queueSongsListWithoutPlaylist();
    favoriteSongScreenController.favoriteSongsList();
  }

  final apiHelper = ApiHelper();

  bool isLoading = false;
  // MyPlaylistDataModel? myPlaylistDataModel;

  // Future<void> fetchMyPlaylistData() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

  //     myPlaylistDataModel =
  //         MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);

  //     playlistTitles =
  //         myPlaylistDataModel!.data!.map((item) => item.plTitle!).toList();

  //     filteredPlaylistTitles = playlistTitles;

  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //       isLoading = false;
  //     }
  //   }
  // }

  void filterPlaylistTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        detailScreenController.filteredPlaylistTitles =
            detailScreenController.playlistTitles;
        detailScreenController.filteredPlaylistTracks =
            detailScreenController.playlistTracks;
        detailScreenController.filteredPlaylistIds =
            detailScreenController.playlistIds;
        detailScreenController.filteredPlaylisImages =
            detailScreenController.playlistImages;
      } else {
        detailScreenController.filteredPlaylistTitles = detailScreenController
            .playlistTitles
            .where((title) => title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        detailScreenController.filteredPlaylistTracks = detailScreenController
            .playlistTracks
            .asMap()
            .entries
            .where((entry) => detailScreenController.filteredPlaylistTitles
                .contains(detailScreenController.playlistTitles[entry.key]))
            .map((entry) => entry.value)
            .toList();
        detailScreenController.filteredPlaylistIds = detailScreenController
            .playlistIds
            .asMap()
            .entries
            .where((entry) => detailScreenController.filteredPlaylistTitles
                .contains(detailScreenController.playlistTitles[entry.key]))
            .map((entry) => entry.value)
            .toList();
        detailScreenController.filteredPlaylisImages = detailScreenController
            .playlistImages
            .asMap()
            .entries
            .where((entry) => detailScreenController.filteredPlaylistTitles
                .contains(detailScreenController.playlistTitles[entry.key]))
            .map((entry) => entry.value)
            .toList();
      }
    });
  }

  // sharedPref() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen')!;
  //   log("$isMiniPlayerOpen");
  //   int currentListTileIndex = prefs.getInt('currentListTileIndex') ?? 0;
  //   log("$currentListTileIndex");
  //   controller.toggleMiniPlayer(isMiniPlayerOpen);
  //   controller.updateCurrentListTileIndex(currentListTileIndex);
  // }

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

  // @override
  // void dispose() {
  // controller.isMiniPlayerOpenQueueSongs.value == true ||
  //         controller.isMiniPlayerOpenDownloadSongs.value == true ||
  //         controller.isMiniPlayerOpen.value == true ||
  //         controller.isMiniPlayerOpenHome1.value == true ||
  //         controller.isMiniPlayerOpenHome2.value == true ||
  //         controller.isMiniPlayerOpenHome3.value == true ||
  //         controller.isMiniPlayerOpenAllSongs.value == true ||
  //         controller.isMiniPlayerOpenQueueSongs.value == true
  //     ? controller.audioPlayer.play()
  //     : null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          //   controller.isMiniPlayerOpenQueueSongs.value == true ||
          //           controller.isMiniPlayerOpenDownloadSongs.value == true ||
          //           controller.isMiniPlayerOpen.value == true ||
          //           controller.isMiniPlayerOpenHome1.value == true ||
          //           controller.isMiniPlayerOpenHome2.value == true ||
          //           controller.isMiniPlayerOpenHome3.value == true ||
          //           controller.isMiniPlayerOpenAllSongs.value == true
          //       ? controller.initAudioPlayer()
          //       : null;
          //   miniplayer();
          // Get.off(MainScreen(),opaque: true);
          Get.back();
          // Get.to(MainScreen(),);
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: lable(
              text: AppStrings.playlists,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            automaticallyImplyLeading: false,
          ),
          body: Obx(
            () => playlistScreenController.isLoading.value == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColors.white,
                  ))
                // ignore: unnecessary_null_comparison
                : detailScreenController.myPlaylistDataModel.value == null
                    ? Center(
                        child: lable(text: 'Load playlist...'),
                      )
                    : Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: commonTextField(
                                    borderRadius: 35,
                                    backgroundColor: const Color(0xFF383838),
                                    cursorColor: Colors.grey,
                                    prefix: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 13, right: 10),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                    focusBorderColor: Colors.grey,
                                    borderColor: Colors.transparent,
                                    hintText: AppStrings.search,
                                    textColor: Colors.grey,
                                    lableColor: Colors.grey,
                                    controller: searchController,
                                    onChanged: (query) {
                                      filterPlaylistTitles(query);

                                      // setState(() {
                                      //   allSongsScreenController.filterAllSonglistTitles(query);
                                      // });
                                    },
                                  ),
                                  //  commonTextField(
                                  //   borderRadius: 15,
                                  //   backgroundColor: Colors.white,
                                  //   cursorColor: Colors.grey,
                                  //   prefix: const Padding(
                                  //     padding:
                                  //         EdgeInsets.only(left: 10, right: 10),
                                  //     child: Icon(
                                  //       Icons.search,
                                  //       color: Colors.grey,
                                  //       size: 15,
                                  //     ),
                                  //   ),
                                  //   borderColor: Colors.transparent,
                                  //   hintText: AppStrings.search,
                                  //   textColor: Colors.grey,
                                  //   lableColor: Colors.grey,
                                  //   controller: searchController,
                                  //   onChanged: (query) {
                                  //     filterPlaylistTitles(query);
                                  //   },
                                  // ),
                                ),
                                sizeBoxHeight(18),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: GestureDetector(
                                    onTap: () {
                                      bottomSheetForAddPlaylist();
                                      // createPlaylist();
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        ),
                                        sizeBoxWidth(16),
                                        lable(
                                          text: AppStrings.createPlaylist,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                sizeBoxHeight(10),
                                detailScreenController
                                        .myPlaylistDataModel.value.data!.isEmpty
                                    ? SizedBox(
                                        height: Get.height / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: Lottie.asset(
                                                AppAsstes.animation
                                                    .downloadPlaylistAnimation,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            lable(
                                                text:
                                                    "You don't have create playlist."),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: detailScreenController
                                            .filteredPlaylistTitles.length,

                                        itemBuilder: ((context, index) {
                                          var playlistTitle =
                                              detailScreenController
                                                      .filteredPlaylistTitles[
                                                  index];
                                          var myPlaylistData =
                                              detailScreenController
                                                  .myPlaylistDataModel
                                                  .value
                                                  .data![index];
                                          print("filterImage ---> ${detailScreenController.filteredPlaylisImages}");
                                          print("filteredPlaylistTitles ---> ${detailScreenController.filteredPlaylistTitles}");
                                          //  print(playlistTitles);
                                          return ListTile(
                                            visualDensity: const VisualDensity(
                                              horizontal: 0,
                                              // vertical: -3.610,
                                              vertical: -2.010,
                                            ),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              child: detailScreenController.filteredPlaylisImages[index]
                                                      .isEmpty
                                                  ? Container(
                                                      // height: 50,
                                                      // width: 50,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13),
                                                      color: Colors.grey,
                                                      child: Icon(
                                                        Icons.music_note,
                                                        color: AppColors.white,
                                                      ),
                                                    )
                                                  : detailScreenController.filteredPlaylisImages[index]
                                                              .length ==
                                                          4
                                                      ? SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child:
                                                              GridView.builder(
                                                            shrinkWrap: false,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                            ),
                                                            itemCount:
                                                                detailScreenController.filteredPlaylisImages[index]
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    imageIndex) {
                                                              return Image
                                                                  .network(
                                                                detailScreenController.filteredPlaylisImages[index][
                                                                    imageIndex],
                                                                // height: 15,
                                                                // width: 15,
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : detailScreenController.filteredPlaylisImages[index]
                                                                  .length ==
                                                              2
                                                          ? SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child: Row(
                                                                children: [
                                                                  Image.network(
                                                                    detailScreenController.filteredPlaylisImages[index][0],
                                                                    height: 50,
                                                                    width: 25,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  Image.network(
                                                                    detailScreenController.filteredPlaylisImages[index][1],
                                                                    height: 50,
                                                                    width: 25,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : detailScreenController.filteredPlaylisImages[index]
                                                                      .length ==
                                                                  3
                                                              ? SizedBox(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            detailScreenController.filteredPlaylisImages[index][0],
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                          Image
                                                                              .network(
                                                                            detailScreenController.filteredPlaylisImages[index][1],
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Image
                                                                          .network(
                                                                        detailScreenController.filteredPlaylisImages[index][2],
                                                                        height:
                                                                            22,
                                                                        width:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : detailScreenController.filteredPlaylisImages[index]
                                                                          .length ==
                                                                      1
                                                                  ? SizedBox(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      child: Image
                                                                          .network(
                                                                        detailScreenController.filteredPlaylisImages[index][0],
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                            ),
                                            // leading: ClipRRect(
                                            //   borderRadius:
                                            //       BorderRadius.circular(7),
                                            //   child: detailScreenController
                                            //           .myPlaylistDataModel
                                            //           .value
                                            //           .data![index]
                                            //           .plImage!
                                            //           .isEmpty
                                            //       ? Container(
                                            //           // height: 50,
                                            //           // width: 50,
                                            //           padding:
                                            //               const EdgeInsets.all(
                                            //                   13),
                                            //           color: Colors.grey,
                                            //           child: Icon(
                                            //             Icons.music_note,
                                            //             color: AppColors.white,
                                            //           ),
                                            //         )
                                            //       : detailScreenController
                                            //                   .myPlaylistDataModel
                                            //                   .value
                                            //                   .data![index]
                                            //                   .plImage!
                                            //                   .length ==
                                            //               4
                                            //           ? SizedBox(
                                            //               height: 50,
                                            //               width: 50,
                                            //               child:
                                            //                   GridView.builder(
                                            //                 shrinkWrap: false,
                                            //                 physics:
                                            //                     const NeverScrollableScrollPhysics(),
                                            //                 gridDelegate:
                                            //                     const SliverGridDelegateWithFixedCrossAxisCount(
                                            //                   crossAxisCount: 2,
                                            //                 ),
                                            //                 itemCount:
                                            //                     detailScreenController
                                            //                         .myPlaylistDataModel
                                            //                         .value
                                            //                         .data![
                                            //                             index]
                                            //                         .plImage!
                                            //                         .length,
                                            //                 itemBuilder:
                                            //                     (context,
                                            //                         imageIndex) {
                                            //                   return Image
                                            //                       .network(
                                            //                     detailScreenController
                                            //                             .myPlaylistDataModel
                                            //                             .value
                                            //                             .data![
                                            //                                 index]
                                            //                             .plImage![
                                            //                         imageIndex],
                                            //                     // height: 15,
                                            //                     // width: 15,
                                            //                   );
                                            //                 },
                                            //               ),
                                            //             )
                                            //           : detailScreenController
                                            //                       .myPlaylistDataModel
                                            //                       .value
                                            //                       .data![index]
                                            //                       .plImage!
                                            //                       .length ==
                                            //                   2
                                            //               ? SizedBox(
                                            //                   height: 50,
                                            //                   width: 50,
                                            //                   child: Row(
                                            //                     children: [
                                            //                       Image.network(
                                            //                         detailScreenController
                                            //                             .myPlaylistDataModel
                                            //                             .value
                                            //                             .data![
                                            //                                 index]
                                            //                             .plImage![0],
                                            //                         height: 50,
                                            //                         width: 25,
                                            //                         fit: BoxFit
                                            //                             .fill,
                                            //                       ),
                                            //                       Image.network(
                                            //                         detailScreenController
                                            //                             .myPlaylistDataModel
                                            //                             .value
                                            //                             .data![
                                            //                                 index]
                                            //                             .plImage![1],
                                            //                         height: 50,
                                            //                         width: 25,
                                            //                         fit: BoxFit
                                            //                             .fill,
                                            //                       )
                                            //                     ],
                                            //                   ),
                                            //                 )
                                            //               : detailScreenController
                                            //                           .myPlaylistDataModel
                                            //                           .value
                                            //                           .data![
                                            //                               index]
                                            //                           .plImage!
                                            //                           .length ==
                                            //                       3
                                            //                   ? SizedBox(
                                            //                       height: 50,
                                            //                       width: 50,
                                            //                       child: Column(
                                            //                         children: [
                                            //                           Row(
                                            //                             children: [
                                            //                               Image
                                            //                                   .network(
                                            //                                 detailScreenController.myPlaylistDataModel.value.data![index].plImage![0],
                                            //                                 height:
                                            //                                     25,
                                            //                                 width:
                                            //                                     25,
                                            //                                 fit:
                                            //                                     BoxFit.fill,
                                            //                               ),
                                            //                               Image
                                            //                                   .network(
                                            //                                 detailScreenController.myPlaylistDataModel.value.data![index].plImage![1],
                                            //                                 height:
                                            //                                     25,
                                            //                                 width:
                                            //                                     25,
                                            //                                 fit:
                                            //                                     BoxFit.fill,
                                            //                               )
                                            //                             ],
                                            //                           ),
                                            //                           Image
                                            //                               .network(
                                            //                             detailScreenController
                                            //                                 .myPlaylistDataModel
                                            //                                 .value
                                            //                                 .data![index]
                                            //                                 .plImage![2],
                                            //                             height:
                                            //                                 22,
                                            //                             width:
                                            //                                 50,
                                            //                             fit: BoxFit
                                            //                                 .cover,
                                            //                           ),
                                            //                         ],
                                            //                       ),
                                            //                     )
                                            //                   : detailScreenController
                                            //                               .myPlaylistDataModel
                                            //                               .value
                                            //                               .data![
                                            //                                   index]
                                            //                               .plImage!
                                            //                               .length ==
                                            //                           1
                                            //                       ? SizedBox(
                                            //                           height:
                                            //                               50,
                                            //                           width: 50,
                                            //                           child: Image
                                            //                               .network(
                                            //                             detailScreenController
                                            //                                 .myPlaylistDataModel
                                            //                                 .value
                                            //                                 .data![index]
                                            //                                 .plImage![0],
                                            //                             height:
                                            //                                 50,
                                            //                             width:
                                            //                                 50,
                                            //                             fit: BoxFit
                                            //                                 .fill,
                                            //                           ),
                                            //                         )
                                            //                       : const SizedBox(),
                                            // ),
                                            title: lable(
                                              text: playlistTitle,
                                              fontSize: 12,
                                            ),
                                            subtitle: lable(
                                              text:
                                                  "${(detailScreenController.filteredPlaylistTracks[index])}  songs",
                                              // "${detailScreenController.myPlaylistDataModel!.data![index].tracks}  songs",
                                              // "${(myPlaylistDataModel!.data![index].tracks)!} • ${AppStrings.tracks}",
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.more_vert_outlined,
                                              ),
                                              onPressed: () {
                                                bottomSheet(
                                                    context,
                                                    index,
                                                    playlistTitle,
                                                    myPlaylistData);
                                              },
                                            ),
                                            onTap: () {
                                              (detailScreenController
                                                              .filteredPlaylistTracks[
                                                          index]) ==
                                                      '0'
                                                  ? Get.to(
                                                      LookingForSongsScreen(
                                                        playlistTitle:
                                                            playlistTitle,
                                                        myPlaylistData:
                                                            myPlaylistData,
                                                      ),
                                                    )
                                                  : Get.to(
                                                      PlaylistSongsScreen(
                                                        playlistTitle:
                                                            playlistTitle,
                                                        myPlaylistData:
                                                            myPlaylistData,
                                                        myPlaylistId:
                                                            detailScreenController
                                                                    .filteredPlaylistIds[
                                                                index],
                                                        myPlaylistImage: detailScreenController.filteredPlaylisImages[index],
                                                      ),
                                                    );
                                              GlobVar.playlistId =
                                                  myPlaylistData.id!;
                                              searchController.text = '';

                                              log(GlobVar.playlistId,
                                                  name: "GlobVar.playlistId");
                                            },
                                          );
                                        }),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              isExtended: false,
              backgroundColor: AppColors.themeBlueColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              onPressed: () {
                bottomSheetForAddPlaylist();
              },
              // isExtended: true,
              child: Icon(
                Icons.add,
                color: AppColors.white,
              ),
            ),
          ),
          bottomNavigationBar: Obx(
            () => (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
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
                                playlistScreenController.allSongsListModel !=
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
                                                color:
                                                    AppColors.backgroundColor,
                                                child: miniplayer())
                                            : (controller.isMiniPlayerOpenAllSongs.value) ==
                                                        true &&
                                                    allSongsScreenController
                                                            .allSongsListModel!
                                                            .data !=
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
      ),
    );
  }

  Future<dynamic> bottomSheet(
      BuildContext context, int index, String playlistTitle, myPlaylistData) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SizedBox(
          height: (detailScreenController.filteredPlaylistTracks[index]) == '0'
              ? 280
              : 360,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Scaffold(
              backgroundColor: const Color(0xFF30343d),
              body: SingleChildScrollView(
                child: (detailScreenController.filteredPlaylistTracks[index]) ==
                        '0'
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 100,
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
                          sizeBoxHeight(30),
                          commonListTilePlaylist(
                            icon: Icons.close,
                            text: AppStrings.deletePlaylist,
                          ),
                          sizeBoxHeight(12),
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
                          sizeBoxHeight(5),
                        ],
                      )
                    : Column(
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
                          commonListTilePlaylist(
                            icon: Icons.play_arrow_outlined,
                            text: AppStrings.playNow,
                          ),
                          commonListTilePlaylist(
                            icon: Icons.close,
                            text: AppStrings.deletePlaylist,
                          ),
                          // commonListTilePlaylist(
                          //   icon: Icons.playlist_add_outlined,
                          //   text: AppStrings.addToQueue,
                          // ),
                          // commonListTilePlaylist(
                          //   icon: Icons.download,
                          //   text: AppStrings.download,
                          // ),
                          sizeBoxHeight(10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              (detailScreenController
                                          .filteredPlaylistTracks[index]) ==
                                      '0'
                                  ? Get.to(
                                      LookingForSongsScreen(
                                        playlistTitle: playlistTitle,
                                        myPlaylistData: myPlaylistData,
                                      ),
                                    )
                                  : Get.to(
                                      PlaylistSongsScreen(
                                        playlistTitle: playlistTitle,
                                        myPlaylistData: myPlaylistData,
                                        myPlaylistId: detailScreenController
                                            .filteredPlaylistIds[index],
                                      ),
                                    );
                            },
                            child: commonListTilePlaylist(
                              icon: Icons.music_note,
                              text: AppStrings.details,
                              trailing: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15,
                                color: Colors.grey,
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
                child: detailScreenController.filteredPlaylisImages[index].isEmpty
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: AppColors.white,
                          size: 60,
                        ),
                      )
                    : detailScreenController.filteredPlaylisImages[index].length == 4
                        ? SizedBox(
                            height: 150,
                            width: 150,
                            child: GridView.builder(
                              shrinkWrap: false,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: detailScreenController.filteredPlaylisImages[index].length,
                              itemBuilder: (context, imageIndex) {
                                return Image.network(
                                  detailScreenController.filteredPlaylisImages[index][imageIndex],
                                  // height: 15,
                                  // width: 15,
                                );
                              },
                            ),
                          )
                        : detailScreenController.filteredPlaylisImages[index].length == 2
                            ? SizedBox(
                                height: 150,
                                width: 150,
                                child: Row(
                                  children: [
                                    Image.network(
                                      detailScreenController.filteredPlaylisImages[index][0],
                                      height: 150,
                                      width: 75,
                                      fit: BoxFit.fill,
                                    ),
                                    Image.network(
                                      detailScreenController.filteredPlaylisImages[index][1],
                                      height: 150,
                                      width: 75,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              )
                            : detailScreenController.filteredPlaylisImages[index].length == 3
                                ? SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(
                                              detailScreenController.filteredPlaylisImages[index][0],
                                              height: 75,
                                              width: 75,
                                              fit: BoxFit.fill,
                                            ),
                                            Image.network(
                                              detailScreenController.filteredPlaylisImages[index][1],
                                              height: 75,
                                              width: 75,
                                              fit: BoxFit.fill,
                                            )
                                          ],
                                        ),
                                        Image.network(
                                          detailScreenController.filteredPlaylisImages[index][2],
                                          height: 75,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  )
                                : detailScreenController.filteredPlaylisImages[index].length == 1
                                    ? SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.network(
                                          detailScreenController.filteredPlaylisImages[index][0],
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : const SizedBox(),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerTop,
            ),
          ),
        );
      },
    );
  }

  createPlaylist() {
    return showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: AlertDialog(
                backgroundColor: const Color(0xFF30343d),
                title: Align(
                  alignment: Alignment.center,
                  child: lable(
                    text: AppStrings.nameYourPlaylist,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                content: Form(
                  key: myKey7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      commonTextField(
                        cursorColor: Colors.grey.shade600,
                        backgroundColor: Colors.grey.shade400,
                        borderColor: Colors.transparent,
                        hintText: AppStrings.myNewPlaylist,
                        textColor: Colors.grey.shade600,
                        validator: (value) =>
                            AppValidation.validateName(value!),
                        hintStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        controller: playlistNameController,
                      ),
                      sizeBoxHeight(4),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                            backgroundColor: const Color(0xFF2ac5b3),
                            textStyle: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                          onPressed: () {
                            if (myKey7.currentState!.validate()) {
                              snackBar(
                                  '${playlistNameController.text} ${AppStrings.added}');
                              detailScreenController
                                  .addPlaylist(
                                      playlistTitle:
                                          playlistNameController.text)
                                  .then((value) {
                                // fetchMyPlaylistData();
                                detailScreenController.fetchMyPlaylistData();
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pop();
                              });
                              // Get.to(DetailScreen(index: 0,));
                              playlistNameController.text = '';
                            } else {
                              snackBar(AppStrings.enterPlaylistName);
                            }
                          },
                          child: lable(
                            text: AppStrings.saveC,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: lable(
                          text: AppStrings.cancel,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
                  index: controller.isMiniPlayerOpenFavoriteSongs.value == true
                      ? controller.currentListTileIndexFavoriteSongs.value
                      : controller.isMiniPlayerOpenQueueSongs.value == true
                          ? controller.currentListTileIndexQueueSongs.value
                          : controller.isMiniPlayerOpenDownloadSongs.value ==
                                  true
                              ? controller
                                  .currentListTileIndexDownloadSongs.value
                              : controller.isMiniPlayerOpen.value == true
                                  ? controller.currentListTileIndex.value
                                  : controller.isMiniPlayerOpenHome.value ==
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
                          controller.isMiniPlayerOpenFavoriteSongs.value == true
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
                        homeScreenController.homeCategoryData.isNotEmpty &&
                                (controller.isMiniPlayerOpenHome.value) ==
                                    true &&
                                (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                    false &&
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
                                    false
                            ? homeScreenController
                                    .homeCategoryModel!
                                    .data![controller
                                        .currentListTileIndexCategory.value]
                                    .categoryData![controller
                                        .currentListTileIndexCategoryData.value]
                                    .image ??
                                'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : favoriteSongScreenController.allSongsListModel != null &&
                                    (controller.isMiniPlayerOpenFavoriteSongs.value) ==
                                        true &&
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
                                ? favoriteSongScreenController
                                        .allSongsListModel!
                                        .data![controller
                                            .currentListTileIndexFavoriteSongs
                                            .value]
                                        .image ??
                                    'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                : queueSongsScreenController.allSongsListModel != null &&
                                        (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                        (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                        (controller.isMiniPlayerOpen.value) == false &&
                                        (controller.isMiniPlayerOpenHome.value) == false &&
                                        (controller.isMiniPlayerOpenHome1.value) == false &&
                                        (controller.isMiniPlayerOpenHome2.value) == false &&
                                        (controller.isMiniPlayerOpenHome3.value) == false &&
                                        (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                        (controller.isMiniPlayerOpenQueueSongs.value) == true
                                    ? queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                    : downloadSongScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                        ? downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                        : playlistScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                            ? playlistScreenController.currentPlayingImage.isNotEmpty
                                                ? playlistScreenController.currentPlayingImage.value
                                                : playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                            : (controller.isMiniPlayerOpenHome1.value) == true && categoryData1 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                ? categoryData1!.data![controller.currentListTileIndexCategory1.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                : categoryData2 != null && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                    ? categoryData2!.data![controller.currentListTileIndexCategory2.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                    : categoryData3 != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                        ? categoryData3!.data![controller.currentListTileIndexCategory3.value].image ?? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                                        : allSongsScreenController.allSongsListModel != null && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                          text: homeScreenController.homeCategoryData.isNotEmpty &&
                                  (controller.isMiniPlayerOpenHome.value) ==
                                      true &&
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
                                  .homeCategoryData[controller
                                      .currentListTileIndexCategory.value]
                                  .categoryData![controller
                                      .currentListTileIndexCategoryData.value]
                                  .title)!
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == true &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
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
                                  ? (favoriteSongScreenController
                                      .allSongsListModel!
                                      .data![controller.currentListTileIndexFavoriteSongs.value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                      ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? playlistScreenController.currentPlayingTitle.isNotEmpty
                                                  ? playlistScreenController.currentPlayingTitle.value
                                                  : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].title)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].title)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].title)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].title)!
                                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
                                                              ? (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!
                                                              : (allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title)!,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: homeScreenController.homeCategoryData.isNotEmpty &&
                                  (controller.isMiniPlayerOpenHome.value) ==
                                      true &&
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
                              : (controller.isMiniPlayerOpenFavoriteSongs.value) ==
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
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (favoriteSongScreenController
                                      .allSongsListModel!
                                      .data![controller.currentListTileIndexFavoriteSongs.value]
                                      .description)!
                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == true && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                      ? (queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].description)!
                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == true && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                          ? (downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].description)!
                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == true && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                              ? playlistScreenController.currentPlayingDesc.isNotEmpty
                                                  ? playlistScreenController.currentPlayingDesc.value
                                                  : (playlistScreenController.allSongsListModel!.data![controller.currentListTileIndex.value].description)!
                                              : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == true && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                  ? (categoryData1!.data![controller.currentListTileIndexCategory1.value].description)!
                                                  : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == true && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                      ? (categoryData2!.data![controller.currentListTileIndexCategory2.value].description)!
                                                      : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == true && (controller.isMiniPlayerOpenAllSongs.value) == false
                                                          ? (categoryData3!.data![controller.currentListTileIndexCategory3.value].description)!
                                                          : (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == true
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
                    (controller.isMiniPlayerOpenFavoriteSongs.value) == true
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
                    (controller.isMiniPlayerOpenFavoriteSongs.value) == true
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
                    (controller.isMiniPlayerOpenFavoriteSongs.value) == true
                ? controller.audioPlayer.durationStream
                : controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  bottomSheetForAddPlaylist() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1c1c1e),
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: myKey7,
              child: Column(
                // scrollDirection: Axis.vertical,
                //  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  sizeBoxHeight(10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
                    color: const Color(0xFF0a0a0a),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: lable(text: 'Cancel')),
                        lable(text: 'Create New Playlist', fontSize: 16),
                        GestureDetector(
                            onTap: () {
                              if (myKey7.currentState!.validate()) {
                                snackBar(
                                    '${playlistNameController.text} ${AppStrings.added}');
                                detailScreenController
                                    .addPlaylist(
                                        playlistTitle:
                                            playlistNameController.text)
                                    .then((value) {
                                  // fetchMyPlaylistData();
                                  detailScreenController.fetchMyPlaylistData();
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pop();
                                });
                                // Get.to(DetailScreen(index: 0,));
                                playlistNameController.text = '';
                              } else {
                                snackBar(AppStrings.enterPlaylistName);
                              }
                            },
                            child: lable(text: 'Create')),
                      ],
                    ),
                  ),
                  sizeBoxHeight(15),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 140),
                  //   child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      // width: 50,
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey,
                      child: Icon(
                        Icons.music_note,
                        size: 50,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  // ),
                  sizeBoxHeight(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: lable(text: 'Playlist title'),
                    ),
                  ),
                  sizeBoxHeight(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: commonTextField(
                      cursorColor: Colors.grey.shade600,
                      backgroundColor: const Color(0xFF1c1c1e),
                      borderColor: const Color(0xFF232325),
                      lableColor: Colors.grey,
                      hintText: 'Enter your playlist name',
                      // textColor: Colors.grey,
                      validator: (value) => AppValidation.validateName(value!),
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      // textAlign: TextAlign.center,
                      controller: playlistNameController,
                    ),
                  ),
                  sizeBoxHeight(310),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
