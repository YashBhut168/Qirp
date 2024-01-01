import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/search_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  var isLoading = false.obs;
  var allSearchData = [].obs;
  RxString currentPlayingTitle = RxString('');
  RxString currentPlayingImage = RxString('');
  RxString currentPlayingDesc = RxString('');
  // RxString currentPlayingId = RxString('');
  // RxString currentPlayingAudio = RxString('');
  // RxBool currentPlayingIsLiked = false.obs;
  // RxBool currentPlayingIsQueue = false.obs;


  @override
  void onInit() {
    super.onInit();
    allSearchList(searchText: GlobVar.searchText);
  }

  AllSearchModel? allSearchModel;
  Future<void> allSearchList({required String searchText}) async {
    try {
      isLoading.value = true;
      final allSearchListModelJson = await apiHelper.allSearches(searchText);

      allSearchModel = AllSearchModel.fromJson(allSearchListModelJson);
      allSearchData.value = allSearchModel!.data!;
      isLoading.value = false;
      if (kDebugMode) {
        print('allSearchData::::$allSearchListModelJson');
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }
}