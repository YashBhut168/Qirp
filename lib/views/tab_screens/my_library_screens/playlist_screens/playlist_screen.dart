import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/download_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/playlist_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/looking_for_songs_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/playlist_songs_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  DownloadSongScreenController downloadSongScreenController =
      Get.put(DownloadSongScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  PlaylistScreenController playlistScreenController =
      Get.put(PlaylistScreenController());
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());

  TextEditingController searchController = TextEditingController();
  TextEditingController playlistNameController = TextEditingController();
  GlobalKey<FormState> myKey7 = GlobalKey<FormState>();

  List<String> playlistTitles = [];
  List<String> filteredPlaylistTitles = [];

  @override
  void initState() {
    super.initState();
    detailScreenController.fetchMyPlaylistData();
    fetchMyPlaylistData();
    fetchData();

    sharedPref();
    setState(() {
      controller.isMiniPlayerOpenDownloadSongs.value == true ||
              controller.isMiniPlayerOpen.value == true ||
              controller.isMiniPlayerOpenHome1.value == true ||
              controller.isMiniPlayerOpenHome2.value == true ||
              controller.isMiniPlayerOpenHome3.value == true ||
              controller.isMiniPlayerOpenAllSongs.value == true
          ? controller.audioPlayer.play()
          : null;
      controller.currentListTileIndexDownloadSongs.value;
      controller.currentListTileIndex.value;
      controller.currentListTileIndexAllSongs.value;
      controller.currentListTileIndexCategory1.value;
      controller.currentListTileIndexCategory2.value;
      controller.currentListTileIndexCategory3.value;
    });
    allSongsScreenController.allSongsList();
    playlistScreenController.songsInPlaylist(playlistId: '');
    downloadSongScreenController.downloadSongsList();
  }

  final apiHelper = ApiHelper();

  bool isLoading = false;
  MyPlaylistDataModel? myPlaylistDataModel;

  Future<void> fetchMyPlaylistData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

      myPlaylistDataModel =
          MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);

      playlistTitles =
          myPlaylistDataModel!.data!.map((item) => item.plTitle!).toList();

      filteredPlaylistTitles = playlistTitles;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading = false;
      }
    }
  }

  void filterPlaylistTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPlaylistTitles = playlistTitles;
      } else {
        filteredPlaylistTitles = playlistTitles
            .where((title) => title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    bool isMiniPlayerOpen = prefs.getBool('isMiniPlayerOpen')!;
    log("$isMiniPlayerOpen");
    int currentListTileIndex = prefs.getInt('currentListTileIndex')!;
    log("$currentListTileIndex");
    controller.toggleMiniPlayer(isMiniPlayerOpen);
    controller.updateCurrentListTileIndex(currentListTileIndex);
  }

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          Get.offAll(MainScreen());
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
          body: myPlaylistDataModel == null || isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.white,
                ))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: commonTextField(
                              borderRadius: 15,
                              backgroundColor: Colors.white,
                              cursorColor: Colors.grey,
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                              ),
                              borderColor: Colors.transparent,
                              hintText: AppStrings.search,
                              textColor: Colors.grey,
                              lableColor: Colors.grey,
                              controller: searchController,
                              onChanged: (query) {
                                filterPlaylistTitles(query);
                              },
                            ),
                          ),
                          sizeBoxHeight(18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: GestureDetector(
                              onTap: () {
                                createPlaylist();
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
                          myPlaylistDataModel!.data!.isEmpty
                              ? Center(
                                  heightFactor: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      lable(text: AppStrings.makeYourPlaylist),
                                      sizeBoxWidth(5),
                                      const Icon(
                                        Icons.create,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredPlaylistTitles.length,
                                  itemBuilder: ((context, index) {
                                    var playlistTitle =
                                        filteredPlaylistTitles[index];
                                    var myPlaylistData =
                                        myPlaylistDataModel!.data![index];

                                    //  print(playlistTitles);
                                    return ListTile(
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -3.610),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.music_note,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                      title: lable(
                                        text: playlistTitle,
                                        fontSize: 12,
                                      ),
                                      subtitle: lable(
                                        text:
                                            "${(myPlaylistData.tracks)!}  songs",
                                        // "${(myPlaylistDataModel!.data![index].tracks)!} • ${AppStrings.tracks}",
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.more_vert_outlined,
                                        ),
                                        onPressed: () {
                                          bottomSheet(context, index,
                                              playlistTitle, myPlaylistData);
                                        },
                                      ),
                                      onTap: () {
                                        (myPlaylistData.tracks)! == '0'
                                            ? Get.to(
                                                LookingForSongsScreen(
                                                  playlistTitle: playlistTitle,
                                                  myPlaylistData:
                                                      myPlaylistData,
                                                ),
                                              )
                                            : Get.to(
                                                PlaylistSongsScreen(
                                                  playlistTitle: playlistTitle,
                                                  myPlaylistData:
                                                      myPlaylistData,
                                                ),
                                              );
                                      },
                                    );
                                  }),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          height:
              (myPlaylistDataModel!.data![index].tracks)! == '0' ? 280 : 330,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Scaffold(
              backgroundColor: const Color(0xFF30343d),
              body: SingleChildScrollView(
                child: (myPlaylistDataModel!.data![index].tracks)! == '0'
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
                            text: AppStrings.removeFromLibrary,
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
                              (myPlaylistData.tracks)! == '0'
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
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.grey,
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
                                fetchMyPlaylistData();
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
}
