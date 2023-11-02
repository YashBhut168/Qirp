
import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PlaylistScreenController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  final RxBool isLoading = false.obs;
  RxDouble downloadProgress = 0.0.obs;
  RxInt index = 0.obs;
  RxBool downloading = false.obs;
  // RxList<String> queueAudioUrls = <String>[].obs;
  RxList<String> playlistSongAudioUrls = <String>[].obs;
  // RxList<String> queueSongIds = <String>[].obs;
  // RxBool isQueueItemExists  = false.obs;
  // RxBool isQueue = false.obs;
  // RxBool addToQueue = false.obs;
  String success = '';
  RxString message = RxString('');
  var isLikePlaylistData = [].obs;


  AllSongsListModel? allSongsListModel;

  Future<void> songsInPlaylist({required String playlistId}) async {
    try {
    isLoading.value = true;
      final allSongsListModelJson = await apiHelper.songsInPlaylist(playlistId);

      allSongsListModel = AllSongsListModel.fromJson(allSongsListModelJson);
      isLikePlaylistData.value = allSongsListModel!.data!;
      isLoading.value = false;


      playlistSongAudioUrls.assignAll(allSongsListModel!.data!.map((item) => item.audio.toString()));
      
      // isQueue.value = (allSongsListModel!.data![index.value].is_queue) ?? false;
      if (kDebugMode) {
        print('isQueue::::${allSongsListModel!.data![index.value].is_queue}');
      }


    } catch (e) {
        isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeSongsFromPlaylist({required String musicId, required String playlistId}) async {
    try {
      isLoading.value = true;
      final response = await apiHelper.removeSongsFromPlaylist(musicId,playlistId);
      if (kDebugMode) {
        print(response['success']);
      }
      // success = response['success'];
    } catch (e) {
      if (kDebugMode) {
        print('remove song failed: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addQueueSong({String? musicId,String? playlistId}) async {
    try {
      isLoading.value = true;
      final response = await apiHelper.addQueueSong(musicId: musicId,playlisId: playlistId);
      if (kDebugMode) {
        print(response['success']);
      }
      // success = response['success'];
    } catch (e) {
      if (kDebugMode) {
        print('remove song failed: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

    queueSongsList({String? playlistId}) async {
    try {
      isLoading.value = true;
      final response = await apiHelper.queueSongsList(playlisId: playlistId);
      if (kDebugMode) {
        print(response['success']);
      }
      final List<dynamic>? data = response['data'];
    //   if (data != null && data is List<dynamic>) {
    //   queueAudioUrls.assignAll(data.map((item) => item['audio'].toString()));
    //   queueSongIds.assignAll(data.map((item) => item['id'].toString()));
    // } else {
    //   print('queque song list fetch failed: Data is null or not a List<dynamic>.');
    // }
    if(data != null){

      // queueAudioUrls.assignAll(data.map((item) => item['audio'].toString()));
      // queueSongIds.assignAll(data.map((item) => item['id'].toString()));
    }
      success = response['success'] ?? '';
      message.value = response['message'] ?? '';
      log("${response['message']}",name: 'message');
      log("${response['success']}",name: 'success');
    } catch (e) {
      if (kDebugMode) {
        print('queque song list fetch failed: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateDownloadProgress(double progress) {
    downloadProgress.value = progress;
  }
}
