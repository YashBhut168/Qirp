import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Handler extends WidgetsBindingObserver {
  MainScreenController controller = Get.put(MainScreenController());
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (
    //   state == AppLifecycleState.hidden ||
    //     state == AppLifecycleState.resumed ||
    //     state == AppLifecycleState.detached ||
    //     state == AppLifecycleState.inactive
    //     ) {
    //   controller.audioPlayer.play();
    // } else
     if (state == AppLifecycleState.detached){
      controller.audioPlayer.stop();
    } 
    // else {
    //   controller.audioPlayer.stop();
    // }
  }
}
