import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  //use this inorder to change font color according to dark and light theme and font styles.
  static  TextStyle constNormal = TextStyle(
      fontWeight: FontWeight.normal, color: AppColors.white, fontSize: 14);

  static textNormal({
    Color txtColor = Colors.white,
    double fontSize = 14,
    double height = 0,
    TextOverflow? textOverFlow,
    double latterSpacing = 0,
    TextDecoration? decoration,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      height: getProportionateScreenHeight(height),
      color: txtColor,
      overflow: textOverFlow,
      letterSpacing: getProportionateScreenWidth(latterSpacing),
      fontWeight: fontWeight,
      decoration: decoration,
      fontSize: getProportionateScreenHeight(fontSize),
      fontFamily: "Acumin Pro",
    );
  }
}
