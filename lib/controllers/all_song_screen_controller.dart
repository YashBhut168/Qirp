import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllSongsScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  RxBool isLoading = false.obs;

  final List<int> selectedSongIndices = [];
       List<bool>? isChecked;


  AllSongsListModel? allSongsListModel;
  Future<void> allSongsList({checkedIds}) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getBool('isLoggedIn') ?? '';
    try {
      final myPlaylistDataModelJson = login == false
          ? await apiHelper.noAuthAllSongsList()
          : await apiHelper.allSongsList();

      allSongsListModel = AllSongsListModel.fromJson(myPlaylistDataModelJson);

      isChecked = List<bool>.generate(
        allSongsListModel!.data!.length,
        (index) => checkedIds?.contains(int.parse(allSongsListModel!.data![index].id!)) ?? false,
      );
      // void initChecked() {
      //   isChecked = [];
      // }

      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
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
