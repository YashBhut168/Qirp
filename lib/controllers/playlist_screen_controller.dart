import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/admin_playlist_song_model.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
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
  RxString currentPlayingTitle = RxString('');
  RxString currentPlayingImage = RxString('');
  RxString currentPlayingDesc = RxString('');
  RxString currentPlayingAdminTitle = RxString('');
  RxString currentPlayingAdminImage = RxString('');
  RxString currentPlayingAdminDesc = RxString('');


  // RxBool isPlaylistSongsEmpty = false.obs;

  @override
  void onInit() {
    songsInPlaylist(playlistId: GlobVar.playlistId);
    super.onInit();
  }

  AllSongsListModel? allSongsListModel;
  AdminPlaylistSongModel? adminPlaylistSongModel;

  Future<void> songsInPlaylist({required String playlistId}) async {
    try {
      isLoading.value = true;
      final allSongsListModelJson = GlobVar.login == false ? await apiHelper.noAuthSongsInPlaylist (playlistId) : await apiHelper.songsInPlaylist(playlistId);
      GlobVar.adminPlaylistTapped == 'false'
          ? allSongsListModel =
              AllSongsListModel.fromJson(allSongsListModelJson)
          : adminPlaylistSongModel =
              AdminPlaylistSongModel.fromJson(allSongsListModelJson);
      isLikePlaylistData.value = GlobVar.adminPlaylistTapped == 'false'
          ? allSongsListModel!.data!
          : adminPlaylistSongModel!.data!;
      isLoading.value = false;
      log('$allSongsListModelJson', name: 'allSongsListModelJson');
      //  isLikePlaylistData.isEmpty
      //                                   ? isPlaylistSongsEmpty.value = true
      //                                   : isPlaylistSongsEmpty.value = false;
      //                       log('${isPlaylistSongsEmpty.value}',
      //                                   name:
      //                                       "playlistScreenController.isPlaylistSongsEmpty.value");
      playlistSongAudioUrls.assignAll(
          allSongsListModel!.data!.map((item) => item.audio.toString()));

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

  Future<void> removeSongsFromPlaylist(
      {required String musicId, required String playlistId}) async {
    try {
      isLoading.value = true;
      final response =
          await apiHelper.removeSongsFromPlaylist(musicId, playlistId);
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

  Future<void> addQueueSong({String? musicId, String? playlistId}) async {
    try {
      isLoading.value = true;
      final response =
          await apiHelper.addQueueSong(musicId: musicId, playlisId: playlistId);
      if (kDebugMode) {
        print(response);
      }
      // success = response['success'];
    } catch (e) {
      if (kDebugMode) {
        print('queue song failed: $e');
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
      if (data != null) {
        // queueAudioUrls.assignAll(data.map((item) => item['audio'].toString()));
        // queueSongIds.assignAll(data.map((item) => item['id'].toString()));
      }
      success = response['success'] ?? '';
      message.value = response['message'] ?? '';
      log("${response['message']}", name: 'message');
      log("${response['success']}", name: 'success');
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
