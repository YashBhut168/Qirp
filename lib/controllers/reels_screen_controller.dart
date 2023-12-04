
import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/reels_data_model.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ReelsScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  //  VideoPlayerController? videoPlayerController;
  // ChewieController? chewieController;

  // ChewieController? _chewieController;
  RxBool isLoading = false.obs;
  var reelsData = [].obs;
  List<String> allReelsVideo = [];
  List<bool> allReelsLike = [];
  // List<int> allReelsView = [];

  @override
  void onInit() {
    GlobVar.userId == ''
        ? getReel(userId: null)
        : getReel(userId: GlobVar.userId);
    super.onInit();
  }

  addReelsVideo({video, description}) async {
    isLoading.value = true;
    try {
      final response = await apiHelper.addReelsVideo(video, description);
      // GlobVar.forgotPasswordApiMessage = response['message'];
      // GlobVar.forgotPasswordApiSuccess = response['success'];
      if (response['success'] == "true") {
        snackBar(response['message']);
        if (kDebugMode) {
          GlobVar.addPostSuccess = response['success'];
          GlobVar.likeReelList.length = GlobVar.likeReelList.length + 1;

          print("addreelsresponse----------> $response");
          print("GlobVar.likeReelList.length----------> ${GlobVar.likeReelList.length}");
        }
        isLoading.value = false;
      } else {
        snackBar(response['message']);
        isLoading.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('forgot failed: $e');
      }
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  ReelsDataModel? reelsDataModel;
  getReel({userId}) async {
    try {
      userId == null ? isLoading.value = true : null;
      final reelDataModelJson = await apiHelper.getReel(userId: userId);

      reelsDataModel = ReelsDataModel.fromJson(reelDataModelJson);

      reelsData.value = reelsDataModel!.data!;

      allReelsVideo = List.generate(
        reelsData.length,
        (index) => reelsData[index].postPic!,
      );

      // GlobVar.reelVideoList = allReelsVideo;
      // GlobVar.likeReelList = List.generate(
      //   reelsData.length,
      //   (index) => reelsData[index].isReelLike!,
      // );
      // print("GlobVar.likeReelList>>>> ${GlobVar.likeReelList}");
      // allReelsView = List.generate(
      //   reelsData.length,
      //   (index) => reelsData[index].totalViewCount!,
      // );
      // log("$allReelsVideo",name: 'allReelsVideo');
      log("${GlobVar.reelVideoList}",name: 'GlobVar.reelVideoList');
      if (kDebugMode) {
        print('userId::::> $userId');
      }
      userId == null ? isLoading.value = false : null;
    } catch (e) {
      userId == null ? isLoading.value = false : null;
      if (kDebugMode) {
        print(e);
      }
    }
    userId == null ? isLoading.value = false : null;
  }

  // getReelsPost({userId}) async {
  //   try {
  //     isLoading.value = true;
  //     final reelDataModelJson = await apiHelper.getReelPost(userId);

  //     reelsDataModel = ReelsDataModel.fromJson(reelDataModelJson);

  //     reelsData.value = reelsDataModel!.data!;

  //     allReels = List.generate(
  //       reelsData.length,
  //       (index) => reelsData[index].postPic!,
  //     );
  //     // allReelsView = List.generate(
  //     //   reelsData.length,
  //     //   (index) => reelsData[index].totalViewCount!,
  //     // );
  //     // log("${allReelsView}",name: 'allreelsview');
  //     isLoading.value = false;
  //   } catch (e) {
  //     isLoading.value = false;
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   isLoading.value = false;
  // }

  viewReels({
    userId,
    reelId,
  }) async {
    try {
      final response = await apiHelper.viewReel(userId, reelId);
      if (kDebugMode) {
        print("viewreelsresponse>>>>> $response");
      }
      // getReel();
    } catch (e) {
      if (kDebugMode) {
        print('view reels failed: $e');
      }
    }
  }

  likeUnlikeReels({
    reelId,
  }) async {
    try {
      final response = await apiHelper.likeUnlikeReel(reelId);
      if (kDebugMode) {
        print("likeunlikeresponse>>>>> $response");
        GlobVar.likeUnlikeMessage[GlobVar.reelIndex] = response['message'];
        print('GlobVar.likeUnlikeMessage------> ${GlobVar.likeUnlikeMessage}');


      }
      // getReel();
    } catch (e) {
      if (kDebugMode) {
        print('like unlike reels failed: $e');
      }
    }
  }

  // Future initializePlayer(video) async {
  //   // ignore: deprecated_member_use
  //   _videoPlayerController = VideoPlayerController.network(video);
  //   await Future.wait([_videoPlayerController.initialize()]);
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     autoPlay: true,
  //     showControls: false,
  //     allowFullScreen: true,
  //     looping: true,
  //   );
  //   // setState(() {});
  // }
}
