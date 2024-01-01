import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
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
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/add_songs_screen.dart';
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
import 'package:siri_wave/siri_wave.dart';

// ignore: unused_import
import '../../../../models/my_playlist_data_model.dart';

// ignore: must_be_immutable
class PlaylistSongsScreen extends StatefulWidget {
  final String playlistTitle;
  // final Data myPlaylistData;
  // ignore: prefer_typing_uninitialized_variables
  final myPlaylistData;
  final String myPlaylistId;
  // ignore: prefer_typing_uninitialized_variables
  var myPlaylistImage;
  String? screen;

  PlaylistSongsScreen({
    super.key,
    required this.playlistTitle,
    required this.myPlaylistData,
    required this.myPlaylistId,
    this.myPlaylistImage,
    this.screen,
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
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());
  FavoriteSongScreenController favoriteSongScreenController =
      Get.put(FavoriteSongScreenController());
  AlbumScreenController albumScreenController =
      Get.put(AlbumScreenController());
  ArtistScreenController artistScreenController =
      Get.put(ArtistScreenController());
  SearchScreenController searchScreenController =
      Get.put(SearchScreenController());

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playlistScreenController.songsInPlaylist(
        playlistId: (widget.myPlaylistId),
      );
      log(widget.screen == 'home' ? widget.myPlaylistData.playlistId : widget.myPlaylistData.id, name: 'widget.myPlaylistData.id');
    });

    fetchData();
    // sharedPref();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playlistScreenController.queueSongsList(
          playlistId: ((widget.screen == 'home' ? widget.myPlaylistData.playlistId :  widget.myPlaylistData.id)!),);
    });

    downloadSongScreenController.downloadSongsList();
    queueSongsScreenController.queueSongsListWithoutPlaylist();
    favoriteSongScreenController.favoriteSongsList();
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
    final MainScreenController controller = Get.find();
    controller.playlisSongAudioUrl = [];
    // controller.setAudioPlayer(audioPlayer);
    log(playlistScreenController.currentPlayingTitle.value,
        name: 'currenplayigtitle:::');
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
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              detailScreenController.fetchMyPlaylistData();
                              Get.back();
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
                                  context,
                                  widget.playlistTitle,
                                  widget.myPlaylistData,
                                  widget.myPlaylistImage);
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
                      child:
                      widget.screen != 'home' ?
                       widget.myPlaylistImage.isEmpty
                          ? Container(
                              // padding: const EdgeInsets.all(60),
                              height: 150,
                              width: 150,
                              color: const Color(0xFF30343d),
                              child: Icon(
                                Icons.music_note,
                                color: AppColors.white,
                                size: 40,
                              ),
                            )
                          : widget.myPlaylistImage.length == 4
                              ? SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: GridView.builder(
                                    shrinkWrap: false,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    itemCount: widget.myPlaylistImage.length,
                                    itemBuilder: (context, imageIndex) {
                                      return Image.network(
                                        widget.myPlaylistImage[imageIndex],
                                        // height: 15,
                                        // width: 15,
                                      );
                                    },
                                  ),
                                )
                              : widget.myPlaylistImage.length == 2
                                  ? SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Image.network(
                                            widget.myPlaylistImage[0],
                                            height: 150,
                                            width: 75,
                                            fit: BoxFit.fill,
                                          ),
                                          Image.network(
                                            widget.myPlaylistImage[1],
                                            height: 150,
                                            width: 75,
                                            fit: BoxFit.fill,
                                          )
                                        ],
                                      ),
                                    )
                                  : widget.myPlaylistImage.length == 3
                                      ? SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.network(
                                                    widget.myPlaylistImage[0],
                                                    height: 75,
                                                    width: 75,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  Image.network(
                                                    widget.myPlaylistImage[1],
                                                    height: 75,
                                                    width: 75,
                                                    fit: BoxFit.fill,
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                widget.myPlaylistImage[2],
                                                height: 75,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        )
                                      : widget.myPlaylistImage.length == 1
                                          ? SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: Image.network(
                                                widget.myPlaylistImage[0],
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : const SizedBox() : SizedBox(
                                              height: 150,
                                              width: 150,
                                              child: Image.network(
                                                widget.myPlaylistImage,
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                    ),
                    sizeBoxHeight(70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                controller.audioPlayer.stop();
                                playlistScreenController
                                        .currentPlayingImage.value =
                                    playlistScreenController
                                        .isLikePlaylistData[0].image;
                                playlistScreenController
                                        .currentPlayingTitle.value =
                                    playlistScreenController
                                        .isLikePlaylistData[0].title;
                                playlistScreenController
                                        .currentPlayingDesc.value =
                                    playlistScreenController
                                        .isLikePlaylistData[0].description;
                                controller.isMiniPlayerOpenFavoriteSongs.value =
                                    false;
                                controller.isMiniPlayerOpenQueueSongs.value =
                                    false;
                                controller.isMiniPlayerOpenDownloadSongs.value =
                                    false;
                                controller.isMiniPlayerOpenArtistSongs.value ==
                                    false;
                                controller.isMiniPlayerOpenSearchSongs.value ==
                                    false;
                                controller.isMiniPlayerOpenAdminPlaylistSongs.value = false;
                                controller.isMiniPlayerOpenHome.value = false;
                                controller.isMiniPlayerOpenHome1.value = false;
                                controller.isMiniPlayerOpenHome2.value = false;
                                controller.isMiniPlayerOpenHome3.value = false;
                                controller.isMiniPlayerOpenAllSongs.value =
                                    false;
                                controller.isMiniPlayerOpen.value = true;
                                controller.isMiniPlayerOpenAlbumSongs.value =
                                    false;
                                for (var playlistSongAudioUrl
                                    in playlistScreenController
                                        .playlistSongAudioUrls) {
                                  controller.addPlaylistSongAudioUrlToList(
                                      playlistSongAudioUrl);
                                  log(playlistSongAudioUrl);
                                }

                                controller.playlisSongAudioUrl =
                                    playlistScreenController
                                        .playlistSongAudioUrls;
                                controller.currentListTileIndex.value = 0;
                                // playlistScreenController.isLoading.value == true
                                //     ? null
                                //     :
                                setState(() {
                                  // isMiniPlayerOpen = true;
                                  controller.initAudioPlayer();
                                  // controller.initAudioPlayer();
                                });
                                // final prefs =
                                //     await SharedPreferences.getInstance();
                                // await prefs.setBool('isMiniPlayerOpen', true);
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
                          ],
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
                              //      &&
                              // (categoryData1 == null ||
                              //     categoryData2 == null ||
                              //     categoryData3 == null) &&
                              // (allSongsScreenController.allSongsListModel ==
                              //     null) &&
                              // (downloadSongScreenController
                              //         .allSongsListModel ==
                              //     null) &&
                              // (queueSongsScreenController
                              //         .allSongsListModel ==
                              //     null)
                              ? Center(
                                  child: lable(text: 'Loading...'),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: playlistScreenController
                                      .isLikePlaylistData.length,
                                  itemBuilder: (context, index) {
                                    if (playlistScreenController
                                        .allSongsListModel!.data!.isEmpty) {
                                      controller.audioPlayer.stop();
                                      controller.isMiniPlayerOpenFavoriteSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenAlbumSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenQueueSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenDownloadSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenSearchSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenAdminPlaylistSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenArtistSongs
                                          .value = false;
                                      controller.isMiniPlayerOpenHome.value =
                                          false;
                                      controller.isMiniPlayerOpenHome1.value =
                                          false;
                                      controller.isMiniPlayerOpenHome2.value =
                                          false;
                                      controller.isMiniPlayerOpenHome3.value =
                                          false;
                                      controller.isMiniPlayerOpenAllSongs
                                          .value = false;
                                      controller.isMiniPlayerOpen.value = false;
                                    }
                                    var playlistSongsData =
                                        playlistScreenController
                                            .allSongsListModel!.data![index];

                                    final localFilePath =
                                        '${AppStrings.localPathMusic}/${playlistSongsData.id}.mp3';
                                    final file = File(localFilePath);
                                    controller.addPlaylistSongAudioUrlToList(
                                        file.existsSync()
                                            ? localFilePath
                                            : (playlistSongsData.audio)!);
                                    // }
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
                                          controller
                                              .isMiniPlayerOpenFavoriteSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenAlbumSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenAdminPlaylistSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenQueueSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenArtistSongs
                                              .value = false;
                                          controller
                                              .isMiniPlayerOpenDownloadSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenSearchSongs
                                              .value = false;
                                          controller.isMiniPlayerOpenHome
                                              .value = false;
                                          controller.isMiniPlayerOpenHome1
                                              .value = false;
                                          controller.isMiniPlayerOpenHome2
                                              .value = false;
                                          controller.isMiniPlayerOpenHome3
                                              .value = false;
                                          controller.isMiniPlayerOpenAllSongs
                                              .value = false;
                                          controller.isMiniPlayerOpen.value =
                                              true;
                                          currentListTileIndex = index;
                                          playlistScreenController
                                                  .currentPlayingTitle.value =
                                              playlistScreenController
                                                  .allSongsListModel!
                                                  .data![index]
                                                  .title!;
                                          playlistScreenController
                                                  .currentPlayingImage.value =
                                              playlistScreenController
                                                  .allSongsListModel!
                                                  .data![index]
                                                  .image!;
                                          playlistScreenController
                                                  .currentPlayingDesc.value =
                                              playlistScreenController
                                                  .allSongsListModel!
                                                  .data![index]
                                                  .description!;
                                          log(
                                              playlistScreenController
                                                  .currentPlayingTitle.value,
                                              name: 'currentPlayingTitle');
                                          log(
                                              playlistScreenController
                                                  .currentPlayingImage.value,
                                              name: 'currentPlayingImage');
                                          log(
                                              playlistScreenController
                                                  .currentPlayingDesc.value,
                                              name: 'currentPlayingDesc');
                                          controller.updateCurrentListTileIndex(
                                              index);
                                          log(
                                              controller
                                                  .currentListTileIndex.value
                                                  .toString(),
                                              name:
                                                  'currentListTileIndex playlist song log');
                                          controller.initAudioPlayer();
                                        });
                                        await prefs.setInt(
                                            'currentListTileIndex',
                                            currentListTileIndex);
                                        homeScreenController.addRecentSongs(
                                            musicId: playlistScreenController
                                                .isLikePlaylistData[controller
                                                    .currentListTileIndex.value]
                                                .id!);
                                        homeScreenController.recentSongsList();
                                      },
                                      contentPadding: const EdgeInsets.only(
                                          left: 23, right: 0.0,),
                                          horizontalTitleGap: 20,
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -1.5),
                                      leading: Stack(
                                        children: [
                                          Obx(() =>  ClipRRect(
                                            borderRadius:
                                                    BorderRadius.circular(5),
                                            child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                          controller.isMiniPlayerOpen.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenArtistSongs.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenAlbumSongs.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenHome.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                          false &&
                                                          controller.isMiniPlayerOpenHome1.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenHome2.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenSearchSongs.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenHome3.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenAllSongs.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                              false &&
                                                          controller.isMiniPlayerOpenQueueSongs.value ==
                                                              false)
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              (playlistSongsData.image!),
                                                          placeholder:
                                                              (context, url) {
                                                            return const SizedBox();
                                                          },
                                                          height: 70,
                                                          width: 70,
                                                          filterQuality:
                                                              FilterQuality.high,
                                                          fit: BoxFit.fill,
                                                        ) : ((
                                                                      // playlistScreenController.currentPlayingTitle.isNotEmpty ?
                                                                      playlistScreenController.currentPlayingTitle.value ==
                                                                          playlistScreenController
                                                                              .allSongsListModel!
                                                                              .data![
                                                                                  index]
                                                                              .title
                                                                  // : playlistScreenController.playlistSongAudioUrls[controller.currentListTileIndexAllSongs.value] == playlistScreenController.allSongsListModel!.data![index].audio
                                                                  ) &&
                                                                  playlistScreenController.allSongsListModel !=
                                                                      null &&
                                                                  controller
                                                                          .isMiniPlayerOpen
                                                                          .value ==
                                                                      true) ||
                                                              (controller.isMiniPlayerOpenHome1
                                                                          .value ==
                                                                      true &&
                                                                  categoryData1 !=
                                                                      null &&
                                                                  categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                                      playlistScreenController
                                                                          .allSongsListModel!
                                                                          .data![index]
                                                                          .title) ||
                                                              (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                              (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title && queueSongsScreenController.allSongsListModel != null && controller.isMiniPlayerOpenQueueSongs.value == true) ||
                                                              (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ? Opacity(
                                                            opacity: 0.4,
                                                            child: CachedNetworkImage(
                                                          imageUrl:
                                                              (playlistSongsData.image!),
                                                          placeholder:
                                                              (context, url) {
                                                            return const SizedBox();
                                                          },
                                                          height: 70,
                                                          width: 70,
                                                          filterQuality:
                                                              FilterQuality.high,
                                                          fit: BoxFit.fill,
                                                        ))
                                                        : CachedNetworkImage(
                                                          imageUrl:
                                                              (playlistSongsData.image!),
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
                                          ),),
                                          Obx(() => Positioned.fill(
                                              child: Center(
                                                child: (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                        controller
                                                                .isMiniPlayerOpenAlbumSongs
                                                                .value ==
                                                            false &&
                                                        controller.isMiniPlayerOpenArtistSongs.value ==
                                                  false &&
                                                        controller
                                                                .isMiniPlayerOpen
                                                                .value ==
                                                            false &&
                                                        controller.isMiniPlayerOpenSearchSongs.value ==
                                                                      false &&
                                                        controller
                                                                .isMiniPlayerOpenFavoriteSongs
                                                                .value ==
                                                            false &&
                                                        controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                      false &&
                                                        controller
                                                                .isMiniPlayerOpenHome
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
                                                    ? const SizedBox()
                                                    : ((((
                                                                      // playlistScreenController.currentPlayingTitle.isNotEmpty ?
                                                                      playlistScreenController.currentPlayingTitle.value ==
                                                                          playlistScreenController
                                                                              .allSongsListModel!
                                                                              .data![
                                                                                  index]
                                                                              .title
                                                                  // : playlistScreenController.playlistSongAudioUrls[controller.currentListTileIndexAllSongs.value] == playlistScreenController.allSongsListModel!.data![index].audio
                                                                  ) &&
                                                                  playlistScreenController.allSongsListModel !=
                                                                      null &&
                                                                  controller
                                                                          .isMiniPlayerOpen
                                                                          .value ==
                                                                      true) ||
                                                              (controller.isMiniPlayerOpenHome1
                                                                          .value ==
                                                                      true &&
                                                                  categoryData1 !=
                                                                      null &&
                                                                  categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                                      playlistScreenController
                                                                          .allSongsListModel!
                                                                          .data![index]
                                                                          .title) ||
                                                              (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                              (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title && queueSongsScreenController.allSongsListModel != null && controller.isMiniPlayerOpenQueueSongs.value == true) ||
                                                              (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                              (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title)) &&
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
                                                              child:
                                                                  SiriWaveform
                                                                      .ios9(
                                                                controller:
                                                                    controller
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
                                          fontSize: 11,
                                          color:
                                              (controller.isMiniPlayerOpenDownloadSongs.value == false &&
                                                      controller.isMiniPlayerOpen.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenArtistSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenAlbumSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenHome.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenAdminPlaylistSongs.value ==
                                                      false &&
                                                      controller.isMiniPlayerOpenHome1.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenHome2.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenSearchSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenHome3.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenAllSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenFavoriteSongs.value ==
                                                          false &&
                                                      controller.isMiniPlayerOpenQueueSongs.value ==
                                                          false)
                                                  ? Colors.white
                                                  : ((
                                                                  // playlistScreenController.currentPlayingTitle.isNotEmpty ?
                                                                  playlistScreenController.currentPlayingTitle.value ==
                                                                      playlistScreenController
                                                                          .allSongsListModel!
                                                                          .data![
                                                                              index]
                                                                          .title
                                                              // : playlistScreenController.playlistSongAudioUrls[controller.currentListTileIndexAllSongs.value] == playlistScreenController.allSongsListModel!.data![index].audio
                                                              ) &&
                                                              playlistScreenController.allSongsListModel !=
                                                                  null &&
                                                              controller
                                                                      .isMiniPlayerOpen
                                                                      .value ==
                                                                  true) ||
                                                          (controller.isMiniPlayerOpenHome1
                                                                      .value ==
                                                                  true &&
                                                              categoryData1 !=
                                                                  null &&
                                                              categoryData1!.data![controller.currentListTileIndexCategory1.value].title ==
                                                                  playlistScreenController
                                                                      .allSongsListModel!
                                                                      .data![index]
                                                                      .title) ||
                                                          (controller.isMiniPlayerOpenHome2.value == true && categoryData2 != null && categoryData2!.data![controller.currentListTileIndexCategory2.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenHome3.value == true && categoryData3 != null && categoryData3!.data![controller.currentListTileIndexCategory3.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenHome.value == true && homeScreenController.homeCategoryData[controller.currentListTileIndexCategory.value].categoryData[controller.currentListTileIndexCategoryData.value].title == playlistScreenController.allSongsListModel!.data![index].title && homeScreenController.homeCategoryData.isNotEmpty) ||
                                                          (controller.isMiniPlayerOpenQueueSongs.value == true && queueSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexQueueSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title && queueSongsScreenController.allSongsListModel != null && controller.isMiniPlayerOpenQueueSongs.value == true) ||
                                                          (controller.isMiniPlayerOpenFavoriteSongs.value == true && favoriteSongScreenController.allSongsListModel!.data!.isNotEmpty && favoriteSongScreenController.allSongsListModel != null && favoriteSongScreenController.allSongsListModel!.data![controller.currentListTileIndexFavoriteSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenAllSongs.value == true && allSongsScreenController.allSongsListModel != null && allSongsScreenController.allSongsListModel!.data![controller.currentListTileIndexAllSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenAlbumSongs.value == true && albumScreenController.allSongsListModel != null && albumScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenArtistSongs.value == true && artistScreenController.allSongsListModel != null && artistScreenController.currentPlayingTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenSearchSongs.value == true && searchScreenController.allSearchModel != null && searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenAdminPlaylistSongs.value == true && playlistScreenController.adminPlaylistSongModel != null && playlistScreenController.currentPlayingAdminTitle.value == playlistScreenController.allSongsListModel!.data![index].title) ||
                                                          (controller.isMiniPlayerOpenDownloadSongs.value == true && downloadSongScreenController.allSongsListModel != null && downloadSongScreenController.allSongsListModel!.data![controller.currentListTileIndexDownloadSongs.value].title == playlistScreenController.allSongsListModel!.data![index].title)
                                                      ? const Color(0xFF2ac5b3)
                                                      // : controller.isMiniPlayerOpen.value == false
                                                      // ? Colors.white
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
                            myPlaylistId: widget.screen == 'home' ? widget.myPlaylistData.playlistId :  (widget.myPlaylistData.id)!,
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
      ),
    );
  }

  Future<dynamic> playlistBottomSheet(
    BuildContext context,
    String playlistTitle,
    final myPlaylistData,
    var myPlaylistImages,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 320,
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
                        controller.currentListTileIndex.value = 0;
                        playlistScreenController.currentPlayingImage.value =
                            playlistScreenController
                                .isLikePlaylistData[0].image;
                        playlistScreenController.currentPlayingTitle.value =
                            playlistScreenController
                                .isLikePlaylistData[0].title;
                        playlistScreenController.currentPlayingDesc.value =
                            playlistScreenController
                                .isLikePlaylistData[0].description;
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
                    // commonListTilePlaylist(
                    //   icon: Icons.playlist_add_outlined,
                    //   text: AppStrings.addToQueue,
                    // ),
                    // commonListTilePlaylist(
                    //   icon: Icons.download,
                    //   text: AppStrings.download,
                    // ),
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
                child: 
                widget.screen != 'home' ? 
                myPlaylistImages.isEmpty
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
                    : myPlaylistImages.length == 4
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
                              itemCount: myPlaylistImages.length,
                              itemBuilder: (context, imageIndex) {
                                return Image.network(
                                  myPlaylistImages[imageIndex],
                                  // height: 15,
                                  // width: 15,
                                );
                              },
                            ),
                          )
                        : myPlaylistImages.length == 2
                            ? SizedBox(
                                height: 150,
                                width: 150,
                                child: Row(
                                  children: [
                                    Image.network(
                                      myPlaylistImages[0],
                                      height: 150,
                                      width: 75,
                                      fit: BoxFit.fill,
                                    ),
                                    Image.network(
                                      myPlaylistImages[1],
                                      height: 150,
                                      width: 75,
                                      fit: BoxFit.fill,
                                    )
                                  ],
                                ),
                              )
                            : myPlaylistImages.length == 3
                                ? SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(
                                              myPlaylistImages[0],
                                              height: 75,
                                              width: 75,
                                              fit: BoxFit.fill,
                                            ),
                                            Image.network(
                                              myPlaylistImages[1],
                                              height: 75,
                                              width: 75,
                                              fit: BoxFit.fill,
                                            )
                                          ],
                                        ),
                                        Image.network(
                                          myPlaylistImages[2],
                                          height: 75,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  )
                                : myPlaylistImages.length == 1
                                    ? SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.network(
                                          myPlaylistImages[0],
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : const SizedBox() : SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Image.network(
                                          myPlaylistImages,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
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
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Align(
                          alignment: Alignment.center,
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
                          playlistScreenController.currentPlayingImage.value =
                              playlistScreenController
                                  .isLikePlaylistData[index].image;
                          playlistScreenController.currentPlayingTitle.value =
                              playlistScreenController
                                  .isLikePlaylistData[index].title;
                          playlistScreenController.currentPlayingDesc.value =
                              playlistScreenController
                                  .isLikePlaylistData[index].description;
                          setState(() {
                            // isMiniPlayerOpen = true;
                            controller.isMiniPlayerOpen.value = true;
                            controller.isMiniPlayerOpenAdminPlaylistSongs.value = false;
                            controller.isMiniPlayerOpenAlbumSongs.value = false;
                            controller.isMiniPlayerOpenAlbumSongs.value = false;
                            controller.isMiniPlayerOpenDownloadSongs.value =
                                false;
                            controller.isMiniPlayerOpenQueueSongs.value = false;
                            controller.isMiniPlayerOpenFavoriteSongs.value =
                                false;
                            controller.isMiniPlayerOpenSearchSongs.value =
                                false;
                            controller.isMiniPlayerOpenHome.value = false;
                            controller.isMiniPlayerOpenHome1.value = false;
                            controller.isMiniPlayerOpenHome2.value = false;
                            controller.isMiniPlayerOpenHome3.value = false;
                            controller.isMiniPlayerOpenAllSongs.value = false;
                            // playlistScreenController.queueAudioUrls.isNotEmpty
                            //     ? playlistScreenController.queueAudioUrls[0]
                            //     : null;
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
                            playlistId: widget.screen == 'home' ? widget.myPlaylistData.playlistId :  (widget.myPlaylistData.id)!,
                          )
                              .then((value) {
                            //  (controller.playlisSongAudioUrl[controller.currentListTileIndex.value] == playlistScreenController
                            //   .allSongsListModel!.data![index].audio!) && playlistScreenController.isLikePlaylistData.isEmpty ? playlistScreenController.isPlaylistSongsEmpty.value = true : playlistScreenController.isPlaylistSongsEmpty.value = false;
                            ((controller.isMiniPlayerOpenAllSongs.value == true ||
                                        controller.isMiniPlayerOpenDownloadSongs
                                                .value ==
                                            true ||
                                        controller.isMiniPlayerOpenFavoriteSongs
                                                .value ==
                                            true ||
                                        controller.isMiniPlayerOpenAlbumSongs.value ==
                                            true ||
                                        controller.isMiniPlayerOpenHome.value ==
                                            true ||
                                        controller
                                                .isMiniPlayerOpenSearchSongs.value ==
                                            true ||
                                        controller.isMiniPlayerOpenHome1.value ==
                                            true ||
                                        controller.isMiniPlayerOpenHome2.value ==
                                            true ||
                                        controller
                                                .isMiniPlayerOpenHome3.value ==
                                            true ||
                                        controller
                                                .isMiniPlayerOpenAdminPlaylistSongs.value ==
                                            true ||
                                        controller.isMiniPlayerOpenQueueSongs
                                                .value ==
                                            true) ||
                                    ((playlistScreenController
                                                .currentPlayingTitle.value ==
                                            playlistScreenController
                                                .allSongsListModel!
                                                .data![index]
                                                .title!) ||
                                        playlistScreenController
                                            .isLikePlaylistData.isEmpty))
                                ? controller.isMiniPlayerOpen.value = false
                                : controller.isMiniPlayerOpen.value = true;
                            log('${controller.isMiniPlayerOpen.value}',
                                name: 'controller.isMiniPlayerOpen.value');
                            setState(() {
                              checkedIds.remove(int.parse(
                                  (playlistScreenController
                                      .allSongsListModel!.data![index].id)!));
                              checkedIds.toList();
                            });

                            playlistScreenController.songsInPlaylist(
                              playlistId: widget.screen == 'home' ? widget.myPlaylistData.playlistId : (widget.myPlaylistData.id)!,
                            );
                          });
                          detailScreenController.fetchMyPlaylistData();
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
                          onTap: () async {
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
                                    playlistId: widget.screen == 'home' ? widget.myPlaylistData.playlistId : (myPlaylistData.id)!)
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
                              // playlistScreenController.queueAudioUrls;

                              playlistScreenController.songsInPlaylist(
                                playlistId:  (widget.myPlaylistData.id)!,
                              );
                              // final response = await playlistScreenController.queueSongsList(
                              //   playlistId: (widget.myPlaylistData.id)!);
                              //   response['']
                              Get.back();
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
                    child: Image.network(
                      playlistSongsData.image,
                      height: 150,
                      width: 150,
                      fit: BoxFit.fill,
                    ),

                    //  FloatingActionButton(
                    //   onPressed: () {},
                    //   backgroundColor: const Color(0xFF30343d),
                    //   child: Icon(
                    //     Icons.music_note,
                    //     color: AppColors.white,
                    //     size: 60,
                    //   ),
                    // ),
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
                                (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
                                    true &&
                        playlistScreenController.adminPlaylistSongModel != null &&
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
                            ? playlistScreenController.currentPlayingAdminImage.value
                            // playlistScreenController.adminPlaylistSongModel!.data![controller.currentListTileIndexAdminPlaylistSongs.value].image ??
                                // 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : searchScreenController.allSearchModel != null &&
                                    (controller.isMiniPlayerOpenSearchSongs.value) ==
                                        true &&
                                    (controller.isMiniPlayerOpenAdminPlaylistSongs.value) ==
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
                                        (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                        (controller.isMiniPlayerOpenFavoriteSongs.value) == false &&
                                        (controller.isMiniPlayerOpenDownloadSongs.value) == false &&
                                        (controller.isMiniPlayerOpen.value) == false &&
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
                                  (controller.isMiniPlayerOpenAdminPlaylistSongs
                                          .value) ==
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
                              ? playlistScreenController.currentPlayingAdminTitle.value
                              // (playlistScreenController
                              //     .adminPlaylistSongModel!
                              //     .data![controller
                              //         .currentListTileIndexAdminPlaylistSongs.value]
                              //     .title)!
                              : (controller.isMiniPlayerOpenAlbumSongs.value) == false &&
                                      (controller.isMiniPlayerOpenArtistSongs.value) ==
                                          false &&
                                      (controller
                                              .isMiniPlayerOpenAdminPlaylistSongs
                                              .value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenQueueSongs.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenSearchSongs
                                              .value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenFavoriteSongs
                                              .value) ==
                                          false &&
                                      (controller.isMiniPlayerOpen.value) == false &&
                                      (controller.isMiniPlayerOpenHome.value) == false &&
                                      (controller.isMiniPlayerOpenHome1.value) == false &&
                                      (controller.isMiniPlayerOpenHome2.value) == false &&
                                      (controller.isMiniPlayerOpenHome3.value) == false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) == false &&
                                      (controller.isMiniPlayerOpenDownloadSongs.value) == false
                                  ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].title)!
                                  : (controller.isMiniPlayerOpenArtistSongs.value) == true && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false
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
                                  (controller.isMiniPlayerOpenAdminPlaylistSongs
                                          .value) ==
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
                              ? playlistScreenController.currentPlayingAdminDesc.value
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
                                      (controller.isMiniPlayerOpenHome3.value) == false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) == false
                                  ? (searchScreenController.allSearchModel!.data![controller.currentListTileIndexSearchSongs.value].description)!
                                  : homeScreenController.homeCategoryData.isNotEmpty && (controller.isMiniPlayerOpenHome.value) == true && (controller.isMiniPlayerOpenAdminPlaylistSongs.value) == false && (controller.isMiniPlayerOpenArtistSongs.value) == false && (controller.isMiniPlayerOpenSearchSongs.value) == false && (controller.isMiniPlayerOpenAlbumSongs.value) == false && (controller.isMiniPlayerOpenFavoriteSongs.value) == false && (controller.isMiniPlayerOpenDownloadSongs.value) == false && (controller.isMiniPlayerOpen.value) == false && (controller.isMiniPlayerOpenHome1.value) == false && (controller.isMiniPlayerOpenHome2.value) == false && (controller.isMiniPlayerOpenHome3.value) == false && (controller.isMiniPlayerOpenAllSongs.value) == false && (controller.isMiniPlayerOpenQueueSongs.value) == false
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
            ),),
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
