 // ignore_for_file: file_names

// import 'dart:io';
// import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/globVar.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// import '../../../../controllers/reels_screen_controller.dart';

// // ignore: must_be_immutable
// class InstaUploadVideoScreen extends StatefulWidget {
//   File? video;

//   InstaUploadVideoScreen({super.key, this.video});

//   @override
//   // ignore: library_private_types_in_public_api
//   _InstaUploadVideoScreenState createState() => _InstaUploadVideoScreenState();
// }

// class _InstaUploadVideoScreenState extends State<InstaUploadVideoScreen> {
//   ReelsScreenController reelsScreenController =
//       Get.put(ReelsScreenController());
//   MainScreenController mainScreenController = Get.put(MainScreenController());

//   // ignore: prefer_typing_uninitialized_variables
//   var _locationController;
//   // ignore: prefer_typing_uninitialized_variables
//   late TextEditingController _captionController;
//   late VideoPlayerController _videoPlayerController;

//   @override
//   void initState() {
//     if (kDebugMode) {
//       print('^^^^^^^^^^^^^^^^^^^^');
//     }
//     if (kDebugMode) {
//       print(widget.video);
//     }
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _showBottomSheet(context);
//     // });
//     _pickVideo();

//     super.initState();
//     _locationController = TextEditingController();
//     _captionController = TextEditingController();
//   }

//   _pickVideo() async {
//     // File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
//     //  widget.video = video;
//     setState(() {
//       _videoPlayerController = VideoPlayerController.file(widget.video!)
//         ..initialize().then((_) {
//           setState(() {});
//           _showBottomSheet(context);
//           _videoPlayerController.play();
//         });
//     });
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _locationController?.dispose();
//     _captionController.text = '';
//   }

//   // ignore: prefer_final_fields
//   // bool _visibility = true;

//   // void _changeVisibility(bool visibility) {
//   //   setState(() {
//   //     _visibility = visibility;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // _showBottomSheet(context);
//     return Container();

//     // Scaffold(
//     //   backgroundColor: AppColors.backgroundColor,
//     //   // appBar: AppBar(
//     //   //   backgroundColor: AppColors.backgroundColor,
//     //   //   title: lable(
//     //   //     text: 'New Post',
//     //   //     fontWeight: FontWeight.bold,
//     //   //     fontSize: 16,
//     //   //   ),

//     //   //   // Text(
//     //   //   //   'New Post',
//     //   //   //   style: TextStyle(
//     //   //   //       fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//     //   //   // ),
//     //   //   iconTheme: IconThemeData(color: AppColors.white),
//     //   //   // backgroundColor: new Color(0xfff8faf8),
//     //   //   elevation: 1.0,
//     //   //   actions: <Widget>[
//     //   //     Padding(
//     //   //       padding: const EdgeInsets.only(
//     //   //         right: 20.0,
//     //   //       ),
//     //   //       child: GestureDetector(
//     //   //         child: const Text('Share',
//     //   //             style: TextStyle(color: Colors.blue, fontSize: 16.0)),
//     //   //         onTap: () {
//     //   //          reelsScreenController.isLoading.value == true ? null :
//     //   //           reelsScreenController
//     //   //               .addReelsVideo(
//     //   //                   video: widget.video!.path,
//     //   //                   description: _captionController.text);
//     //   //               // .then(() {
//     //   //                 print("GlobVar.addPostSuccess-----> ${GlobVar.addPostSuccess}");
//     //   //             GlobVar.addPostSuccess == "true" ? Get.back() : null;
//     //   //           // });
//     //   //           // uploadData();
//     //   //         },
//     //   //       ),
//     //   //     )
//     //   //   ],
//     //   // ),
//     //   body:

//     //   GestureDetector(
//     //     onTap: () => FocusScope.of(context).unfocus(),
//     //     child: SingleChildScrollView(
//     //       child: Obx(
//     //         () => reelsScreenController.isLoading.value == true
//     //             ? Column(
//     //               children: [
//     //                 sizeBoxHeight(Get.height/2),
//     //                 Center(
//     //                     child: CircularProgressIndicator(
//     //                       color: AppColors.white,
//     //                     ),
//     //                   ),
//     //               ],
//     //             )
//     //             : Column(
//     //                 children: <Widget>[
//     //                   Row(
//     //                     children: <Widget>[
//     //                       // Padding(
//     //                       //   padding: const EdgeInsets.only(top: 12.0, left: 12.0),
//     //                       //   child: Container(
//     //                       //     width: 80.0,
//     //                       //     height: 80.0,
//     //                       //     decoration: BoxDecoration(
//     //                       //         image: DecorationImage(
//     //                       //             fit: BoxFit.cover,
//     //                       //             image: FileImage(widget.image[0]))),
//     //                       //   ),
//     //                       // ),
//     //                       Padding(
//     //                         padding: const EdgeInsets.only(
//     //                             top: 12.0, left: 12.0),
//     //                         child: SizedBox(
//     //                           width: 80.0,
//     //                           height: 80.0,
//     //                           child: widget.video != null
//     //                               ? _videoPlayerController
//     //                                       .value.isInitialized
//     //                                   ? AspectRatio(
//     //                                       aspectRatio:
//     //                                           _videoPlayerController
//     //                                               .value.aspectRatio,
//     //                                       child: VideoPlayer(
//     //                                           _videoPlayerController),
//     //                                     )
//     //                                   // ignore: avoid_unnecessary_containers
//     //                                   : Container(child: const Text("Null"))
//     //                               : GestureDetector(
//     //                                   onTap: () {
//     //                                     _pickVideo();
//     //                                   },
//     //                                   child: const CircleAvatar(
//     //                                       radius: 50,
//     //                                       backgroundImage: AssetImage(
//     //                                           'assets/images/ic_add.png'),
//     //                                       backgroundColor:
//     //                                           Colors.transparent),
//     //                                 ),
//     //                         ),
//     //                       ),
//     //                       Expanded(
//     //                         child: Padding(
//     //                           padding: const EdgeInsets.only(
//     //                               left: 12.0, right: 8.0),
//     //                           child: TextField(
//     //                             controller: _captionController,
//     //                             maxLines: 3,
//     //                             style: TextStyle(color: AppColors.white),
//     //                             keyboardType: TextInputType.multiline,
//     //                             decoration: InputDecoration(
//     //                               hintText: 'Write a caption...',
//     //                               hintStyle:
//     //                                   TextStyle(color: AppColors.white),
//     //                             ),
//     //                             // onChanged: ((value) {
//     //                             //   _captionController.text = value;
//     //                             // }),
//     //                           ),
//     //                         ),
//     //                       )
//     //                     ],
//     //                   ),
//     //                   Padding(
//     //                     padding: const EdgeInsets.all(20.0),
//     //                     child: TextField(
//     //                       controller: _locationController,
//     //                       // onChanged: ((value) {
//     //                       //   setState(() {
//     //                       //     _locationController.text = value;
//     //                       //   });
//     //                       // }),
//     //                       style: TextStyle(color: AppColors.white),

//     //                       decoration: InputDecoration(
//     //                         hintText: 'Add location',
//     //                         hintStyle: TextStyle(color: AppColors.white),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                   /*   Padding(
//     //             padding: const EdgeInsets.only(left: 12.0),
//     //             child: FutureBuilder(
//     //                 future: locateUser(),
//     //                 builder: ((context, AsyncSnapshot<List<Address>> snapshot) {
//     //                   //  if (snapshot.hasData) {
//     //                   if (snapshot.hasData) {
//     //                     return Row(
//     //                       // alignment: WrapAlignment.start,
//     //                       children: <Widget>[
//     //                         GestureDetector(
//     //                           child: Chip(
//     //                             label: Text(snapshot.data.first.locality),
//     //                           ),
//     //                           onTap: () {
//     //                             setState(() {
//     //                               _locationController.text =
//     //                                   snapshot.data.first.locality;
//     //                             });
//     //                           },
//     //                         ),
//     //                         Padding(
//     //                           padding: const EdgeInsets.only(left: 12.0),
//     //                           child: GestureDetector(
//     //                             child: Chip(
//     //                               label: Text(snapshot.data.first.subAdminArea +
//     //                                   ", " +
//     //                                   snapshot.data.first.subLocality),
//     //                             ),
//     //                             onTap: () {
//     //                               setState(() {
//     //                                 _locationController.text =
//     //                                     snapshot.data.first.subAdminArea +
//     //                                         ", " +
//     //                                         snapshot.data.first.subLocality;
//     //                               });
//     //                             },
//     //                           ),
//     //                         ),
//     //                       ],
//     //                     );
//     //                   } else {
//     //                     print("Connection State : ${snapshot.connectionState}");
//     //                     return CircularProgressIndicator();
//     //                   }
//     //                 })),
//     //           ), */
//     //                   Padding(
//     //                     padding: const EdgeInsets.only(top: 50.0),
//     //                     child: Offstage(
//     //                       offstage: _visibility,
//     //                       child: const CircularProgressIndicator(),
//     //                     ),
//     //                   )
//     //                 ],
//     //               ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }

//   void _showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1c1c1e),
//       enableDrag: false,
//       isScrollControlled: true,
//       isDismissible: false,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           height: 350,
//           child: Obx(
//             () => reelsScreenController.isLoading.value == true
//                 ?
//                 // Column(
//                 //     children: [
//                 //       sizeBoxHeight(100),
//                 Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.white,
//                     ),
//                   )
//                 //   ],
//                 // )
//                 : SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       children: [
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             GestureDetector(
//                                 onTap: () {
//                                   mainScreenController.currentIndex.value = 2;
//                                   Get.offAll(MainScreen());
//                                 },
//                                 child: const Icon(
//                                   Icons.arrow_back,
//                                   color: Colors.white,
//                                 )),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             const Text(
//                               'New Post',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               child: const Text('Share',
//                                   style: TextStyle(
//                                       color: Colors.blue, fontSize: 16.0)),
//                               onTap: () {
//                                 reelsScreenController.isLoading.value == true
//                                     ? null
//                                     : reelsScreenController.addReelsVideo(
//                                         video: widget.video!.path,
//                                         description: _captionController.text);

//                                         reelsScreenController.getReel(userId: GlobVar.userId);
//                                 // .then(() {
//                                 if (kDebugMode) {
//                                   print(
//                                       "GlobVar.addPostSuccess-----> ${GlobVar.addPostSuccess}");
//                                 }
//                                 mainScreenController.currentIndex.value = 2;
//                                 // GlobVar.addPostSuccess == "true"
//                                 // ?
//                                 Get.offAll(MainScreen());
//                                 // : ;
//                                 // });
//                                 // uploadData();
//                               },
//                             ),
//                           ],
//                         ),
//                         sizeBoxHeight(10),
//                         Row(
//                           children: <Widget>[
//                             // Padding(
//                             //   padding: const EdgeInsets.only(top: 12.0, left: 12.0),
//                             //   child: Container(
//                             //     width: 80.0,
//                             //     height: 80.0,
//                             //     decoration: BoxDecoration(
//                             //         image: DecorationImage(
//                             //             fit: BoxFit.cover,
//                             //             image: FileImage(widget.image[0]))),
//                             //   ),
//                             // ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 12.0, left: 12.0),
//                               child: SizedBox(
//                                 width: 80.0,
//                                 height: 80.0,
//                                 child: widget.video != null
//                                     ? _videoPlayerController.value.isInitialized
//                                         ? AspectRatio(
//                                             aspectRatio: _videoPlayerController
//                                                 .value.aspectRatio,
//                                             child: VideoPlayer(
//                                                 _videoPlayerController),
//                                           )
//                                         // ignore: avoid_unnecessary_containers
//                                         : Container(child: const Text("Null"))
//                                     : GestureDetector(
//                                         onTap: () {
//                                           _pickVideo();
//                                         },
//                                         child: const CircleAvatar(
//                                             radius: 50,
//                                             backgroundImage: AssetImage(
//                                                 'assets/images/ic_add.png'),
//                                             backgroundColor:
//                                                 Colors.transparent),
//                                       ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 12.0, right: 8.0),
//                                 child: TextField(
//                                   controller: _captionController,
//                                   maxLines: 3,
//                                   style: TextStyle(color: AppColors.white),
//                                   keyboardType: TextInputType.multiline,
//                                   decoration: InputDecoration(
//                                     hintText: 'Write a caption...',
//                                     hintStyle:
//                                         TextStyle(color: AppColors.white),
//                                   ),
//                                   // onChanged: ((value) {
//                                   //   _captionController.text = value;
//                                   // }),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
