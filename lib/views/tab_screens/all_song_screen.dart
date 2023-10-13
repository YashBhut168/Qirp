import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    fetchData();
    allSongsScreenController.allSongsList();

    // controller.isMiniPlayerOpenAllSongs.value = true;
    // controller.isMiniPlayerOpen.value = false;
    log("${controller.isMiniPlayerOpenAllSongs.value}",
        name: 'controller.isMiniPlayerOpenAllSongs.value');
  }

  @override
  Widget build(BuildContext context) {
    log("${controller.allSongsUrl.toList()}");
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
      body: Obx(
        () => allSongsScreenController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
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
                          itemCount: allSongsScreenController
                              .allSongsListModel!.data!.length,
                          itemBuilder: (context, index) {
                            var allSongsListData = allSongsScreenController
                                .allSongsListModel!.data![index];
                                final localFilePath =
                                    '${AppStrings.localPathMusic}/${allSongsScreenController
                                    .allSongsListModel!.data![index].id}.mp3';
                                final file = File(localFilePath);
                            controller.addAllSongsAudioUrlToList(
                              file.existsSync() ? localFilePath:
                                (allSongsScreenController
                                    .allSongsListModel!.data![index].audio)!);
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
                                  controller.isMiniPlayerOpenDownloadSongs.value = false;
                                  controller.isMiniPlayerOpenHome1.value =
                                      false;
                                  controller.isMiniPlayerOpenHome2.value =
                                      false;
                                  controller.isMiniPlayerOpenHome3.value =
                                      false;
                                  controller.isMiniPlayerOpenAllSongs.value =
                                      true;
                                  controller.currentListTileIndexAllSongs
                                      .value = index;
                                  controller.updateCurrentListTileIndexAllSongs(
                                      index);

                                  controller.audioPlayer.play();
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

                                await prefs.setBool('isMiniPlayerOpen', false);
                                await prefs.setBool(
                                    'isMiniPlayerOpenAllSongs', true);
                                await prefs.setInt('allSongsIndex', index);
                                homeScreenController.addRecentSongs(musicId: allSongsListData.id!);
                              },
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -1),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.network(
                                    (allSongsListData.image) ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                    height: 70,
                                    width: 70,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                title: Obx(
                                  () => lable(
                                    text: (allSongsListData.title)!,
                                    fontSize: 12,
                                    color: allSongsScreenController
                                                    .allSongsListModel!.data![
                                                controller.currentListTileIndexAllSongs
                                                    .value] ==
                                            allSongsScreenController
                                                .allSongsListModel!.data![index]
                                        ? const Color(0xFF2ac5b3)
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: lable(
                                  text: (allSongsListData.description)!,
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