import 'dart:developer';

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
  List<String> filteredPlaylistTitles = [];
  List<String> filteredPlaylistTracks = [];
  List<String> filteredPlaylistIds = [];
  List<List<String>> filteredPlaylisImages = [];
  List<String> playlistTitles = [];
  List<String> playlistTracks = [];
  List<String> playlistIds = [];
  List<List<String>> playlistImages = [];

  @override
  void onInit() {
    super.onInit();
    fetchMyPlaylistData();
  }

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

  // MyPlaylistDataModel? myPlaylistDataModel;
  final myPlaylistDataModel = MyPlaylistDataModel().obs;

  Future<void> fetchMyPlaylistData() async {
    try {
      isLoading.value = true;
      final myPlaylistDataModelJson = await apiHelper.fetchMyPlaylistData();

      myPlaylistDataModel.value =
          MyPlaylistDataModel.fromJson(myPlaylistDataModelJson);

      playlistTitles =
          myPlaylistDataModel.value.data!.map((item) => item.plTitle!).toList();
      playlistTracks =
          myPlaylistDataModel.value.data!.map((item) => item.tracks!).toList();
      playlistIds =
          myPlaylistDataModel.value.data!.map((item) => item.id!).toList();
      // playlistImages = myPlaylistDataModel.value.data!.map((item) => item.plImage!).expand((images) => images).toList();
      playlistImages = myPlaylistDataModel.value.data!
          .map((item) => item.plImage!) // Assuming pl_image is non-null
          .toList();
      filteredPlaylistTitles = playlistTitles;
      filteredPlaylistTracks = playlistTracks;
      filteredPlaylistIds = playlistIds;
      filteredPlaylisImages = playlistImages;

      log('$playlistImages', name: 'playlistImages');
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
