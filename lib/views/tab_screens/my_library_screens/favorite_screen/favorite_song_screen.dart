import 'package:edpal_music_app_ui/controllers/favorite_song_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteSongsScreen extends StatefulWidget {
  const FavoriteSongsScreen({super.key});

  @override
  State<FavoriteSongsScreen> createState() => _FavoriteSongsScreenState();
}

class _FavoriteSongsScreenState extends State<FavoriteSongsScreen> {

  FavoriteSongScreenController favoriteSongScreenController = Get.put(FavoriteSongScreenController());

  @override
  void initState() {
    super.initState();
    favoriteSongScreenController.favoriteSongsList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: lable(
          text: AppStrings.favoriteSongs,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => favoriteSongScreenController.isLoading.value == true 
        // &&
        //         downloadSongScreenController.allSongsListModel == null
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : favoriteSongScreenController.allSongsListModel == null ? Center(child: lable(text: 'No Favorites'),) : SingleChildScrollView(
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
                          itemCount: favoriteSongScreenController
                              .allSongsListModel!.data!.length,
                          itemBuilder: (context, index) {
                            var favoriteSongListData =
                                favoriteSongScreenController
                                    .allSongsListModel!.data![index];
                           

                            return ListTile(
                              onTap: () async {
                              },
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -1),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.network(
                                  (favoriteSongListData.image) ??
                                      'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                  height: 70,
                                  width: 70,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                              title: lable(
                                text: (favoriteSongListData.title)!,
                                fontSize: 12,
                              ),
                              subtitle: lable(
                                text: (favoriteSongListData.description)!,
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}