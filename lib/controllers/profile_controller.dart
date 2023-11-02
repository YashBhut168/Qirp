import 'dart:io';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  final isLoading = false.obs;
  RxString id = RxString('');
  RxString name = RxString('');
  RxString email = RxString('');
  // ignore: non_constant_identifier_names
  RxString mobile_no = RxString('');
  RxString age = RxString('');
  RxString gender = RxString('');
  // ignore: non_constant_identifier_names
  RxString profile_pic = RxString('');

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }


  fetchProfile() async {
    try {
    isLoading.value = true;
      // final prefs = await SharedPreferences.getInstance();
      // final authToken = prefs.getString('token') ?? '';
      final response = await apiHelper.fetchProfile();

      if (response != null && response.containsKey('profile')) {
        final profile = response['profile'];

        if (kDebugMode) {
          print('response:::::$response');
          print('id:::::${profile['id']}');
          print('email:::::${profile['email']}');
          print('name:::::${profile['name']}');
          print('mobile_no:::::${profile['mobile_no']}');
          print('age:::::${profile['age']}');
          print('gender:::::${profile['gender']}');
          print('profile_pic:::::${profile['profile_pic']}');

          id.value = profile['id'] ?? '';
          name.value = profile['name'] ?? '';
          email.value = profile['email'] ?? '';
          mobile_no.value = profile['mobile_no'] ?? '';
          age.value = profile['age'] ?? '';
          gender.value = profile['gender'] ?? '';
          profile_pic.value = profile['profile_pic'] ?? '';
        }
          isLoading.value = false;
      } else {
        if (kDebugMode) {
          print('Profile not found in response');
        }
          isLoading.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Fetch profile failed: $e');
      }
        isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProfile({
    required String name,
    required String email,
    // ignore: non_constant_identifier_names
    required String mobile_no,
    required String age,
    required String gender,
    // ignore: non_constant_identifier_names
    required File profile_pic,
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final response = await apiHelper.editProfile(
        authToken,
        name,
        email,
        mobile_no,
        age,
        gender,
        profile_pic,
      );
      if (kDebugMode) {
        print(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('profile edit failed: $e');
      }
      isLoading.value = false;

    } finally {
      isLoading.value = false;
    }
  }
}
