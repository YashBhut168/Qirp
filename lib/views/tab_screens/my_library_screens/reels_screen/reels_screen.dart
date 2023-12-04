// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/main_screen_controller.dart';

// class ReelsScreen extends StatefulWidget {
//   const ReelsScreen({super.key});

//   @override
//   State<ReelsScreen> createState() => _ReelsScreenState();
// }

// class _ReelsScreenState extends State<ReelsScreen> {
//   final MainScreenController controller =
//       Get.put(MainScreenController(initialIndex: 0));

//   @override
//   void initState() {
//     super.initState();
//     controller.isMiniPlayerOpenDownloadSongs.value == true ||
//     controller.isMiniPlayerOpen.value == true ||
//             controller.isMiniPlayerOpenHome1.value == true ||
//             controller.isMiniPlayerOpenHome2.value == true ||
//             controller.isMiniPlayerOpenHome3.value == true ||
//             controller.isMiniPlayerOpenAllSongs.value == true
//         ? controller.audioPlayer.play()
//         : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Center(
//         child: Text('Search Screen'),
//       ),
//     );
//   }
// }


import 'package:edpal_music_app_ui/controllers/reels_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:edpal_music_app_ui/utils/common_method.dart';
import 'package:video_player/video_player.dart';

// ignore: use_key_in_widget_constructors
// class ReelsScreen extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _ReelsScreenState createState() => _ReelsScreenState();
// }

// class _ReelsScreenState extends State<ReelsScreen> {
//   File? _video;
//   final picker = ImagePicker();

//   ReelsScreenController reelsScreenController =
//       Get.put(ReelsScreenController());
//   // late VideoPlayerController _videoPlayerController;
//   // late ChewieController _chewieController;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future pickVideoAndUploadApi() async {
//     final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _video = File(pickedFile.path);
//       }
//     });

//     reelsScreenController.addReelsVideo(video: _video!.path);

//   // @override
//   // void dispose() {
//   //   // _videoPlayerController.dispose();
//   //   // _chewieController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _video == null
//                 ? lable(text: 'No video selected.')
//                 : lable(
//                     text: "${_video!.path}",
//                     textAlign: TextAlign.center,
//                     maxLines: 4),
//             ElevatedButton(
//               onPressed: pickVideoAndUploadApi,
//               child: Text('Pick Video from Gallery and Upload to api'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore: use_key_in_widget_constructors
class ReelsScreen extends StatefulWidget {
  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  ReelsScreenController reelsScreenController =
      Get.put(ReelsScreenController());
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    // reelsScreenController.getReel(userId: GlobVar.userId == '' ? null : GlobVar.userId);
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   GlobVar.reelVideoList;
    // });
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(
          () => reelsScreenController.isLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                )
              : reelsScreenController.reelsDataModel!.data!.isEmpty
                  // && (categoryData1 != null || categoryData2 != null || categoryData3 != null)
                  ? Center(
                      child: lable(
                          text: 'No reels available', color: AppColors.white),
                    )
                  :
                  // Obx(
                  //     () =>

                  Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        // GlobVar.reelVideoList = List.generate(
                        //   reelsScreenController.reelsData.length,
                        //   (index) =>
                        //       reelsScreenController.reelsData[index].postPic!,
                        // );
                        // log("${GlobVar.reelVideoList}",
                        //     name: 'GlobVar.reelVideoList');

                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: ContentScreen(
                            src: reelsScreenController.allReelsVideo[index],
                            reelData: reelsScreenController.reelsData[index],
                            index: index,
                          ),
                        );
                      },
                      itemCount: reelsScreenController.reelsData.length,
                      scrollDirection: Axis.vertical,
                    ),
          // ),
        ),
      ),
    );
  }
}
