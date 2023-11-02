import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:edpal_music_app_ui/models/category_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  final isLoading = false.obs;
  final categoryData = CategoryData().obs;
   final RxInt selectedIndex = 0.obs;
   RxList<dynamic> data = [].obs;

  @override
  void onInit() {
    super.onInit();
    recentSongsList();
  }

  void updateCategoryData(CategoryData newData){
    categoryData.value = newData;
  }


  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> addRecentSongs({
    String? musicId,
  }) async {
    try {
    isLoading.value = true;

      // final response = await apiHelper.addSongInPlaylist(playlistId, songsId!,);
      final response = await apiHelper.addRecentlySongs(musicId: musicId);
      if (kDebugMode) {
        print(response);
      }
      isLoading.value = false;

      // success = response['success'];
      // message = response['message'];
    } catch (e) {
      if (kDebugMode) {
        print('add recent song failed: $e');
      }
      isLoading.value = false;

    }
  }

   AllSongsListModel? allSongsListModel;
    // final allSongsListModel = AllSongsListModel().obs;


  Future<void> recentSongsList() async {
    try {
    isLoading.value = true;
      final recentSongListDataModelJson = await apiHelper.recentSongsList();

      allSongsListModel =
          AllSongsListModel.fromJson(recentSongListDataModelJson);

      data.value = allSongsListModel!.data!;
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
    }
  }

}


// 1 st way
// import 'dart:convert';

// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;


// class HomeScreenController extends GetxController{
//   var isLoading = false.obs;
//   CategoryData? categoryData1; 
//   CategoryData? categoryData2; 
//   CategoryData? categoryData3; 

//   String baseurl = 'https://edpal.online/edpal.admin/public/api/';

//   fetchData1() async {
//     try {
//       isLoading(true);
//       http.Response response = await http.get(Uri.tryParse(
//         baseurl+
//           AppStrings.category1)!);
//           print("Url ${baseurl+
//           AppStrings.category1}");
          
//       if (response.statusCode == 200) {
//         var result  = jsonDecode(response.body);
//         categoryData1 = CategoryData.fromJson(result);
//          if (kDebugMode) {
//            print("categoryData1 ${categoryData1}");
//          }
//       }
//       else {
//         if (kDebugMode) {
//           print('error fetching data');
//         }
//       }
//     }
//     catch(e){
//       if (kDebugMode) {
//         print('Error while getting data is $e');
//       }
//     } 
//     finally {
//       isLoading(false);
//     }
//   }
//   fetchData2() async {
//     try {
//       isLoading(true);
//       http.Response response = await http.get(Uri.tryParse(
//         baseurl+
//           AppStrings.category2)!);
//           print("Url ${baseurl+
//           AppStrings.category2}");
          
//       if (response.statusCode == 200) {
//         var result  = jsonDecode(response.body);
//         categoryData2 = CategoryData.fromJson(result);
//          if (kDebugMode) {
//            print("categoryData2 ${categoryData2}");
//          }
//       }
//       else {
//         if (kDebugMode) {
//           print('error fetching data');
//         }
//       }
//     }
//     catch(e){
//       if (kDebugMode) {
//         print('Error while getting data is $e');
//       }
//     } 
//     finally {
//       isLoading(false);
//     }
//   }
//   fetchData3() async {
//     try {
//       isLoading(true);
//       http.Response response = await http.get(Uri.tryParse(
//         baseurl+
//           AppStrings.category3)!);
//           print("Url ${baseurl+
//           AppStrings.category3}");
          
//       if (response.statusCode == 200) {
//         var result  = jsonDecode(response.body);
//         categoryData3 = CategoryData.fromJson(result);
//          if (kDebugMode) {
//            print("categoryData3 ${categoryData3}");
//          }
//       }
//       else {
//         if (kDebugMode) {
//           print('error fetching data');
//         }
//       }
//     }
//     catch(e){
//       if (kDebugMode) {
//         print('Error while getting data is $e');
//       }
//     } 
//     finally {
//       isLoading(false);
//     }
//   }
// }




// second way
// home_screen_controller.dart

// import 'dart:convert';
// import 'package:edpal_music_app_ui/models/category_data_model.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class HomeScreenController extends GetxController {
//   var isLoading = true.obs;
//   final List<CategoryData?> categoryDataList = List.generate(3, (_) => null);
//   final String baseurl = 'https://edpal.online/edpal.admin/public/api/';

//   final List<String> categoryNames = [
//     AppStrings.category1,
//     AppStrings.category2,
//     AppStrings.category3,
//   ];

//   Future<void> fetchData(int index) async {
//     try {
//       isLoading(true);
//       final response = await http.get(Uri.tryParse(baseurl+categoryNames[index])!);
//       if (kDebugMode) {
//         print(baseurl+categoryNames[index]);
//       }

//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         categoryDataList[index] = CategoryData.fromJson(result);
//         if (kDebugMode) {
//           print("categoryData${index + 1}${categoryDataList[index]}");
//         }
//        isLoading(false);
//       } else {
//         if (kDebugMode) {
//           print('Error fetching data');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error while getting data: $e');
//       }
//     } finally {
//     //  isLoading(false);
//     }
//   }
// }
