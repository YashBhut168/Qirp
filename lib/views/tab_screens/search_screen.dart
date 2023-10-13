
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_screen_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  @override
  void initState() {
    super.initState();
    controller.isMiniPlayerOpenDownloadSongs.value == true ||
    controller.isMiniPlayerOpen.value == true ||
            controller.isMiniPlayerOpenHome1.value == true ||
            controller.isMiniPlayerOpenHome2.value == true ||
            controller.isMiniPlayerOpenHome3.value == true ||
            controller.isMiniPlayerOpenAllSongs.value == true
        ? controller.audioPlayer.play()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text('Search Screen'),
      ),
    );
  }
}
