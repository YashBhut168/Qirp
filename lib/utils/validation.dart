

import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:get/get.dart';

class RegPatterns {
  static final RegExp patternName = RegExp(r".{1,}");
  static final RegExp patternWalletAddress = RegExp(r".{3,}");
  static final RegExp patternOTP = RegExp(r"^[0-9]{4}$");
  // static final RegExp patternMobileNumber = RegExp(r"^[0-9]{10}$"");
  static final RegExp patternEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final RegExp patternPassword = RegExp(r".{6,}");
  static final RegExp patternDouble = RegExp(r"[^\d.-]");
  static final RegExp patternPrice = RegExp(r"^[0-9.]+\.?[0-9]*");
  static final RegExp patternDate =
      RegExp(r'^(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/\d{4}$');
  static final RegExp patternInputDate = RegExp(r'^[0-9/]*');
}

class AppValidation {
  /// Name validation
  static validateName(String value) {
    String? result;

    if (value.isEmpty) {
      result = 'Enter ${AppStrings.fullName.tr}';
    } else if (!RegPatterns.patternName.hasMatch(value)) {
      result = AppStrings.validName.tr;
    }
    return result;
  }


  /// Email validation
  static validateEmail(String value) {
    String? result;

    if (value.isEmpty) {
      result = 'Enter ${AppStrings.email.tr}';
    } else if (!RegPatterns.patternEmail.hasMatch(value)) {
      result = AppStrings.validEmail.tr;
    }
    return result;
  }


  /// Password validation
  static validatePassword(String value) {
    String? result;

    if (value.isEmpty) {
      result = 'Enter ${AppStrings.password.tr}';
    } else if (!RegPatterns.patternPassword.hasMatch(value)) {
      result = AppStrings.validPassword.tr;
    }
    return result;
  }


  // Mobile validation
  static String? validatePhone(String? value) {
    String? result;
    if (value!.isEmpty) {
      // result =
      //     AppStrings.enterPhoneNumber.tr;
    } else if (value.length != 10) {
      // result =
      //     AppStrings.enterValidPhoneNumber.tr;
    }
    return result;
  }                                 

  // /// Password validation
  // static validateAge(String value) {
  //   String? result;

  //   if (value.isEmpty) {
  //     result = 'Enter age';
  //   } else if (!RegPatterns.patternPassword.hasMatch(value)) {
  //     result = AppStrings.validPassword.tr;
  //   }
  //   return result;
  // }


}
