import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/my_playlist_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreenController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  String success = '';
  String? message = '';
  RxBool isLoading = false.obs;
  AudioPlayer? audioPlayer;

  final RxBool songExistsLocally = false.obs;

  Future<void> addPlaylist({
    required String playlistTitle,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final response = await apiHelper.addPlaylist(authToken, playlistTitle);
      if (kDebugMode) {
        print(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Add in playlist failed: $e');
      }
    }
  }

  Future<void> addSongInPlaylist({
    required String playlistId,
    songsId,
  }) async {
    try {
      // final response = await apiHelper.addSongInPlaylist(playlistId, songsId!,);
      final response = await apiHelper.addSongInPlaylist(
          playlistId: playlistId, songsId: songsId);
      if (kDebugMode) {
        print(response);
      }
      success = response['success'];
      message = response['message'];
    } catch (e) {
      if (kDebugMode) {
        print(message!);
        print('Add Song in playlist failed: $e');
      }
    }
  }

  MyPlaylistDataModel? myPlaylistDataModel;

  Future<void> fetchMyPlaylistData() async {
    isLoading.value = true;
    try {
      final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

      myPlaylistDataModel =
          MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        isLoading.value = false;
      }
    }
  }

  void setAudioPlayer(AudioPlayer newAudioPlayer) {
    audioPlayer = newAudioPlayer;
  }

  Future<void> addSongInDownloadlist({
    String? musicId,
  }) async {
    try {
      // final response = await apiHelper.addSongInPlaylist(playlistId, songsId!,);
      final response = await apiHelper.addSongInDownloadList(musicId: musicId);
      if (kDebugMode) {
        print(response);
      }
      success = response['success'];
      message = response['message'];
    } catch (e) {
      if (kDebugMode) {
        print(message!);
        print('Add Song in download list failed: $e');
      }
    }
  }

  Future<void> likedUnlikedSongs({
    String? musicId,
  }) async {
    try {
      // final response = await apiHelper.addSongInPlaylist(playlistId, songsId!,);
      final response = await apiHelper.likeUnlikedSong(musicId: musicId);
      if (kDebugMode) {
        print(response);
      }
      success = response['success'];
      message = response['message'];
    } catch (e) {
      if (kDebugMode) {
        print(message!);
        print('like unlike song failed: $e');
      }
    }
  }
}
