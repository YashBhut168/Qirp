import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DownloadSongScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  AllSongsListModel? allSongsListModel;
  var isLoading = false.obs;
  var isLikeDownloadData = [].obs;

  Future<void> downloadSongsList() async {
    try {
      isLoading.value = true;
      final downloadSongListDataModelJson = await apiHelper.downloadSongsList();

      allSongsListModel =
          AllSongsListModel.fromJson(downloadSongListDataModelJson);
      isLikeDownloadData.value = allSongsListModel!.data!;
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoading.value = false;

    } finally {
      isLoading.value = false;
    }
  }
}
