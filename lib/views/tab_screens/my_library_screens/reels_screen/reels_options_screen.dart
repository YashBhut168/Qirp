// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edpal_music_app_ui/controllers/reels_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/views/auth_screens/without_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/reels_screen/addvideoPost.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress_plus/video_compress_plus.dart';
import 'package:video_player/video_player.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class OptionsScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var reelData;
  // ignore: prefer_typing_uninitialized_variables
  var index;
  OptionsScreen({Key? key, this.reelData, this.index}) : super(key: key);
  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  File? _video;
  final picker = ImagePicker();
  late VideoPlayerController _videoPlayerController;
  // ignore: unused_field
  VideoPlayerController? _cameraVideoPlayerController;
  // bool _visibility = true;
  // var isLikeReel = [];

  ReelsScreenController reelsScreenController =
      Get.put(ReelsScreenController());

  final TextEditingController _captionController = TextEditingController();

  // Future pickVideoAndUploadApi() async {
  //   final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _video = File(pickedFile.path);
  //     }
  //   });

  //   reelsScreenController.addReelsVideo(video: _video!.path);
  // }

  // viewReel() {
  //   print("userid>>>>> ${widget.reelData.userId}");
  //   print("reelid>>>>> ${widget.reelData.id}");
  //   reelsScreenController.viewReels(
  //     reelId: widget.reelData.id,
  //     userId: widget.reelData.userId,
  //   );
  // }

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
    reelsScreenController.getReel(
        userId: GlobVar.userId == '' ? null : GlobVar.userId);
     });

    // viewReel();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   reelsScreenController.getReel();
    // if (reelsScreenController.reelsDataModel!.data != null) {
    //   reelsScreenController.allReelsView = List.generate(
    //     reelsScreenController.reelsDataModel!.data!.length,
    //     (index) => reelsScreenController
    //         .reelsDataModel!.data![index].totalViewCount!,
    //   );
    // }
    // });
    // _pickVideo1();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.text = '';
    // _videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("index>>>> ${widget.index}");
    }
    GlobVar.likeUnlikeMessage.length =
        reelsScreenController.reelsDataModel!.data!.length;

    GlobVar.likeReelList.length =
        reelsScreenController.reelsDataModel!.data!.length;

    // log("${reelsScreenController.allReelsView[widget.index]}",
    // name: 'reelsScreenController.allReelsView[widget.index]');
    return
        // Obx(
        //   () => reelsScreenController.isLoading.value == true
        //       ? Center(
        //           child: CircularProgressIndicator(
        //             color: AppColors.white,
        //           ),
        //         )
        //       :  reelsScreenController.reelsDataModel == null
        //               // && (categoryData1 != null || categoryData2 != null || categoryData3 != null)
        //               ? Center(
        //                   child: lable(text: 'No reels available'),
        //                 )
        //               :
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 110),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: widget.reelData.profilePic == ""
                              ? Image.asset(
                                  AppAsstes.user,
                                  height: 30,
                                  width: 30,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.reelData.profilePic,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return const SizedBox();
                                  },
                                  filterQuality: FilterQuality.high,
                                ),
                        ),
                        const SizedBox(width: 6),
                        Text(widget.reelData.userName,
                            style: const TextStyle(
                              color: Colors.grey,
                            )),
                        const SizedBox(width: 7),
                        // Icon(Icons.verified, size: 15, color: AppColors.white),
                        // const SizedBox(width: 6),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: const Text(
                        //     'Follow',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(widget.reelData.description,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                    // const SizedBox(height: 5),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.music_note,
                    //       size: 15,
                    //       color: AppColors.white,
                    //     ),
                    //     Text(
                    //       'Original Audio - some music track--',
                    //       style: TextStyle(
                    //         color: AppColors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (GlobVar.login == true) {
                          selectVideoSource();
                        } else {
                          Get.to(const WitoutLogginScreen(),
                              transition: Transition.downToUp);
                        }
                        // pickVideoAndUploadApi;
                        // final pickedFile =
                        //     await picker.pickVideo(source: ImageSource.gallery);

                        // setState(() {
                        //   if (pickedFile != null) {
                        //     _video = File(pickedFile.path);
                        //   }
                        // });

                        // reelsScreenController.addReelsVideo(video: _video!.path);
                      },
                      child: containerIcon(
                        height: 30,
                        width: 30,
                        icon: Icons.add,
                        containerColor: Colors.grey,
                        iconColor: Colors.white,
                        iconSize: 20,
                      )),
                  const SizedBox(height: 2),

                  Text(
                    "Add",
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Obx(
                    () => reelsScreenController.isLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                if (GlobVar.login == true) {
                                  GlobVar.likeReelList[
                                      widget.index] = (reelsScreenController
                                              .reelsData[widget.index]
                                              .isReelLike) ==
                                          //  GlobVar.likeReelList[widget.index] ==
                                          true
                                      ? false
                                      : true;
                                  if (kDebugMode) {
                                    print(
                                        'GlobVar.likeReelList-----> ${GlobVar.likeReelList}');
                                    print(
                                        'GlobVar.likeReelList.length-----> ${GlobVar.likeReelList.length}');
                                  }
                                  (reelsScreenController
                                              .reelsDataModel!
                                              .data![widget.index]
                                              .isReelLike) ==
                                          //  GlobVar.likeReelList[widget.index] ==
                                          true
                                      ? reelsScreenController
                                          .reelsDataModel!
                                          .data![widget.index]
                                          .isReelLike = false
                                      : reelsScreenController
                                          .reelsDataModel!
                                          .data![widget.index]
                                          .isReelLike = true;
                                  reelsScreenController.likeUnlikeReels(
                                    reelId: reelsScreenController
                                        .reelsDataModel!.data![widget.index].id,
                                  );
                                  reelsScreenController.getReel(
                                      userId: GlobVar.userId);
                                } else {
                                  Get.to(const WitoutLogginScreen(),
                                      transition: Transition.downToUp);
                                }
                              });
                            },
                            child:
                                //  GlobVar.userId != ''
                                //     ?
                                GlobVar.login == false ||
                                       GlobVar.likeReelList[
                                                        widget.index] ==
                                                    false ||   (
                                            // GlobVar.likeUnlikeMessage[
                                            //           GlobVar.reelIndex] ==
                                            //       'reel disliked' ||
                                            // GlobVar.likeReelList[
                                            //             widget.index] ==
                                            //         false ||
                                                reelsScreenController
                                                        .reelsData[widget.index]
                                                        .isReelLike ==
                                                    false)
                                    ? Icon(
                                        Icons.favorite_outline,
                                        color: AppColors.white,
                                      )
                                    : Icon(
                                        Icons.favorite_outlined,
                                        color: AppColors.white,
                                      ),
                            // : Icon(
                            //     Icons.favorite_outline,
                            //     color: AppColors.white,
                            //   ),
                          ),
                  ),
                  // Obx(
                  //   () =>
                  Text(
                    "${reelsScreenController.reelsData[widget.index].totalLikes}",
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  // ),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.remove_red_eye,
                    color: AppColors.white,
                  ),
                  // Obx(
                  //   () =>
                  Text(
                    "${reelsScreenController.reelsData[widget.index].totalViewCount}",
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  // ),
                  // const SizedBox(height: 20),
                  // Transform(
                  //   transform: Matrix4.rotationZ(5.8),
                  //   child: Icon(
                  //     Icons.send,
                  //     color: AppColors.white,
                  //   ),
                  // ),
                  // const SizedBox(height: 30),
                  // Icon(
                  //   Icons.more_vert,
                  //   color: AppColors.white,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
      // ),
    );
  }

  selectVideoSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(300),
            // ),
            content: SizedBox(
              // margin: EdgeInsets.zero,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(30))
              // ),
              height: 100,
              child: Column(
                children: [
                  Container(
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.themeBlueColor,
                    ),
                    height: 50,
                    child: Center(
                      child: Text(
                        "Pick Video",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            color: AppColors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: AppColors.white,
                    ),
                    child: InkWell(
                      onTap: () {
                        _pickVideo();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                             Icon(
                              Icons.storage,
                              color: AppColors.themeBlueColor,
                            ),
                            Container(width: 10.0),
                             Text(
                              'Gallery',
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: AppColors.themeBlueColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     Container(height: 10.0),
            //     Text(
            //       "Pick Video",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //           fontFamily: "Poppins-Medium", color: AppColors.white),
            //     ),
            //     Container(height: 30.0),
            //     InkWell(
            //       onTap: () {
            //         _pickVideo();
            //         Navigator.pop(context);
            //       },
            //       child: Row(
            //         children: <Widget>[
            //            Icon(
            //             Icons.storage,
            //             color: AppColors.white,
            //           ),
            //           Container(width: 10.0),
            //            Text(
            //             'Gallery',
            //             style: TextStyle(
            //           fontFamily: "Poppins-Medium", color: AppColors.white),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            );
      },
    );
  }

  // selectVideoSource() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor:  const Color(0xFF005FF7),
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(8.0),
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Container(height: 10.0),
  //             Text(
  //               "Pick Video",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                   fontFamily: "Poppins-Medium", color: AppColors.white),
  //             ),
  //             Container(height: 30.0),
  //             InkWell(
  //               onTap: () {
  //                 _pickVideo();
  //                 Navigator.pop(context);
  //               },
  //               child: Row(
  //                 children: <Widget>[
  //                    Icon(
  //                     Icons.storage,
  //                     color: AppColors.white,
  //                   ),
  //                   Container(width: 10.0),
  //                    Text(
  //                     'Gallery',
  //                     style: TextStyle(
  //                   fontFamily: "Poppins-Medium", color: AppColors.white),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  _pickVideo() async {
    final video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      // ignore: use_build_context_synchronously
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: false,
      );

      if (compressedVideo != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        setState(() {
          _video = File(compressedVideo.path ?? '');
          if (kDebugMode) {
            print("video------> $_video");
          }
          if (_video != null) {
            // openBottom(_video);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => InstaUploadVideoScreen(video: _video!)));
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => InstaUploadVideoScreen(video: _video!)),
            // );

            setState(() {
              _videoPlayerController.setVolume(0);
              _videoPlayerController.pause();
            });
          }
          _videoPlayerController =
              VideoPlayerController.file(File(compressedVideo.path ?? ''))
                ..initialize().then((_) {
                  setState(() {
                    _videoPlayerController.play();
                  });
                });
        });
      } else {
        debugPrint('error in compressing video from gallery');
      }
    }
  }

  // openBottom(video) {
  //   _videoPlayerController1 = VideoPlayerController.file(video)
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xFF1c1c1e),
  //     enableDrag: false,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 12),
  //         height: 350,
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           physics: const BouncingScrollPhysics(),
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Row(
  //                 children: [
  //                   GestureDetector(
  //                       onTap: () {
  //                         Get.back();
  //                       },
  //                       child: const Icon(
  //                         Icons.arrow_back,
  //                         color: Colors.white,
  //                       )),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   const Text(
  //                     'New Post',
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                   const Spacer(),
  //                   GestureDetector(
  //                     child: const Text('Share',
  //                         style: TextStyle(color: Colors.blue, fontSize: 16.0)),
  //                     onTap: () {
  //                       reelsScreenController.isLoading.value == true
  //                           ? null
  //                           : reelsScreenController.addReelsVideo(
  //                               video: video!.path,
  //                               description: _captionController.text);
  //                       // .then(() {
  //                       print(
  //                           "GlobVar.addPostSuccess-----> ${GlobVar.addPostSuccess}");
  //                       GlobVar.addPostSuccess == "true" ? Get.back() : null;
  //                       // });
  //                       // uploadData();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               Obx(
  //                 () => reelsScreenController.isLoading.value == true
  //                     ? Column(
  //                         children: [
  //                           sizeBoxHeight(Get.height / 2),
  //                           Center(
  //                             child: CircularProgressIndicator(
  //                               color: AppColors.white,
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     : Row(
  //                         children: <Widget>[
  //                           // Padding(
  //                           //   padding: const EdgeInsets.only(top: 12.0, left: 12.0),
  //                           //   child: Container(
  //                           //     width: 80.0,
  //                           //     height: 80.0,
  //                           //     decoration: BoxDecoration(
  //                           //         image: DecorationImage(
  //                           //             fit: BoxFit.cover,
  //                           //             image: FileImage(widget.image[0]))),
  //                           //   ),
  //                           // ),
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.only(top: 12.0, left: 12.0),
  //                             child: SizedBox(
  //                               width: 80.0,
  //                               height: 80.0,
  //                               child: video != null
  //                                   ? _videoPlayerController1
  //                                           .value.isInitialized
  //                                       ? AspectRatio(
  //                                           aspectRatio: _videoPlayerController1
  //                                               .value.aspectRatio,
  //                                           child: VideoPlayer(
  //                                               _videoPlayerController1),
  //                                         )
  //                                       // ignore: avoid_unnecessary_containers
  //                                       : Container(child: const Text("Null"))
  //                                   : GestureDetector(
  //                                       onTap: () {
  //                                         // _pickVideo1() {
  //                                           _videoPlayerController1 =
  //                                               VideoPlayerController.file(
  //                                                   video)
  //                                                 ..initialize().then((_) {
  //                                                   setState(() {});
  //                                                   _videoPlayerController1
  //                                                       .play();
  //                                                 });
  //                                         // }

  //                                         // ;
  //                                       },
  //                                       child: const CircleAvatar(
  //                                           radius: 50,
  //                                           backgroundImage: AssetImage(
  //                                               'assets/images/ic_add.png'),
  //                                           backgroundColor:
  //                                               Colors.transparent),
  //                                     ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(
  //                                   left: 12.0, right: 8.0),
  //                               child: TextField(
  //                                 controller: _captionController,
  //                                 maxLines: 3,
  //                                 style: TextStyle(color: AppColors.white),
  //                                 keyboardType: TextInputType.multiline,
  //                                 decoration: InputDecoration(
  //                                   hintText: 'Write a caption...',
  //                                   hintStyle:
  //                                       TextStyle(color: AppColors.white),
  //                                 ),
  //                                 // onChanged: ((value) {
  //                                 //   _captionController.text = value;
  //                                 // }),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  //  _pickVideo1() async {
  //   // File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
  //   //  widget.video = video;
  //   // final video = await picker.pickVideo(source: ImageSource.gallery);
  //   _videoPlayerController1 = VideoPlayerController.file(File(video!.path))
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _videoPlayerController1.play();
  //     });
  // }

  void indicatorDialog(BuildContext context) {
    showDialog(
      //  barrierColor: AppColors.backgroundColor,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          heightFactor: 14,
          child: CircularProgressIndicator(
            color: AppColors.white,
          ),
        );
      },
    );
  }
}
