import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_songs_list_model.dart';
import 'package:edpal_music_app_ui/models/artist_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ArtistScreenController extends GetxController{
  final ApiHelper apiHelper = ApiHelper();
  ArtistsModel? artistsModel;
  var isLoading = false.obs;
  var artistsData = [].obs;
  var artistSongsData = [].obs;
  RxString currentPlayingTitle = RxString('');
  RxString currentPlayingImage = RxString('');
  RxString currentPlayingDesc = RxString('');
  RxString currentPlayingId = RxString('');
  RxString currentPlayingAudio = RxString('');
  RxBool currentPlayingIsLiked = false.obs;
  RxBool currentPlayingIsQueue = false.obs;

  @override
  void onInit() {
    artistList();
    super.onInit();
  }

  Future<void> artistList() async {
    try {
      isLoading.value = true;
      final artistListJson = await apiHelper.artistLists();

      artistsModel =
          ArtistsModel.fromJson(artistListJson);
      artistsData.value = artistsModel!.popularArtitst!;
      // log('artistsData ----> $artistListJson');
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

  Future<void> artistsSongsList({required String artistId}) async {
    try {
      isLoading.value = true;
      final allSongsListModelJson = GlobVar.login == false ? await apiHelper.noAuthrtistSongsList(artistId) : await apiHelper.artistSongsList(artistId);

      allSongsListModel = AllSongsListModel.fromJson(allSongsListModelJson);
      artistSongsData.value = allSongsListModel!.data!;
      isLoading.value = false;
      if (kDebugMode) {
        print('artistSongsData::::$allSongsListModelJson');
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

}