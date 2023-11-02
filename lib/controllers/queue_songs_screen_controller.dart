import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class QueueSongsScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  AllSongsListModel? allSongsListModel;
  RxBool isLoading = false.obs;
  var isLikeQueueData = [].obs;


  Future<void> queueSongsListWithoutPlaylist() async {
    try {
    isLoading.value = true;
      final queueSongListDataModelJson = await apiHelper.queueSongsListWithoutPlaylist();

      allSongsListModel =
          AllSongsListModel.fromJson(queueSongListDataModelJson);
      
      isLikeQueueData.value = allSongsListModel!.data!;
      isLoading.value = false;
    } catch (e) {
        // isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

}