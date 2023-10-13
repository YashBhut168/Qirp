// // import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
// import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
// // import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// // import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddPlaylistScreen extends StatefulWidget {
//   const AddPlaylistScreen({super.key});

//   @override
//   State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
// }

// class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
//   DetailScreenController detailScreenController =
//       Get.put(DetailScreenController());

//   @override
//   void initState() {
//     super.initState();
//     detailScreenController.fetchMyPlaylistData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         leading: Icon(
//           Icons.menu,
//           color: AppColors.white,
//         ),
//         title: lable(
//             text: AppStrings.ownPlaylist,
//             fontSize: 18,
//             letterSpacing: 0.5,
//             fontWeight: FontWeight.w600),
//         centerTitle: true,
//       ),
//       body: Obx(
//         () => detailScreenController.isLoading.value == true
//             ? Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.white,
//                 ),
//               )
//             : SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                   ),
//                   child: Column(
//                     children: [
//                       sizeBoxHeight(20),
//                       GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 200,
//                             // childAspectRatio: 83 / 81,
//                             childAspectRatio: 83 / 81,
//                             crossAxisSpacing: 5,
//                             mainAxisSpacing: 10,
//                           ),
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: detailScreenController
//                               .myPlaylistDataModel!.data!.length,
//                           itemBuilder: (context, index) {
//                             var myPlaylistData = detailScreenController
//                                 .myPlaylistDataModel!.data![index];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     color: Colors.grey,
//                                     height: 120,
//                                     width: 120,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(Icons.music_note,size: 40,),
//                                         lable(text: (myPlaylistData.plTitle)!,color: Colors.black),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 sizeBoxHeight(3),
//                                 lable(
//                                   text:
//                                       "${(myPlaylistData.tracks)!} • ${AppStrings.tracks}",
//                                 ),
//                               ],
//                             );
//                           })
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
