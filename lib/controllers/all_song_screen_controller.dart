import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AllSongsScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  RxBool isLoading = false.obs;

  final List<int> selectedSongIndices = [];
  List<bool>? isChecked;

  var isLikeAllSongData = [].obs;
  List<String> filteredAllSongsTitles = [];
  List<String> filteredAllSongsDesc = [];
  List<String> filteredAllSongsImage = [];
  List<String> filteredAllSongsAudios = [];
  List<String> filteredAllSongsIds = [];
  List<bool> filteredAllSongsLikes = [];
  List<bool> filteredAllSongsQueues = [];
  List<String> allSongTitles = [];
  List<String> allSongDescs = [];
  List<String> allSongImages = [];
  List<String> allSongAudios = [];
  List<String> allSongIds = [];
  List<bool> allSongLikes = [];
  List<bool> allSongQueues = [];

  @override
  void onInit() {
    super.onInit();
    allSongsList();
    log("$filteredAllSongsTitles", name: 'filteredAllSongsTitles');
  }

  AllSongsListModel? allSongsListModel;
  Future<void> allSongsList({checkedIds}) async {
    try {
      isLoading.value = true;
      final myPlaylistDataModelJson = GlobVar.login == false
          ? await apiHelper.noAuthAllSongsList()
          : await apiHelper.allSongsList();

      allSongsListModel = AllSongsListModel.fromJson(myPlaylistDataModelJson);
      if (kDebugMode) {
        print('myPlaylistDataModelJson---->$myPlaylistDataModelJson');
      }

      isLikeAllSongData.value = allSongsListModel!.data!;

      // filterd data
      allSongTitles = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].title!,
      );
      allSongImages = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].image!,
      );
      allSongIds = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].id!,
      );
      allSongAudios = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].audio!,
      );
      allSongDescs = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].description!,
      );
     
      // allSongDescs =
      //     allSongsListModel!.data!.map((e) => e.description!).toList();
      // allSongImages = allSongsListModel!.data!.map((e) => e.image!).toList();
      // allSongAudios = allSongsListModel!.data!.map((e) => e.audio!).toList();
      // allSongIds = allSongsListModel!.data!.map((e) => e.id!).toList();
      // allSongLikes = allSongsListModel!.data!.map((e) => e.isLiked!).toList();
      // allSongQueues = allSongsListModel!.data!.map((e) => e.is_queue!).toList();
      // filteredAllSongsTitles = List.generate(
      //   isLikeAllSongData.length,
      //   (index) => (isLikeAllSongData[index].title) ?? '',
      // );
      // filteredAllSongsIds = List.generate(
      //   isLikeAllSongData.length,
      //   (index) => (isLikeAllSongData[index].id) ?? '',
      // );
      // filteredAllSongsAudios = List.generate(
      //   isLikeAllSongData.length,
      //   (index) => (isLikeAllSongData[index].audio) ?? '',
      // );
      // filteredAllSongsDesc = List.generate(
      //   isLikeAllSongData.length,
      //   (index) => (isLikeAllSongData[index].description) ?? '',
      // );
      // filteredAllSongsImage = List.generate(isLikeAllSongData.length,
      //     (index) => (isLikeAllSongData[index].image) ?? '');
      filteredAllSongsTitles = allSongTitles;
      filteredAllSongsDesc = allSongDescs;
      filteredAllSongsImage = allSongImages;
      filteredAllSongsAudios = allSongAudios;
      filteredAllSongsIds = allSongIds;

       allSongLikes = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].isLiked!,
      );
      allSongQueues = 
      List.generate(
        isLikeAllSongData.length,
        (index) => isLikeAllSongData[index].is_queue!,
      );


      filteredAllSongsLikes = allSongLikes;
      filteredAllSongsQueues = allSongQueues;

      log("$filteredAllSongsTitles", name: 'filteredAllSongsTitles');

      isChecked = List<bool>.generate(
        allSongsListModel!.data!.length,
        (index) =>
            checkedIds
                ?.contains(int.parse(allSongsListModel!.data![index].id!)) ??
            false,
      );
      // void initChecked() {
      //   isChecked = [];
      // }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading.value = false;
  }

  filterAllSonglistTitles(String query) {
    if (query.isEmpty) {
      filteredAllSongsTitles = allSongTitles;
      log('$filteredAllSongsTitles', name: 'filteredAllSongsTitles');
      filteredAllSongsDesc = allSongDescs;
      filteredAllSongsImage = allSongImages;
      filteredAllSongsIds = allSongIds;
      filteredAllSongsAudios = allSongAudios;
      filteredAllSongsLikes = allSongLikes;
      filteredAllSongsQueues = allSongQueues;
    } else {
      filteredAllSongsTitles = allSongTitles
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredAllSongsDesc = allSongDescs
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
      filteredAllSongsImage = allSongImages
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
      filteredAllSongsAudios = allSongAudios
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
      filteredAllSongsIds = allSongIds
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
      filteredAllSongsLikes = allSongLikes
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
      filteredAllSongsQueues = allSongQueues
          .asMap()
          .entries
          .where((entry) =>
              filteredAllSongsTitles.contains(allSongTitles[entry.key]))
          .map((entry) => entry.value)
          .toList();
    }
  }

  // void toggleSelection(int index) {
  //   if (selectedSongIndices.contains(index)) {
  //     selectedSongIndices.remove(index);
  //   } else {
  //     selectedSongIndices.add(index);
  //   }
  //   update(); // Notify listeners about the change
  // }
}
