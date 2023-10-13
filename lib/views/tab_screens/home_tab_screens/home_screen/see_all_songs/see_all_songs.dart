import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/detail_screen/detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

// ignore: must_be_immutable
class SeeAllSongScreen extends StatefulWidget {
  CategoryData? categoryData;
  SeeAllSongScreen({super.key, this.categoryData});

  @override
  State<SeeAllSongScreen> createState() => _SeeAllSongScreenState();
}

class _SeeAllSongScreenState extends State<SeeAllSongScreen> {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  @override
  Widget build(BuildContext context) {
    setState(() {
      controller.allSongsUrl = [];
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
            text: widget.categoryData!.message ?? '',
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
                  itemCount: widget.categoryData!.data!.length,
                  // > 3 ?  widget.categoryData!.data!.length = 3 : widget.categoryData!.data!.length ,
                  itemBuilder: (context, index) {
                    var categoryListData = widget.categoryData!.data![index];
                    final localFilePath =
                        '${AppStrings.localPathMusic}/${widget.categoryData!.data![index].id}.mp3';
                    final file = File(localFilePath);
                    controller.addAllSongsAudioUrlToList(file.existsSync()
                        ? localFilePath
                        : (widget.categoryData!.data![index].audio)!);
                    controller.allSongsUrl =
                        controller.allSongsUrl.toSet().toList();
                    log(controller.allSongsUrl.toString());

                    (widget.categoryData!.message)! == "Category1"
                        ? controller.category1AudioUrl =
                            controller.category1AudioUrl.toSet().toList()
                        : (widget.categoryData!.message)! == "Category2"
                            ? controller.category2AudioUrl =
                                controller.category2AudioUrl.toSet().toList()
                            : (widget.categoryData!.message)! == "Category3"
                                ? controller.category3AudioUrl = controller
                                    .category3AudioUrl
                                    .toSet()
                                    .toList()
                                : Null;
                    return GestureDetector(
                      onTap: () async {
                        homeScreenController
                            .updateCategoryData(widget.categoryData!);

                        // controller.isMiniPlayerOpen.value == true
                        //     ? (controller.audioPlayer)!.dispose()
                        //     : null;
                        setState(() {
                          controller.isMiniPlayerOpen.value == false;
                          controller.isMiniPlayerOpenHome1.value =
                              (widget.categoryData!.message)! == "Category1"
                                  ? true
                                  : false;
                          controller.isMiniPlayerOpenHome2.value =
                              (widget.categoryData!.message)! == "Category2"
                                  ? true
                                  : false;
                          controller.isMiniPlayerOpenHome3.value =
                              (widget.categoryData!.message)! == "Category3"
                                  ? true
                                  : false;
                          controller.isMiniPlayerOpenAllSongs.value = false;

                          (widget.categoryData!.message)! == "Category1"
                              ? controller.currentListTileIndexCategory1.value =
                                  index
                              : (widget.categoryData!.message)! == "Category2"
                                  ? controller.currentListTileIndexCategory2
                                      .value = index
                                  : (widget.categoryData!.message)! ==
                                          "Category3"
                                      ? controller.currentListTileIndexCategory3
                                          .value = index
                                      : null;

                          (widget.categoryData!.message)! == "Category1"
                              ? controller
                                  .updateCurrentListTileIndexCategory1(index)
                              : (widget.categoryData!.message)! == "Category2"
                                  ? controller
                                      .updateCurrentListTileIndexCategory2(
                                          index)
                                  : (widget.categoryData!.message)! ==
                                          "Category3"
                                      ? controller
                                          .updateCurrentListTileIndexCategory3(
                                              index)
                                      : null;
                          // controller.initAudioPlayer();
                          // controller.audioPlayer!.load();
                        });
                        final prefs = await SharedPreferences.getInstance();
                        prefs.reload();
                        await prefs.setBool('isMiniPlayerOpen', false);

                        (widget.categoryData!.message)! == "Category1"
                            ? await prefs.setBool('isMiniPlayerOpenHome1', true)
                            : (widget.categoryData!.message)! == "Category2"
                                ? await prefs.setBool(
                                    'isMiniPlayerOpenHome2', true)
                                : (widget.categoryData!.message)! == "Category3"
                                    ? await prefs.setBool(
                                        'isMiniPlayerOpenHome3', true)
                                    : null;

                        (widget.categoryData!.message)! == "Category1"
                            ? await prefs.setInt('category1Index', index)
                            : (widget.categoryData!.message)! == "Category2"
                                ? await prefs.setInt('category2Index', index)
                                : (widget.categoryData!.message)! == "Category3"
                                    ? await prefs.setInt(
                                        'category3Index', index)
                                    : null;
                      },
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -1),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            (categoryListData.image) ??
                                'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                            height: 70,
                            width: 70,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        title: Obx(() => lable(
                            text: (categoryListData.title)!,
                            fontSize: 12,
                            color: (widget.categoryData!.data![controller
                                                .currentListTileIndexCategory1
                                                .value] ==
                                            widget.categoryData!.data![index] &&
                                        controller.isMiniPlayerOpenHome1.value ==
                                            true) ||
                                    (widget.categoryData!.data![controller.currentListTileIndexCategory2.value] ==
                                            widget.categoryData!.data![index] &&
                                        controller.isMiniPlayerOpenHome2.value ==
                                            true) ||
                                    (widget.categoryData!.data![controller.currentListTileIndexCategory3.value] ==
                                            widget.categoryData!.data![index] &&
                                        controller.isMiniPlayerOpenHome3.value == true)
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
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ((controller.isMiniPlayerOpenHome1.value) == true &&
                        widget.categoryData != null) ||
                    ((controller.isMiniPlayerOpenHome2.value) == true &&
                        widget.categoryData != null) ||
                    ((controller.isMiniPlayerOpenHome3.value) == true &&
                        widget.categoryData != null)
                ? BottomAppBar(
                    elevation: 0,
                    height: 60,
                    padding: EdgeInsets.zero,
                    clipBehavior: Clip.none,
                    color: AppColors.backgroundColor,
                    child: miniplayer())
                : const SizedBox(),
          ],
        ),
      ),
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
                  index: controller.isMiniPlayerOpenHome1.value == true
                      ? controller.currentListTileIndexCategory1.value
                      : controller.isMiniPlayerOpenHome2.value == true
                          ? controller.currentListTileIndexCategory2.value
                          : controller.isMiniPlayerOpenHome3.value == true
                              ? controller.currentListTileIndexCategory3.value
                              : controller.isMiniPlayerOpenAllSongs.value ==
                                      true
                                  ? controller
                                      .currentListTileIndexAllSongs.value
                                  : controller.currentListTileIndex.value,
                  type: controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true
                      ? 'home'
                      : controller.isMiniPlayerOpenAllSongs.value == true
                          ? 'allSongs'
                          : 'playlist',
                  duration: duration,
                  position: position,
                  bufferedPosition: bufferedPosition,
                  durationStream: durationStream!,
                  positionStream: positionStream!,
                  bufferedPositionStream: bufferedPositionStream!,
                  audioPlayer: controller.isMiniPlayerOpenHome1.value == true ||
                          controller.isMiniPlayerOpenHome2.value == true ||
                          controller.isMiniPlayerOpenHome3.value == true ||
                          controller.isMiniPlayerOpenAllSongs.value == true
                      ? controller.audioPlayer
                      : null,
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
                      widget.categoryData != null &&
                              (controller.isMiniPlayerOpenHome1.value) ==
                                  true &&
                              (controller.isMiniPlayerOpenHome2.value) ==
                                  false &&
                              (controller.isMiniPlayerOpenHome3.value) ==
                                  false &&
                              (controller.isMiniPlayerOpenAllSongs.value) ==
                                  false
                          ? widget.categoryData!.data![controller.currentListTileIndexCategory1.value].image ??
                              'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                          : widget.categoryData != null &&
                                  (controller.isMiniPlayerOpenHome1.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome2.value) ==
                                      true &&
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false
                              ? widget
                                      .categoryData!
                                      .data![controller
                                          .currentListTileIndexCategory2.value]
                                      .image ??
                                  'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                              : widget.categoryData != null &&
                                      (controller.isMiniPlayerOpenHome1.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenAllSongs
                                              .value) ==
                                          false
                                  ? widget
                                          .categoryData!
                                          .data![controller
                                              .currentListTileIndexCategory3
                                              .value]
                                          .image ??
                                      'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                                  : widget
                                          .categoryData!
                                          .data![controller.currentListTileIndexCategory3.value]
                                          .image ??
                                      'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
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
                          text: (controller.isMiniPlayerOpenHome1.value) == true &&
                                  (controller.isMiniPlayerOpenHome2.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false
                              ? (widget
                                  .categoryData!
                                  .data![controller.currentListTileIndexCategory1
                                      .value]
                                  .title)!
                              : (controller.isMiniPlayerOpenHome1.value) == false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (widget
                                      .categoryData!
                                      .data![controller
                                          .currentListTileIndexCategory2.value]
                                      .title)!
                                  : (controller.isMiniPlayerOpenHome1.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome2.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome3.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpenAllSongs
                                                  .value) ==
                                              false
                                      ? (widget
                                          .categoryData!
                                          .data![controller.currentListTileIndexCategory3.value]
                                          .title)!
                                      : '',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        lable(
                          text: (controller.isMiniPlayerOpenHome1.value) == true &&
                                  (controller.isMiniPlayerOpenHome2.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenHome3.value) ==
                                      false &&
                                  (controller.isMiniPlayerOpenAllSongs.value) ==
                                      false
                              ? (widget
                                  .categoryData!
                                  .data![controller.currentListTileIndexCategory1
                                      .value]
                                  .description)!
                              : (controller.isMiniPlayerOpenHome1.value) == false &&
                                      (controller.isMiniPlayerOpenHome2.value) ==
                                          true &&
                                      (controller.isMiniPlayerOpenHome3.value) ==
                                          false &&
                                      (controller.isMiniPlayerOpenAllSongs.value) ==
                                          false
                                  ? (widget
                                      .categoryData!
                                      .data![controller
                                          .currentListTileIndexCategory2.value]
                                      .description)!
                                  : (controller.isMiniPlayerOpenHome1.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome2.value) ==
                                              false &&
                                          (controller.isMiniPlayerOpenHome3.value) ==
                                              true &&
                                          (controller.isMiniPlayerOpenAllSongs
                                                  .value) ==
                                              false
                                      ? (widget
                                          .categoryData!
                                          .data![controller.currentListTileIndexCategory3.value]
                                          .description)!
                                      : '',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                sizeBoxWidth(6),
                ControlButtons(
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
        positionStream = controller.isMiniPlayerOpenHome1.value == true ||
                controller.isMiniPlayerOpenHome2.value == true ||
                controller.isMiniPlayerOpenHome3.value == true ||
                controller.isMiniPlayerOpenAllSongs.value == true
            ? controller.audioPlayer.positionStream
            : controller.audioPlayer.positionStream,
        bufferedPositionStream =
            controller.isMiniPlayerOpenHome1.value == true ||
                    controller.isMiniPlayerOpenHome2.value == true ||
                    controller.isMiniPlayerOpenHome3.value == true ||
                    controller.isMiniPlayerOpenAllSongs.value == true
                ? controller.audioPlayer.bufferedPositionStream
                : controller.audioPlayer.bufferedPositionStream,
        durationStream = controller.isMiniPlayerOpenHome1.value == true ||
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
