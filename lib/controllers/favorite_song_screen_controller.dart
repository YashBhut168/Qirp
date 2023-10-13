import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FavoriteSongScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  AllSongsListModel? allSongsListModel;
  RxBool isLoading = false.obs;


  Future<void> favoriteSongsList() async {
    isLoading.value = true;
    try {
      final favoriteSongListDataModelJson = await apiHelper.favoriteSongsList();

      allSongsListModel =
          AllSongsListModel.fromJson(favoriteSongListDataModelJson);
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
    }
  }

}