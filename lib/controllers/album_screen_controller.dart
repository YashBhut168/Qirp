import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/album_model.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AlbumScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  AlbumModel? albumModel;
  RxString currentPlayingTitle = RxString('');
  RxString currentPlayingImage = RxString('');
  RxString currentPlayingDesc = RxString('');
  RxString currentPlayingId = RxString('');
  var isLoading = false.obs;
  var albumData = [].obs;
  var albumSongsData = [].obs;

  @override
  void onInit() {
    albumList();
    super.onInit();
  }

  Future<void> albumList() async {
    try {
      isLoading.value = true;
      final albumListJson = await apiHelper.albumLists();

      albumModel = AlbumModel.fromJson(albumListJson);
      albumData.value = albumModel!.data!;
      // log('artistsData ----> $albumListJson');
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

  AllSongsListModel? allSongsListModel;

  Future<void> albumsSongsList({required String albumId}) async {
    try {
      isLoading.value = true;
      final allSongsListModelJson = GlobVar.login == false ? await apiHelper.noAuthlbumSongsList(albumId) : await apiHelper.albumSongsList(albumId);
      log('$allSongsListModelJson',name: 'albumSongsData');
      allSongsListModel = AllSongsListModel.fromJson(allSongsListModelJson);
      albumSongsData.value = allSongsListModel!.data!;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
