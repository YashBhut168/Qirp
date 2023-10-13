// import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Handler extends WidgetsBindingObserver {

//    final MainScreenController controller =
//       Get.put(MainScreenController(initialIndex: 0));
//     @override
//     void didChangeAppLifecycleState(AppLifecycleState state) {
//       if (state == AppLifecycleState.resumed) {
//           (controller.audioPlayer)!.dispose();
//        } else {
//         (controller.audioPlayer!).pause();
//        }
//      }
//   }