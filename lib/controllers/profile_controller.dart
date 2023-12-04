import 'dart:developer';
// import 'dart:io';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/profile_model.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  final isLoading = false.obs;
  RxString id = RxString('');
  RxString name = RxString('');
  RxString email = RxString('');
  // RxString email = ''.obs;
  // ignore: non_constant_identifier_names
  RxString mobile_no = RxString('');
  RxString age = RxString('');
  RxString gender = RxString('');
  // ignore: non_constant_identifier_names
  RxString profile_pic = RxString('');

  RxString encryptPhonnumber = RxString('');
  String emailProfile = '';

  var profileData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  ProfileModel? profileModel;

  fetchProfile() async {
    try {
      isLoading.value = true;
      // final prefs = await SharedPreferences.getInstance();
      // final authToken = prefs.getString('token') ?? '';


        // work
      final profileDataModelJson = await apiHelper.fetchProfileUser();

      profileModel = ProfileModel.fromJson(profileDataModelJson);

        
          var phoneNumber = profileModel!.profile!.mobileNo!;
          encryptPhonnumber.value = formatPhoneNumber(phoneNumber);
           log(phoneNumber,name: 'phoneNumber');
          log(emailProfile,name: 'email');


      // not work
      // final response = await apiHelper.fetchProfileUser();

      // if (response != null
      // //  && response.containsKey('profile')
      //  ) {
      //   final profile = response['profile'];

        if (kDebugMode) {
          // print('response:::::$response');
          print('id:::::${profileModel!.profile!.id!}');
          print('email:::::${profileModel!.profile!.email!}');
          print('name:::::${profileModel!.profile!.name!}');
          print('mobile_no:::::${profileModel!.profile!.mobileNo!}');
          print('age:::::${profileModel!.profile!.age!}');
          print('gender:::::${profileModel!.profile!.gender!}');
          print('profile_pic:::::${profileModel!.profile!.profilePic!}');
        }
          id.value = profileModel!.profile!.id!;
          name.value = profileModel!.profile!.name!;
          email.value = profileModel!.profile!.email!;
          mobile_no.value = profileModel!.profile!.mobileNo!;
          age.value = profileModel!.profile!.age!;
          gender.value = profileModel!.profile!.gender!;
          profile_pic.value = profileModel!.profile!.profilePic!;

          emailProfile = email.value;


          GlobVar.userId = profileModel!.profile!.id!;
          if (kDebugMode) {
            print("userId--------> ${GlobVar.userId}");
          }
          log(phoneNumber,name: 'phoneNumber');
          log(emailProfile,name: 'email');
          encryptPhonnumber.value = formatPhoneNumber(phoneNumber);
          // GlobVar.encryptPhonnumber = encryptPhonnumber;
          // GlobVar.emailProfile = emailProfile;
           log(encryptPhonnumber.value,name: 'encryptPhonnumber');
          log(emailProfile,name: 'emailProfile');
        // }
        isLoading.value = false;
      //  else {
      //   if (kDebugMode) {
      //     print('Profile not found in response');
      //   }
      //   isLoading.value = false;
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Fetch profile failed: $e');
      }
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 10) {
      return phoneNumber;
    }

    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);

    String maskedPhoneNumber = '+XXXXXXXX$lastFourDigits';

    return maskedPhoneNumber;
  }

  Future<void> editProfile({
    required String name,
    required String email,
    // ignore: non_constant_identifier_names
    required String mobile_no,
    required String age,
    required String gender,
    // ignore: non_constant_identifier_names
     profile_pic,
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
        print("profileEditResponse----> $response");
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
