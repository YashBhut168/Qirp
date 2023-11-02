import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  final RxBool isLoading = false.obs;

  Future<void> registerUser({
    String? userName,
    String? email,
    String? password,
    String? mobileNo,
  }) async {
    isLoading.value = true;
    try {
      final response = await apiHelper.registerUser(
        userName ?? '',
        email ?? '',
        password ?? '',
        mobileNo ?? '',
      );
      if (kDebugMode) {
        print(response);
      }
      String token = response['data']['token'];
      if (kDebugMode) {
        log("login token::$token");
      }
      log("${GlobVar.login}", name: 'library login');
      final prefs = await SharedPreferences.getInstance();
       await prefs.setString('token', token);
      await prefs.setBool('isLoggedIn', true);
      GlobVar.login = true;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      snackBar('Registration failed: $e');
      if (kDebugMode) {
        print('Registration failed: $e');
      }
    
    }
  }

  loginUser({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final response = await apiHelper.loginUser(email, password);
      if (response['success'] == true) {
        GlobVar.login = true;

        if (kDebugMode) {
          print(response);
        }
        String token = response['data']['token'];
        // if (kDebugMode) {
        log("Login token::$token");
        // }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setBool('isLoggedIn', true);
        isLoading.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('login failed: $e');
      }
      isLoading.value = false;
    }
  }

  Future<void> socialLoginUser(
      {required String email,
      required String userName,
      required String loginType}) async {
    try {
      final response =
          await apiHelper.socialLoginUser(email, userName, loginType);
      if (kDebugMode) {
        print(response);
      }
      String token = response['data']['token'];

      log("Login token::$token");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      if (kDebugMode) {
        print('social login failed: $e');
      }
    }
  }
}
