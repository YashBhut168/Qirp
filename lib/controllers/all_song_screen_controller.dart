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
  
  var isLikeAllSongData = [].obs;


  AllSongsListModel? allSongsListModel;
  Future<void> allSongsList({checkedIds}) async {
    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getBool('isLoggedIn') ?? '';
    try {
    isLoading.value = true;
      final myPlaylistDataModelJson = login == false
          ? await apiHelper.noAuthAllSongsList()
          : await apiHelper.allSongsList();

      allSongsListModel = AllSongsListModel.fromJson(myPlaylistDataModelJson);

       isLikeAllSongData.value = allSongsListModel!.data!;

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
