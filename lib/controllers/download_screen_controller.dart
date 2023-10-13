import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DownloadSongScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  AllSongsListModel? allSongsListModel;
  RxBool isLoading = false.obs;


  Future<void> downloadSongsList() async {
    try {
    isLoading.value = true;
      final downloadSongListDataModelJson = await apiHelper.downloadSongsList();

      allSongsListModel =
          AllSongsListModel.fromJson(downloadSongListDataModelJson);
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
    }
  }
}