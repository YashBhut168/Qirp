import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/add_songs_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LookingForSongsScreen extends StatefulWidget {
  final String playlistTitle;
  final Data myPlaylistData;
  const LookingForSongsScreen({
    super.key,
    required this.playlistTitle,
    required this.myPlaylistData,
  });

  @override
  State<LookingForSongsScreen> createState() => _LookingForSongsScreenState();
}

class _LookingForSongsScreenState extends State<LookingForSongsScreen> {
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 16,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      detailScreenController.fetchMyPlaylistData();
                      Get.back();
                    },
                  ),
                ),
                sizeBoxHeight(310),
                lable(
                  text: AppStrings.lookingForSongs,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                sizeBoxHeight(6),
                lable(
                  text: AppStrings.letsBuildYourNewPlaylists,
                  fontSize: 11,
                  color: Colors.grey,
                ),
                sizeBoxHeight(25),
                ElevatedButton(
                  onPressed: () {
                    allSongsScreenController.isChecked = List<bool>.generate(
                      allSongsScreenController.allSongsListModel!.data!.length,
                      (index) => false,
                    );
                    Get.to(
                      AddSongsScreen(
                        myPlaylistId: (widget.myPlaylistData.id)!,
                        playlistTitle: widget.playlistTitle,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ac5b3),
                  ),
                  child: lable(
                    text: AppStrings.addSongs,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
