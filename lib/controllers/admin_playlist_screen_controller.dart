import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/admin_playlist_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminPlaylistScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  var isLoading = false.obs;
  AdminPlaylistModel? adminPlaylistModel;
  var adminPlaylistData = [].obs;

  @override
  void onInit() {
    adminPlaylists();
    super.onInit();
  }

  Future<void> adminPlaylists() async {
    try {
      isLoading.value = true;
      final albumListJson = await apiHelper.adminPlaylistList();
      adminPlaylistModel = AdminPlaylistModel.fromJson(albumListJson);
      adminPlaylistData.value = adminPlaylistModel!.data!;
      log('adminPlaylistData ----> $adminPlaylistData');
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