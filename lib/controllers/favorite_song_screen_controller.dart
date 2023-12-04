import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FavoriteSongScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  AllSongsListModel? allSongsListModel;
  RxBool isLoading = false.obs;
  var isLikeFavData = [].obs;


  @override
  void onInit() {
    favoriteSongsList();
    super.onInit();
  }

  Future<void> favoriteSongsList() async {
    try {
    isLoading.value = true;
      final favoriteSongListDataModelJson = await apiHelper.favoriteSongsList();

      allSongsListModel =
          AllSongsListModel.fromJson(favoriteSongListDataModelJson);
      isLikeFavData.value =  allSongsListModel!.data!;
      
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
    }
     isLoading.value = false;
  }

}