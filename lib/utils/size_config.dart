import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class SizeConfig {
//   static late MediaQueryData _mediaQueryData;
//   static late double screenWidth;
//   static late double screenHeight;
//   static double? defaultSize;
//   static Orientation? orientation;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     orientation = _mediaQueryData.orientation;
//   }
// }

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = Get.height;
  // 896 is the layout height that designer use
  return (inputHeight / 896.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = Get.width;
  // 414 is the layout width that designer use
  return (inputWidth / 414.0) * screenWidth;
}

sizeBoxHeight(double value) {
  return SizedBox(
    height: getProportionateScreenHeight(value),
  );
}

sizeBoxWidth(double value) {
  return SizedBox(
    width: getProportionateScreenWidth(value),
  );
}
